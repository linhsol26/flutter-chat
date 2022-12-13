// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

// bool isFlutterLocalNotificationsInitialized = false;

// Future<void> setupFlutterNotifications() async {
//   if (isFlutterLocalNotificationsInitialized) {
//     return;
//   }

//   await AwesomeNotifications().initialize(
//       null,
//       [
//         NotificationChannel(
//           importance: NotificationImportance.Max,
//           channelKey: 'chat_channel',
//           channelName: 'Chat notifications',
//           channelDescription: 'Notification channel for chatting',
//         )
//       ],
//       debug: true);

//   /// Update the iOS foreground notification presentation options to allow
//   /// heads up notifications.
//   await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
//     alert: true,
//     badge: true,
//     sound: true,
//   );

//   isFlutterLocalNotificationsInitialized = true;
// }

// Future<bool> createNotification({
//   required String senderId,
//   required String text,
//   required String senderName,
// }) async {
//   return await AwesomeNotifications().createNotification(
//     content: NotificationContent(
//       id: DateTime.now().microsecond,
//       channelKey: 'chat_channel',
//       payload: {
//         'sender_id': senderId,
//       },
//       category: NotificationCategory.Message,
//       notificationLayout: NotificationLayout.Messaging,
//       title: senderName,
//       body: text,
//     ),
//   );
// }
