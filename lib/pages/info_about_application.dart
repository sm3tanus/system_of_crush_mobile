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
  Future<Application?> getApplication() async {
    var result = await fetchApplication(widget.selectedApplicationId);
    print(result.toString());
    if (result != null && result is Application) {
      return result;
    } else if (result == 401) {
      Future.microtask(() => Navigator.popAndPushNamed(context, '/auth'));
      return null;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Application?>(
      future: getApplication(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildScaffold(
            Center(
              child: CircularProgressIndicator(color: Colors.black),
            ),
          );
        }
         else if (snapshot.hasError || !snapshot.hasData) {
          print(snapshot.error);
          return _buildScaffold(
            Center(
              child: Text(
                'Нет данных.',
                style: TextStyle(fontSize: 18),
              ),
            ),
          );
        }

        final application = snapshot.data!;
        Color importanceColor = application.importance == "Высокая"
            ? Colors.redAccent
            : application.importance == "Средняя"
                ? Colors.orangeAccent
                : Colors.grey;
        final formattedDate = DateFormat('dd.MM.yyyy HH:mm')
            .format(DateTime.parse(application.createDate));

        return _buildScaffold(
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoCard(application, formattedDate, importanceColor),
                SizedBox(height: 20),
                _buildMoreInfo(application),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildScaffold(Widget body) {
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
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFFD9D9D9)],
            stops: [0.1, 0.1],
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: body,
        ),
      ),
    );
  }

  Widget _buildInfoCard(
      Application application, String formattedDate, Color importanceColor) {
    return 
       
        Card(
          elevation: 4,
          color: Color.fromARGB(255, 255, 255, 255),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow(
                    Iconsax.document, 'Номер заявки', application.id.toString()),
                _buildInfoRow(Iconsax.calendar, 'Дата создания', formattedDate),
                _buildInfoRow(Iconsax.location, 'Адрес', application.address),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Icon(Iconsax.warning_2, color: importanceColor),
                      SizedBox(width: 10),
                      Text('Важность:',
                          style:
                              TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          '${application.importance}',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    fixedSize: Size(double.infinity, 50),
                    side: BorderSide(color: Colors.redAccent),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Iconsax.map, color: Colors.redAccent),
                      SizedBox(width: 10),
                      Text('Показать на карте',
                          style: TextStyle(color: Colors.redAccent)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );

  }

  Widget _buildInfoRow(IconData icon, String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.black54),
          SizedBox(width: 10),
          Text('$title:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,)),
          SizedBox(width: 10),
          Expanded(
            child: Text(value,
                style: TextStyle(fontSize: 16),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoreInfo(Application application) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Основная характеристика',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 15),
        Card(
          color: Colors.white,
          elevation: 3,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow(
                    Iconsax.document, 'Характер', application.accident),
                SizedBox(height: 10),
                _buildInfoRow(
                    Iconsax.document, 'Авария', application.accidentCharacter),
                SizedBox(height: 10),
                _buildInfoRow(
                    Iconsax.document, 'Материал', application.material),
                SizedBox(height: 10),
                _buildInfoRow(
                    Iconsax.document, 'Тип поломки', application.typeDamage),
                SizedBox(height: 10),
                // _buildInfoRow(
                //     Iconsax.document, 'Место поломки', application.typeDamage),
                // SizedBox(height: 10),
                Text('Описание: ${application.description}',
                    style: TextStyle(fontSize: 16)),
                SizedBox(height: 10),
                Text('Статус: ${application.status}',
                    style:
                        TextStyle(fontSize: 16,)),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
