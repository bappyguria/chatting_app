import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'login/login_screen.dart';
import 'home/main_bottom_nav_bar.dart';

class OJANTA_SplashScreen extends StatefulWidget {
  const OJANTA_SplashScreen({super.key});

  @override
  State<OJANTA_SplashScreen> createState() => _OJANTA_SplashScreenState();
}

class _OJANTA_SplashScreenState extends State<OJANTA_SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  void _navigate() async {
    final box = Hive.box('myBox');

    Timer(const Duration(seconds: 3), () {
      final email = box.get('email', defaultValue: '');
      if (email.isEmpty) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainBottomNavBar()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'OJANTA',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}