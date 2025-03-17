import 'package:flutter/material.dart';

ThemeData themeData = ThemeData(
  fontFamily: 'Montserrat',
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      elevation: WidgetStateProperty.all(0),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
      ),
      padding: WidgetStateProperty.all(EdgeInsets.zero),
      backgroundColor: WidgetStatePropertyAll(Colors.transparent),
      overlayColor: WidgetStatePropertyAll(
        Color.fromARGB(255, 80, 139, 151),
      ),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStatePropertyAll(
        Color(0xFF1B1B1B),
      ),
      backgroundColor: WidgetStatePropertyAll(Colors.transparent),
      overlayColor: WidgetStatePropertyAll(
        Color.fromARGB(255, 80, 139, 151),
      ),
    ),
  ),
  iconButtonTheme: IconButtonThemeData(
    style: ButtonStyle(
      overlayColor: WidgetStatePropertyAll(
        Color.fromARGB(255, 80, 139, 151),
      ),
    ),
  ),
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
