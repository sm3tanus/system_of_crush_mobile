import 'package:flutter/material.dart';
import 'package:system_of_crush_mobile_app/API/auth_api/api.dart';
import 'package:system_of_crush_mobile_app/pages/auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:system_of_crush_mobile_app/pages/main_menu.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: getToken(), 
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: Text(""));
        } else if (snapshot.hasError) {
          return const AuthPage(); 
        } else if (snapshot.hasData) {
          final token = snapshot.data;
          if (token == null) {
            return const AuthPage(); 
          } else {
            var userModel = parseJWT(token);
            final bool check = userModel != null;
            return check ?  MainScreen() : const AuthPage();
          }
        } else {
          return const AuthPage(); 
        }
      },
    );
  }
}

Future<String?> getToken() async {
  return await FlutterSecureStorage().read(key: 'token');
}
