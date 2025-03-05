import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:system_of_crush_mobile_app/API/applications_api/api.dart';
import 'package:system_of_crush_mobile_app/API/models.dart';

class InfoAboutApplicationPage extends StatefulWidget {
  final String selectedApplicationId;
  const InfoAboutApplicationPage(
      {super.key, required this.selectedApplicationId});

  @override
  State<InfoAboutApplicationPage> createState() =>
      _InfoAboutApplicationPageState();
}

class _InfoAboutApplicationPageState extends State<InfoAboutApplicationPage> {
  Application? application;
  var formattedDate;

  @override
  void initState() {
    super.initState();
    getApplication();
    print(widget.selectedApplicationId);
  }

  formatDate(String isoDate) {
    DateTime dateTime = DateTime.parse(isoDate);
    String formattedDate = DateFormat('dd.MM.yyyy HH:mm').format(dateTime);
    return formattedDate;
  }

  Future<void> getApplication() async {
    var result = await fetchApplication(widget.selectedApplicationId);

    if (result != null) {
      setState(() {
        application = result;
        formattedDate = formatDate(application!.createDate);
      });
    } else if (result == 401) {
      Future.microtask(() => Navigator.popAndPushNamed(context, '/auth'));
    } else {
      print("Ошибка: ${result.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.popAndPushNamed(context, '/menu');
          },
          icon: Icon(Iconsax.arrow_left_1),
          iconSize: 30,
        ),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Color(0xFFD9D9D9),
            gradient: LinearGradient(
              colors: [
                Colors.white,
                Color(0xFFD9D9D9),
              ],
              stops: [
                0.2,
                0.2,
              ], // Четкое разделение
              begin: Alignment.topLeft,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Номер заявки ${application?.id}',
                style: TextStyle(fontFamily: 'Unbounded', fontSize: 20),
              ),
              SizedBox(height: 10,),
              Text(
                'Дата создания: $formattedDate',
                style: TextStyle(fontFamily: 'Montserrat', fontSize: 16),
              )
            ],
          ),
        ),
      ),
    );
  }
}
