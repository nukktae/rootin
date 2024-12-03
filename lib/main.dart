import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io' show Platform;

import 'screens/main_screen.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  developer.log("Background message received: ${message.notification?.title}");
  showNotification(message);
}

Future<void> main() async {
  // Ensure proper initialization order
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Load environment variables first
    await dotenv.load();
    
    // Initialize Firebase with error handling
    await Firebase.initializeApp().timeout(
      const Duration(seconds: 5),
      onTimeout: () => throw Exception('Firebase initialization timeout'),
    );

    if (Platform.isIOS) {
      try {
        // Request notification permissions first
        await FirebaseMessaging.instance.requestPermission(
          alert: true,
          badge: true,
          sound: true,
          provisional: true
        );

        // Set foreground notification options
        await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );

        // Try to get APNS token with retry logic
        String? apnsToken;
        int retryCount = 0;
        while (retryCount < 3 && apnsToken == null) {
          try {
            apnsToken = await FirebaseMessaging.instance.getAPNSToken();
            if (apnsToken != null) {
              // Explicitly get FCM token after APNS token is available
              await FirebaseMessaging.instance.getToken(
                vapidKey: dotenv.env['VAPID_KEY'],
              );
              break;
            }
            retryCount++;
            if (retryCount < 3) {
              await Future.delayed(const Duration(seconds: 2));
            }
          } catch (e) {
            // Suppress the APNS token error
            if (!e.toString().contains('apns-token-not-set')) {
              developer.log('Attempt $retryCount to get APNS token failed: $e');
            }
          }
        }
      } catch (e) {
        // Suppress the specific APNS token error
        if (!e.toString().contains('apns-token-not-set')) {
          developer.log('iOS notification setup error: $e');
        }
      }
    }

    // Initialize other services
    await _requestPermissions();
    await _setupForegroundNotification();
    
    // Set up background message handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await initializeNotifications();

    runApp(const MyApp());
  } catch (e, stackTrace) {
    debugPrint('Initialization error: $e');
    debugPrint('Stack trace: $stackTrace');
    runApp(const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Failed to initialize app. Please restart.'),
        ),
      ),
    ));
  }
}

Future<void> _requestPermissions() async {
  // Request notification permissions
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: true,
    badge: true,
    carPlay: true,
    criticalAlert: true,
    provisional: false,
    sound: true,
  );

  // Request Bluetooth permissions
  if (Platform.isAndroid) {
    final status = await Permission.bluetooth.request();
    final scanStatus = await Permission.bluetoothScan.request();
    final connectStatus = await Permission.bluetoothConnect.request();
    final locationStatus = await Permission.location.request();
    
    developer.log('Bluetooth permission: $status');
    developer.log('Bluetooth scan permission: $scanStatus');
    developer.log('Bluetooth connect permission: $connectStatus');
    developer.log('Location permission: $locationStatus');
  }
}

Future<void> _setupForegroundNotification() async {
  // Listen for foreground messages
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    developer.log('Got a message whilst in the foreground!');
    developer.log('Message data: ${message.data}');

    if (message.notification != null) {
      developer.log(
        'Message also contained a notification: ${message.notification!.title}',
      );
      
      // Force show the notification
      _showForegroundNotification(message);
    }
  });
}

Future<void> _showForegroundNotification(RemoteMessage message) async {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;

  // If `notification` is not null, we'll create and show it
  if (notification != null) {
    // Create a unique notification ID
    final notificationId = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    await flutterLocalNotificationsPlugin.show(
      notificationId,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel', // Change this to match your channel ID
          'High Importance Notifications',
          channelDescription: 'This channel is used for important notifications.',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
          icon: android?.smallIcon ?? '@mipmap/ic_launcher',
          // Force the notification to show
          fullScreenIntent: true,
          visibility: NotificationVisibility.public,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          interruptionLevel: InterruptionLevel.timeSensitive,
        ),
      ),
    );
  }
}

Future<void> initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
    onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload) async {
      developer.log('Received iOS notification: $title');
    },
  );

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      developer.log('Notification clicked');
    },
  );

  // Create notification channel for Android
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.max,
    playSound: true,
    enableVibration: true,
    showBadge: true,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
}

Future<void> registerToken(String token) async {
  final String? fcmToken = dotenv.env['FCM_TOKEN'];

  if (fcmToken == null || fcmToken.isEmpty) {
    developer.log("Error: FCM Token is missing in the .env file");
    return;
  }

  final url = Uri.parse('https://api.rootin.me/v1/register');

  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $fcmToken',
  };

  final body = jsonEncode({'fcm_token': token});

  try {
    final response = await http.put(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      developer.log("Token successfully registered.");
    } else {
      developer.log("Failed to register token. Status code: ${response.statusCode}");
    }
  } catch (e) {
    developer.log("Error occurred during token registration: $e");
  }
}

void showNotification(RemoteMessage message) async {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;

  if (notification != null) {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'default_channel_id',
      'Default Channel',
      description: 'This is the default notification channel',
      importance: Importance.max,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          importance: Importance.max,
          priority: Priority.high,
          icon: android?.smallIcon ?? '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rootin App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}
