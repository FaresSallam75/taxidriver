// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final _notifications = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOS = DarwinInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: iOS);

    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (details) {
        print("Notification tapped with payload: ${details.payload}");
      },
    );
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      channelDescription: 'channel_description',
      importance: Importance.max,
      priority: Priority.high,
    );
    const iOSDetails = DarwinNotificationDetails();
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );
    await _notifications.show(id, title, body, details, payload: payload);
  }
}

class LocalNotificationTest extends StatelessWidget {
  final NotificationService _notificationService = NotificationService();

  LocalNotificationTest({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Local Notifications Demo',
      home: Scaffold(
        appBar: AppBar(title: Text("Local Notification")),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              _notificationService.showNotification(
                id: 0,
                title: "Hello!",
                body: "This is a local notification.",
                payload: "payload_data_here",
              );
            },
            child: Text("Show Notification"),
          ),
        ),
      ),
    );
  }
}
