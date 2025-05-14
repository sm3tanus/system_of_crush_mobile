import 'package:system_of_crush_mobile_app/pages/auth.dart';
import 'package:system_of_crush_mobile_app/pages/landing.dart';
import 'package:system_of_crush_mobile_app/pages/main_menu.dart';
import 'package:system_of_crush_mobile_app/pages/map.dart';

final routes = {
  '/': (context) => LandingPage(),
  '/auth': (context) => AuthPage(),
  '/menu': (context) => MainScreen(),
  '/map': (context) => MapPage(),
};