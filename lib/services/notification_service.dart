import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:developer' as developer;
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'dart:math';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final _localNotifications = FlutterLocalNotificationsPlugin();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  
  Future<void> initialize() async {
    await _initializeLocalNotifications();
    await _requestPermissions();
    await uploadNotificationImage();
  }

  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        developer.log('Notification tapped: ${details.payload}');
      },
    );
  }

  Future<void> _requestPermissions() async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> showNotification(RemoteMessage message) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final imagePath = '${tempDir.path}/notification_image.png';
      
      // Copy the asset to temporary directory
      final data = await rootBundle.load('assets/images/notilogo.png');
      final bytes = data.buffer.asUint8List();
      await File(imagePath).writeAsBytes(bytes);

      final DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        attachments: [
          DarwinNotificationAttachment(
            imagePath,
            identifier: 'notification_icon'
          )
        ]
      );

      final details = NotificationDetails(iOS: iosDetails);

      // Use a random number between 0-10000 for notification ID
      final random = Random();
      final notificationId = random.nextInt(10000);

      await _localNotifications.show(
        notificationId,
        message.notification?.title ?? 'New Message',
        message.notification?.body ?? '',
        details,
      );
    } catch (e) {
      print('Error in showNotification: $e');
      print('Stack trace: ${StackTrace.current}');
    }
  }

  Future<void> uploadNotificationImage() async {
    try {
      final ref = _storage.ref().child('notification_images/rootinnotif.png');
      
      final data = await rootBundle.load('assets/images/rootinnotif.png');
      final bytes = data.buffer.asUint8List();
      
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/temp_notification_image.png');
      await tempFile.writeAsBytes(bytes);
      
      await ref.putFile(tempFile);
      final String downloadURL = await ref.getDownloadURL();
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('notification_image_url', downloadURL);
      
      developer.log('Notification image uploaded successfully: $downloadURL');
      
      await tempFile.delete();
    } catch (e) {
      developer.log('Error uploading notification image: $e');
    }
  }

  Future<String> _downloadAndSaveImage(String imageUrl) async {
    try {
      developer.log('Downloading image from: $imageUrl');
      final response = await http.get(Uri.parse(imageUrl));
      
      if (response.statusCode != 200) {
        throw Exception('Failed to download image: ${response.statusCode}');
      }
      
      final bytes = response.bodyBytes;
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/notification_image_${DateTime.now().millisecondsSinceEpoch}.jpg');
      await tempFile.writeAsBytes(bytes);
      
      developer.log('Image saved to: ${tempFile.path}');
      return tempFile.path;
    } catch (e) {
      developer.log('Error downloading image: $e');
      rethrow;
    }
  }

  Future<void> testLocalImageNotification() async {
    try {
      print('Testing local image notification...');
      
      // Get the app's documents directory
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = '${directory.path}/rootinnotif.png';
      
      print('Image path for notification: $imagePath');
      
      // Copy the asset to documents directory
      final data = await rootBundle.load('assets/images/rootinnotif.png');
      print('Asset loaded successfully');
      
      final bytes = data.buffer.asUint8List();
      final file = File(imagePath);
      await file.writeAsBytes(bytes);
      print('Image written to documents directory: ${file.path}');

      // Verify file exists
      if (!await file.exists()) {
        throw Exception('Image file not found at path: $imagePath');
      }

      final DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        attachments: [
          DarwinNotificationAttachment(
            file.path,
            identifier: 'notification_icon'
          )
        ],
        threadIdentifier: 'custom_notification_thread'
      );

      final details = NotificationDetails(iOS: iosDetails);

      // Use a simple integer for notification ID
      await _localNotifications.show(
        1, // Simple integer ID instead of milliseconds
        'Custom Icon Test',
        'This notification should show the custom rootin icon',
        details,
      );
      
      print('Test notification sent successfully with image path: ${file.path}');
    } catch (e) {
      print('Error in test notification: $e');
      print('Stack trace: ${StackTrace.current}');
    }
  }
}