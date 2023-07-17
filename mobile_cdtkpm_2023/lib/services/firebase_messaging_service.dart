import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseMessagingService {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _notiPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    await _firebaseMessaging.requestPermission(
        alert: true, badge: true, sound: true);

    _firebaseMessaging
        .getToken()
        .then((token) => print('Firebase token: $token'));

    _notiPlugin.initialize(const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher')));
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      FirebaseMessagingService.showNotification(message);
    });
  }

  static void showNotification(RemoteMessage message) {
    const NotificationDetails notiDetails = NotificationDetails(
        android: AndroidNotificationDetails(
            'com.example.push_notification', 'push_notification',
            importance: Importance.max, priority: Priority.high));
    _notiPlugin.show(DateTime.now().microsecond, message.notification!.title,
        message.notification!.body, notiDetails,
        payload: message.data.toString());
  }
}
