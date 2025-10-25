import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box('myBox');
    final email = box.get('email', defaultValue: 'No email');

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.person, size: 100),
          const SizedBox(height: 20),
          Text('Email: $email', style: const TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}
