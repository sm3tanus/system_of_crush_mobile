import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:system_of_crush_mobile_app/API/models.dart';
import 'package:system_of_crush_mobile_app/themes/light_theme.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../API/applications_api/api.dart';

class CurrentApplicationsPage extends StatefulWidget {
  const CurrentApplicationsPage({super.key});

  @override
  State<CurrentApplicationsPage> createState() =>
      _CurrentApplicationsPageState();
}

class _CurrentApplicationsPageState extends State<CurrentApplicationsPage> {
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
    var result = await fetchCurrentApplications();

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
                            fontFamily: 'Unbounded',
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: AutoSizeText(
                            "${userFio ?? 'Загрузка...'}",
                            style: TextStyle(
                              fontSize: 22,
                              fontFamily: 'Unbounded',
                            fontWeight: FontWeight.w600,                              
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
                        Iconsax.frame2,
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
                  gradient: LinearGradient(
            colors: [Colors.white, Color(0xFFD9D9D9),],
            stops: [0.2, 0.2,], // Четкое разделение
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
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
                      return  ListView.builder(
            itemCount: snapshot.data!.length,
  padding: EdgeInsets.symmetric(horizontal: 16, vertical: MediaQuery.of(context).size.height * 0.04,),
            itemBuilder: (context, index) {
              var application = snapshot.data![index];

              Color importanceColor = application.importance == "Высокая"
                  ? Colors.redAccent
                  : application.importance == "Средняя"
                      ? Colors.orangeAccent
                      : Colors.grey;

              return Container(
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.only(bottom: 15,),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 4),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '№${application.id}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Unbounded',
                            fontSize: 20,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(Icons.timer, size: 16, color: Colors.grey),
                            SizedBox(width: 5),
                            Text(
                              'Таймер мин.',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.redAccent,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    
                    Row(
                      children: [
                        Icon(Iconsax.location, size: 18, color: Colors.grey),
                        SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            application.address,
                            style: TextStyle(fontSize: 16),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),

                    Row(
                      children: [
                        Icon(Iconsax.warning_2, size: 18, color: Colors.grey),
                        SizedBox(width: 6),
                        Text(
                          application.accident,
                          style: TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),

                    Row(
                      children: [
                        Icon(Icons.flag, size: 18, color: importanceColor),
                        SizedBox(width: 6),
                        Text(
                          '${application.importance} важность',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: importanceColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),

                    Container(
                      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 59, 187, 125),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        "В процессе",
                        style: TextStyle(
                          fontSize: 14,
                          color: const Color.fromARGB(255, 255, 255, 255),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
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
