import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  static bool _isInitialized = false;

  static Future<void> initialize() async {
    if (_isInitialized) return;

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(initSettings);
    _isInitialized = true;
  }

  static Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    if (!_isInitialized) await initialize();

    const androidDetails = AndroidNotificationDetails(
      'smart_city_channel',
      'Умный Город',
      channelDescription: 'Уведомления от приложения Умный Город',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails();

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      body,
      details,
      payload: payload,
    );
  }

  static Future<void> showReportStatusNotification({
    required String reportTitle,
    required String status,
  }) async {
    await showNotification(
      title: 'Обновление репорта',
      body: 'Репорт "$reportTitle" получил статус: $status',
    );
  }

  static Future<void> showVolunteerEventNotification({
    required String eventTitle,
    required String message,
  }) async {
    await showNotification(
      title: 'Волонтёрское мероприятие',
      body: '$eventTitle: $message',
    );
  }

  static Future<void> showChatMessageNotification({
    required String chatName,
    required String message,
  }) async {
    await showNotification(
      title: 'Новое сообщение в чате $chatName',
      body: message,
    );
  }

  static Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }
}
