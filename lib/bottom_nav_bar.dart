import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Color(0xFF1B1B1B),
      unselectedItemColor: Color(0xFFd9d9d9),
      selectedItemColor: Colors.amber,
      selectedFontSize: 16,
      selectedLabelStyle: TextStyle(
        fontWeight: FontWeight.w600
      ),
      currentIndex: currentIndex,
      onTap: onTap,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Заявки'),
        BottomNavigationBarItem(icon: Icon(Icons.play_arrow), label: 'Текущие'),
        BottomNavigationBarItem(icon: Icon(Icons.room), label: 'Карта'),
      ],
    );
  }
}
