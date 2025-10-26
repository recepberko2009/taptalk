// lib/main.dart

import 'package:TapTalk/screens/forgot_password_dialog.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/main_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // FIREBASE OPTIONS EKLE - BU ÇOK ÖNEMLİ!
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // BU SATIR EKLENDİ
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TapTalk',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(),
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterScreen(),
        '/main': (context) => MainScreen(),
        '/sifre': (context) => ForgotPasswordDialog(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
