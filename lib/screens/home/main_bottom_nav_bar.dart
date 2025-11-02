import 'package:chatting_app/friend_request_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../profile_screen/profile_screen.dart';
import '../user_list/user_list.dart';

import 'home_screen.dart';
import '../login/login_screen.dart';


class MainBottomNavBar extends StatefulWidget {
  const MainBottomNavBar({super.key});

  @override
  State<MainBottomNavBar> createState() => _MainBottomNavBarState();
}

class _MainBottomNavBarState extends State<MainBottomNavBar> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
     FriendRequestScreen(),
    const UserListScreen(),
    const ProfileScreen(),
  ];

  void _logout() async {
    final box = Hive.box('myBox');

    await box.clear(); // Clear all saved data
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle(_currentIndex)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: (){
              setState(() {
                _logout();
              });
            },
          )
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() {
          _currentIndex = index;
        }),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'User List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  String _getTitle(int index) {
    switch (index) {
      case 0:
        return 'Home';
      case 1:
        return 'User List';
      case 2:
        return 'Profile';
      default:
        return '';
    }
  }
}

// Example Screens





