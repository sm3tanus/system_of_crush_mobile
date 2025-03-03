import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      backgroundColor: Color(0xFF1B1B1B),
      selectedIndex: 0,
      onDestinationSelected: (index){},
      destinations: const [   
      ],
    );
  }
}
