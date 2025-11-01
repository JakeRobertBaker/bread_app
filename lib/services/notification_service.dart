import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  Future<void> init() async {
    const androidInitialize = AndroidInitializationSettings('app_icon');
    const iOSInitialize = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );
    const initializationsSettings = InitializationSettings(
      android: androidInitialize,
      iOS: iOSInitialize,
    );

    await _notifications.initialize(
      initializationsSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );
  }

  Future<void> showStepNotification(String stepName, String description) async {
    const androidDetails = AndroidNotificationDetails(
      'bread_steps_channel',
      'Bread Steps',
      channelDescription: 'Notifications for bread making steps',
      importance: Importance.max,
      priority: Priority.high,
      ongoing: true, // Makes notification persistent
      autoCancel: false, // Prevents auto-dismissal
    );

    const iOSDetails = DarwinNotificationDetails(
      presentSound: true,
      presentBadge: true,
      presentAlert: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000, // Unique ID based on time
      'Time for: $stepName',
      description,
      notificationDetails,
    );
  }

  void _onNotificationTap(NotificationResponse response) {
    // Handle notification tap - could navigate to specific step
  }

  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }
}