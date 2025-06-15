import 'dart:convert';
import 'dart:ui';
import 'package:crystal_skin_mobile/helpers/colors.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationHandler {
  final FlutterLocalNotificationsPlugin _notificationsPlugin;

  NotificationHandler(this._notificationsPlugin);

  Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    await _notificationsPlugin.initialize(initializationSettings);

    await _notificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
  }


  Future<void> showNotification(List<dynamic> messageList) async {
    if (messageList.isEmpty) return;

    final message = messageList[0] as Map<String, dynamic>;

    final String body = message['message'] ?? 'Nova notifikacija';
    final String? lineName = message['Name'];
    final String? time = message['time'];

    final String notificationBody = lineName != null && time != null
        ? 'Linija $lineName • $time\n$body'
        : body;

    final BigTextStyleInformation bigTextStyle = BigTextStyleInformation(
      notificationBody,
      htmlFormatBigText: true,
    );

    final AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'crystal_skin_notifications',
      'Notifikacija',
      channelDescription: 'Notifikacije Crystal Skin sistema',
      importance: Importance.max,
      priority: Priority.high,
      styleInformation: bigTextStyle,
      color: app_color,
      autoCancel: true,
      timeoutAfter: 86400000,
      showWhen: true,
    );

    final NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await _notificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      'Obaveštenje',
      message['message'] ?? 'Nova notifikacija',
      platformChannelSpecifics,
      payload: jsonEncode(message),
    );
  }
}