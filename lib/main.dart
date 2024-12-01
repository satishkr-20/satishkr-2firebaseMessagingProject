import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'local_notifications/local_noti_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  NotificationService.initialize();
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
// Set up background message handler
//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Handle when the app is opened from a notification (in the foreground)
  // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //   print(
  //       'Message opened when app is in foreground: ${message.notification?.title}');
  //   // Handle the message when the app is in the foreground
  //   _handleMessage(message);
  // });
  //
  // // Handle when the app is running in the foreground but message is received (not opened)
  // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //   print('Message received in foreground: ${message.notification?.title}');
  //   // Handle the message when the app is in the foreground
  //   _handleMessage(message);
  // });
  runApp(const MyApp());
}

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   print('Handling a background message: ${message.messageId}');
// }
//

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   print('Handling a background message: ${message.messageId}');
//
//   // Check if the app was in the background or terminated
//   if (message.data.isNotEmpty) {
//     // Your logic to handle the message data
//     print('Background message data: ${message.data}');
//   }
//
//   // If the message contains a notification
//   if (message.notification != null) {
//     print('Message contains a notification: ${message.notification!.title}');
//   }
//
//   // Handling specific actions (e.g., forgiveness or termination)
//   if (message.data.containsKey('action')) {
//     String action = message.data['action'] ?? '';
//     if (action == 'forgive') {
//       // Logic for forgiveness action
//       print('Forgiveness action triggered');
//       // You can execute logic here, such as forgiving a user
//     } else if (action == 'terminate') {
//       // Logic for terminate action
//       print('Termination action triggered');
//       // You can perform actions like logging out the user or closing specific services
//     }
//   }
// }
//...

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message: ${message.messageId}');
  // Handle background message (e.g., push notification data)
  _handleMessage(message);
}

// Handle the message (can be used for both foreground and background)
void _handleMessage(RemoteMessage message) {
  if (message.data.containsKey('action')) {
    String action = message.data['action'] ?? '';
    if (action == 'forgive') {
      print('Forgiveness action triggered');
      // Execute your forgiveness action here
    } else if (action == 'terminate') {
      print('Termination action triggered');
      // Execute your termination action here
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  String? _fcmToken;

  @override
  void initState() {
    super.initState();
    getToken();
  }

  Future<void> getToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Request notification permissions (optional)
    await messaging.requestPermission();

    // Get the token
    String? token = await messaging.getToken();
    setState(() {
      _fcmToken = token;
    });

    print("FCM Token: $_fcmToken");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
