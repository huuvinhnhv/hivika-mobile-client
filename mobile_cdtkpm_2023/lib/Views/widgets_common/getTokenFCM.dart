// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'dart:io';
// import 'package:firebase_messaging/firebase_messaging.dart';

// class LocalNotification {
//   static final FlutterLocalNotificationsPlugin _notiPlugin =
//       FlutterLocalNotificationsPlugin();

//   static void initialize() {
//     const InitializationSettings initialSettings = InitializationSettings(
//       android: AndroidInitializationSettings(
//         '@mipmap/ic_launcher',
//       ),
//     );
//     _notiPlugin.initialize(initialSettings,
//         onDidReceiveNotificationResponse: (NotificationResponse details) {
//       print('onDidReceiveNotificationResponse Function');
//       print(details.payload);
//       print(details.payload != null);
//     });
//   }

//   static void showNotification(RemoteMessage message) {
//     const NotificationDetails notiDetails =  NotificationDetails(
//       android: AndroidNotificationDetails(
//         'com.example.push_notification',
//         'push_notification',
//         importance: Importance.max,
//         priority: Priority.high,
//       ),
//     );
//     _notiPlugin.show(
//       DateTime.now().microsecond,
//       message.notification!.title,
//       message.notification!.body,
//       notiDetails,
//       payload: message.data.toString(),
//     );
//   }
// }

// Future<String?> getFcmToken() async {
//   if (Platform.isIOS) {
//     String? fcmKey = await FirebaseMessaging.instance.getToken();
//     return fcmKey;
//   }
//   String? fcmKey = await FirebaseMessaging.instance.getToken();
//   return fcmKey;
// }

// void _incrementCounter() async {
//   String? fcmKey = await getFcmToken();
//   print('FCM Key : $fcmKey');
// }
