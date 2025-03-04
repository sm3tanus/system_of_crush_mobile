import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
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
  final TextEditingController _searchController = TextEditingController();

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
                child: Column(
                  children: [
                    SizedBox(height: 20,),
                    Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: Color(0xFFD9D9D9)
                              ),
                              child: TextField(
                                maxLength: 20,
                                controller: _searchController,
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
                    SizedBox(height: 20,), 
                    Expanded(
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
                        padding: EdgeInsets.symmetric(horizontal: 16,),
                      
                        itemBuilder: (context, index) {
                          var application = snapshot.data![index];
                          
                          Color importanceColor = application.importance == "Высокая"
                              ? Colors.redAccent
                              : application.importance == "Средняя"
                                  ? Colors.orangeAccent
                                  : Colors.grey;
                      
                          return Card(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            
                            elevation: 4, 
                            margin: EdgeInsets.only(bottom: 15),
                            child: ListTile(
                              contentPadding: EdgeInsets.all(16),
                              leading: CircleAvatar(
                                // ignore: deprecated_member_use
                                backgroundColor: importanceColor.withOpacity(0.2),
                                child: Icon(Iconsax.warning_2, color: importanceColor), 
                              ),
                              title: Text(
                                '№${application.id.toString()}',
                                style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Unbounded' ,fontSize: 18),
                              ),
                              
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                      Icon(Iconsax.location, size: 16, color: Colors.grey),
                      SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          application.address,
                          style: TextStyle(fontSize: 14, color: Colors.black87),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                                    ],
                                  ),
                                  SizedBox(height: MediaQuery.of(context).size.height * 0.003),
                                  Row(
                                    children: [
                      Icon(Iconsax.warning_2, size: 16, color: Colors.grey),
                      SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          application.accident,
                          style: TextStyle(fontSize: 13, color: Colors.black54),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                                    ],
                                  ),
                                ],
                              ),
                              trailing: Icon(Iconsax.arrow_right_34, size: 16, color: Colors.grey), 
                              onTap: () {
                              },
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
            ],
          ),
        ),
      ),
    );
  }
}
