import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:developer' as developer;
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

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
    print('========= Detailed FCM Notification Debug =========');
    print('Message data: ${message.data}');

    try {
      final tempDir = await getTemporaryDirectory();
      final imagePath = '${tempDir.path}/notification_image.png';
      
      // Copy the asset to temporary directory
      final data = await rootBundle.load('assets/images/rootin_1x.png');
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

      await _localNotifications.show(
        message.hashCode,
        message.notification?.title ?? 'New Message',
        message.notification?.body ?? '',
        details,
      );
    } catch (e) {
      print('Error in showNotification: $e');
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
      
      // Create a test message
      final testMessage = RemoteMessage(
        messageId: 'test_${DateTime.now().millisecondsSinceEpoch}',
        notification: const RemoteNotification(
          title: 'Test Local Image',
          body: 'This is a test notification with a local image',
        ),
      );

      // Show notification with local image
      await showNotification(testMessage);
      print('Test notification sent successfully');
      
    } catch (e) {
      print('Error sending test notification: $e');
    }
  }
}