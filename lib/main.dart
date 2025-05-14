import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages

import 'package:provider/provider.dart';
import 'package:system_of_crush_mobile_app/routes/routes.dart';
import 'package:system_of_crush_mobile_app/themes/light_theme.dart';


Future<void> main() async {
    runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
      initialData: null,
      value: null,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: routes,
        initialRoute: '/',
        theme: themeData,
      ),
    );
  }
}

