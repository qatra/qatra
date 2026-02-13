import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'firebase_options.dart';
import 'Screens/splash.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MyApp(),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  @override
  void initState() {
//    configureNotifications();
    subscripeAdmin();
    getDeviceToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      title: 'قطرة',
      theme: new ThemeData(primarySwatch: Colors.blue),
    );
  }

  void configureNotifications() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("massssssageee --- : ${message.data}");
    });
  }

  void getDeviceToken() async {
    String? devicetoken = await _firebaseMessaging.getToken();
    print("device Token : $devicetoken");
  }

  void subscripeAdmin() {
    if (!kIsWeb) {
      _firebaseMessaging.subscribeToTopic("Admin");
    }
  }
}
