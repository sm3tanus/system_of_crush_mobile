import 'package:flutter/material.dart';

ThemeData themeData = ThemeData(
  fontFamily: 'Raleway',
  
);

class GradientContainer extends StatelessWidget {
  final Widget child;

   const GradientContainer({super.key, required this.child});

   @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF1B1B1B), // Основной темный цвет по бокам
            Color(0xFF222222), // Чуть светлее ближе к центру
            Color(0xFF4A4A4A), // Светлая полоска в центре
            Color(0xFF222222), // Чуть светлее ближе к краям
            Color(0xFF1B1B1B), // Основной темный цвет по бокам
          ],
          stops: [0.0, 0.3, 0.5, 0.7, 1.0], // Позиции цветов
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: child,
    );
  }
}

