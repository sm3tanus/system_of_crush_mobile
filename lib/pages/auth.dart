import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:system_of_crush_mobile_app/themes/light_theme.dart';
import '../API/auth_api/api.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool visibility = false;
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  var available;
  bool error = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientContainer(
        child: Builder(
          builder: (context) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 40.0,
                      vertical: MediaQuery.of(context).size.height * 0.13,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Добро\nпожаловать\nв систему",
                          style: TextStyle(
                            fontSize: 34,
                            fontFamily: 'Unbounded',
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "UrbanFix",
                          style: TextStyle(
                            fontSize: 45,
                            fontFamily: 'Unbounded',
                            fontWeight: FontWeight.w600,
                            color: Color.fromARGB(255, 80, 139, 151),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.46,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Логин",
                              style: TextStyle(
                                color: Color(0xff353535),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(211, 211, 211, 1),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: TextField(
                                maxLength: 20,
                                controller: _loginController,
                                cursorColor: Color(0xff353535),
                                style: TextStyle(
                                  color: Color(0xff353535),
                                  fontWeight: FontWeight.w600,
                                ),
                                decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 16.0),
                                    border: InputBorder.none,
                                    counterText: ''),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Пароль",
                              style: TextStyle(
                                color: Color(0xff353535),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(211, 211, 211, 1),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: TextField(
                                maxLength: 20,
                                controller: _passwordController,
                                obscureText: !visibility,
                                cursorColor: Color(0xff353535),
                                style: TextStyle(
                                  color: Color(0xff353535),
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlignVertical: TextAlignVertical.center,
                                decoration: InputDecoration(
                                  counterText: '',
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 16.0),
                                  suffixIcon: IconButton(
                                    icon: !visibility
                                        ? Icon(Iconsax.eye)
                                        : Icon(Iconsax.eye_slash),
                                    onPressed: () {
                                      setState(() {
                                        visibility = !visibility;
                                      });
                                    },
                                  ),
                                  suffixIconColor: Color(0xff353535),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01),
                        Visibility(
                          visible: error,
                          child: Text(
                            available.toString(),
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () async {
                              available = await loginUser(_loginController.text,
                                  _passwordController.text);
                              if (available == true) {
                                setState(() {
                                  error = false;
                                });
                                Navigator.popAndPushNamed(context, '/menu');
                              } else if (available == false) {
                                setState(() {
                                  available = 'Ошибка соединения с сервером.';
                                });
                              } else {
                                setState(() {
                                  error = true;
                                });
                              }
                            },
                            child: Ink(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xff353535),
                                    Color.fromARGB(255, 80, 139, 151),
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  'Войти',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
