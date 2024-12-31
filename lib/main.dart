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
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'providers/language_provider.dart';
import 'themes/app_theme.dart';

import 'screens/main_screen.dart';
import 'firebase_options.dart';
import 'services/notification_service.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  developer.log('Background message received: ${message.data}');
  await NotificationService().showNotification(message);
}

Future<void> _setupForegroundNotification() async {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('========= Foreground Message Debug =========');
    print('Message data: ${message.data}');
    print('Raw message: ${message.toMap()}');
    
    if (message.notification != null) {
      print('Notification content: ${message.notification!.toMap()}');
    }
    
    if (message.data.containsKey('body')) {
      try {
        final bodyData = jsonDecode(message.data['body']);
        print('Parsed body data: $bodyData');
      } catch (e) {
        print('Error parsing body data: $e');
      }
    }
    print('=========================================');
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  print('=== TEST LOG: Starting app initialization... ===');
  developer.log('=== TEST LOG: Starting app initialization... ===');

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print('Firebase initialized');
  developer.log('Firebase initialized');

  // Initialize notifications
  final notificationService = NotificationService();
  await notificationService.initialize();
  print('Notification service initialized');
  developer.log('Notification service initialized');

  // Set up FCM
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await _setupForegroundNotification();
  print('FCM handlers set up');
  developer.log('FCM handlers set up');
  
  // Request permissions
  final settings = await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );
  developer.log('Notification permission status: ${settings.authorizationStatus}');

  // Set up foreground notification presentation options
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  developer.log('Foreground notification options set');

  // Get FCM token
  final token = await FirebaseMessaging.instance.getToken();
  print('=================== FCM TOKEN ===================');
  print(token);
  print('===============================================');
  developer.log('FCM Token: $token');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

Future<void> _requestNotificationPermissions() async {
  final messaging = FirebaseMessaging.instance;
  
  await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
    provisional: false,
  );

  await messaging.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
}

Future<void> _initializeLocalNotifications() async {
  const initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  const initializationSettingsIOS = DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );
  
  const initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (details) {
      // Handle notification tap
      developer.log('Notification tapped: ${details.payload}');
    },
  );
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

Future<void> showNotification(RemoteMessage message) async {
  const androidDetails = AndroidNotificationDetails(
    'high_importance_channel',
    'High Importance Notifications',
    importance: Importance.max,
    priority: Priority.high,
    showWhen: true,
  );

  const iosDetails = DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );

  const details = NotificationDetails(
    android: androidDetails,
    iOS: iosDetails,
  );

  await flutterLocalNotificationsPlugin.show(
    message.hashCode,
    message.notification?.title ?? 'New Message',
    message.notification?.body ?? '',
    details,
    payload: message.data.toString(),
  );
}

Future<void> _setupNotificationChannel() async {
  if (Platform.isAndroid) {
    const androidChannel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return MaterialApp(
          title: 'Your App',
          theme: AppTheme.theme,
          localizationsDelegates: const [
            AppLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // English
            Locale('ko', ''), // Korean
          ],
          locale: languageProvider.currentLocale,
          home: const MainScreen(),
        );
      },
    );
  }
}