// lib/screens/splash_screen.dart
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  _navigateToNext() async {
    await Future.delayed(Duration(seconds: 3));
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        // ✅ SafeArea eklendi
        child: Center(
          child: SingleChildScrollView(
            // ✅ Scroll ekledik
            child: Padding(
              padding: EdgeInsets.all(20), // ✅ Padding eklendi
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min, // ✅ min yaptık
                children: [
                  // Resim - boyutları küçülttük
                  Image.asset(
                    "assets/images/uygresinm.jpg",
                    width: 120, // ✅ 150'den 120'ye
                    height: 120, // ✅ 150'den 120'ye
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            'TT',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32, // ✅ 40'tan 32'ye
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 16), // ✅ 20'den 16'ya
                  Text(
                    'TapTalk',
                    style: TextStyle(
                      fontSize: 28, // ✅ 32'den 28'e
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 8), // ✅ 10'dan 8'e
                  Text(
                    '© Copyright 2025 Akten App',
                    style: TextStyle(
                      fontSize: 11, // ✅ 12'den 11'e
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
