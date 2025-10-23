import 'dart:async';
import 'package:chatting_app/screens/login_screen.dart';
import 'package:flutter/material.dart';

class OJANTA_SplashScreen extends StatefulWidget {
  const OJANTA_SplashScreen({Key? key}) : super(key: key);

  @override
  State<OJANTA_SplashScreen> createState() => _OJANTA_SplashScreenState();
}

class _OJANTA_SplashScreenState extends State<OJANTA_SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 3),
          () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // You can add your logo here
            // Image.asset('assets/ojanta_logo.png', height: 150),
            // const SizedBox(height: 20),
            const Text(
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