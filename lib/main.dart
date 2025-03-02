import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:yandex_maps_mapkit/init.dart' as init;

import 'package:provider/provider.dart';
import 'package:system_of_crush_mobile_app/routes/routes.dart';
import 'package:system_of_crush_mobile_app/themes/light_theme.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
     await init.initMapkit(apiKey: '025faeb8-1c99-412c-9efe-3d3f3909f229');

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

