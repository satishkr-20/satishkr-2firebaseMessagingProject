import 'dart:developer';
import 'dart:ffi';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../firebase_options.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  static Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    firebaseMessaging.getToken();
    firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showMessage(message.notification?.title, message.notification?.body);
      print('showMessage check ....---->> ${showMessage}');
      log('Handling a foreground message: ${message.messageId}');
      log('Message data: ${message.notification?.title ?? "------check this ---"}');
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    // await Firebase.initializeApp();
    log("Handling a background message: ${message.messageId}");
    log('Message data: ${message.notification}');
    log('Message notification title: ${message.notification?.title}');
    log('Message notification message: ${message.notification?.body}');
  }
}

void showMessage(String? title, String? body) {
  if (title != null && body != null) {
    Fluttertoast.showToast(msg: title, toastLength: Toast.LENGTH_LONG);
    final snackBar = SnackBar(content: Text('$title: $body'));
    // ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
