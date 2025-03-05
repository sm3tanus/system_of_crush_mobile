import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class FloatingNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const FloatingNavBar({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 30,
          right: 30,
          bottom: 10, 
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Color(0xFF1B1B1B),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 5)),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(Iconsax.document1, color: currentIndex == 0 ? Color.fromARGB(255, 80, 139, 151) : Colors.white),
                  onPressed: () => onTap(0),
                ),
                IconButton(
                  icon: Icon(Iconsax.play, color: currentIndex == 1 ? Color.fromARGB(255, 80, 139, 151) : Colors.white),
                  onPressed: () => onTap(1),
                ),
                IconButton(
                  icon: Icon(Iconsax.location, color: currentIndex == 2 ? Color.fromARGB(255, 80, 139, 151) : Colors.white),
                  onPressed: () => onTap(2),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
