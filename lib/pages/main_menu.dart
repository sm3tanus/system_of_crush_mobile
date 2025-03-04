import 'package:flutter/material.dart';
import 'package:system_of_crush_mobile_app/bottom_nav_bar.dart';
import 'package:system_of_crush_mobile_app/pages/applications.dart';
import 'package:system_of_crush_mobile_app/pages/current_applications.dart';
import 'package:system_of_crush_mobile_app/pages/map.dart';




class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    ApplicationsPage(),
    CurrentApplicationsPage(),
    MapPage(),
  ];

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _screens[_selectedIndex],
          FloatingNavBar(currentIndex: _selectedIndex, onTap: _onTabSelected),
        ],
      ),
    );
  }
}
