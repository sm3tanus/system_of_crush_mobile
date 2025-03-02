import 'package:flutter/material.dart';
import 'package:system_of_crush_mobile_app/API/models.dart';
import 'package:system_of_crush_mobile_app/themes/light_theme.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../API/applications_api/api.dart';

class ApplicationsPage extends StatefulWidget {
  const ApplicationsPage({super.key});

  @override
  State<ApplicationsPage> createState() => _ApplicationsPageState();
}

class _ApplicationsPageState extends State<ApplicationsPage> {
  var userFio;
  var userRole;

  late Future<List<Application>> applications;

  @override
  void initState() {
    super.initState();

    applications = Future.value([]);
    getApplications();
    getUser();
  }

  Future<void> getApplications() async {
    var result = await fetchApplications();

    if (result is List<Application>) {
      setState(() {
        applications = Future.value(result);
      });
    } else if (result == 401) {
      Future.microtask(() => Navigator.popAndPushNamed(context, '/auth'));
    } else {
      print("Ошибка: ${result.toString()}");
    }
  }

  Future<void> getUser() async {
    final secureStorage = FlutterSecureStorage();
    userFio = await secureStorage.read(key: 'fio');
    userRole = await secureStorage.read(key: 'role');

    if (userFio == null || userRole == null) {
      Future.microtask(() => Navigator.popAndPushNamed(context, '/auth'));
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientContainer(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.08,
                  vertical: MediaQuery.of(context).size.height * 0.07,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Добро пожаловать,",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: AutoSizeText(
                            "${userFio ?? 'Загрузка...'}",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: Color.fromARGB(255, 80, 139, 151),
                            ),
                            maxLines: 1,
                            minFontSize: 16,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.view_headline,
                        size: MediaQuery.of(context).size.height * 0.03,
                        color: Color(0xFFD9D9D9),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: FutureBuilder<List<Application>>(
                  future: applications,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: Text("Подождите..."));
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Ошибка: ${snapshot.error}"));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text("Нет данных"));
                    } else {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: EdgeInsets.all(16),
                            margin: EdgeInsets.only(
                              left:  MediaQuery.of(context).size.width * 0.03,
                              right: MediaQuery.of(context).size.width * 0.03,
                              top: MediaQuery.of(context).size.height * 0.02
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromARGB(255, 146, 146, 146),
                                  offset: Offset(0, 4),
                                  blurRadius: 6,
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '№${snapshot.data![index].id.toString()}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 24,
                                    color: Color(0xff2E2E2E),
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width *
                                          0.6,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            (snapshot.data![index].address
                                                .toString()),
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w800,
                                              color: Color.fromARGB(
                                                255,
                                                80,
                                                139,
                                                151,
                                              ),
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(
                                            height:
                                                MediaQuery.of(
                                                  context,
                                                ).size.height *
                                                0.007,
                                          ),
                                          Text(
                                            snapshot.data![index].accident
                                                .toString(),
                                            style: TextStyle(fontSize: 12),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width:
                                          MediaQuery.of(context).size.width *
                                          0.03,
                                      height:
                                          MediaQuery.of(context).size.width *
                                          0.11,
                                      margin: EdgeInsets.only(left: 10),
                                      decoration: BoxDecoration(
                                        color:
                                            snapshot.data![index].importance
                                                        .toString() ==
                                                    "Высокая"
                                                ? const Color.fromARGB(
                                                  255,
                                                  177,
                                                  32,
                                                  21,
                                                )
                                                : snapshot
                                                        .data![index]
                                                        .importance
                                                        .toString() ==
                                                    "Средняя"
                                                ? const Color.fromARGB(
                                                  255,
                                                  149,
                                                  113,
                                                  7,
                                                )
                                                : const Color(0xff2E2E2E),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
