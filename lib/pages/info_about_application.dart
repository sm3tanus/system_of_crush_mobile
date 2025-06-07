import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:system_of_crush_mobile_app/API/applications_api/api.dart';
import 'package:system_of_crush_mobile_app/API/models.dart';
import 'package:system_of_crush_mobile_app/pages/placemarks_map.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoAboutApplicationPage extends StatefulWidget {
  final String selectedApplicationId;
  const InfoAboutApplicationPage(
      {super.key, required this.selectedApplicationId});

  @override
  State<InfoAboutApplicationPage> createState() =>
      _InfoAboutApplicationPageState();
}

class _InfoAboutApplicationPageState extends State<InfoAboutApplicationPage> {
  Future<CurrentApplication?> getApplication() async {
    var result = await fetchApplication(widget.selectedApplicationId);
    print(result.toString());
    if (result != null && result is CurrentApplication) {
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
    return FutureBuilder<CurrentApplication?>(
      future: getApplication(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildScaffold(
            Center(
              child: CircularProgressIndicator(color: Colors.black),
            ),
          );
        } else if (snapshot.hasError || !snapshot.hasData) {
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

        return _buildScaffold(
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoCard(application, importanceColor),
                SizedBox(height: 20),
                _buildMoreInfo(application),
                SizedBox(height: 30),
                _buildTakeToWorkButton(),
                SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTakeToWorkButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ElevatedButton(
        onPressed: () {
          _showConfirmationDialog();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromARGB(255, 80, 139, 151),
          foregroundColor: Colors.white,
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(vertical: 16),
          minimumSize: Size(double.infinity, 50),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Взять в работу',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Подтверждение'),
          content: Text('Вы уверены, что хотите взять эту заявку в работу?'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Отмена',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                var status =
                    await takeApplication(widget.selectedApplicationId);
                if (status >= 200 && status <= 299) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Заявка успешно взята в работу!'),
                      backgroundColor: const Color.fromARGB(255, 100, 180, 103),
                    ),
                  );
                  Navigator.popAndPushNamed(context, '/menu');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Произошла ошибка. Попробуйте снова!'),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 80, 139, 151),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(10),
              ),
              child: Text(
                'Подтвердить',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
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
        title: Text(
          'Детали заявки',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
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

  Widget _buildInfoCard(CurrentApplication application, Color importanceColor) {
    return Card(
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
                        color: importanceColor,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            OutlinedButton(
              onPressed: () {
                openYandexMaps(application.address);
              },
              style: OutlinedButton.styleFrom(
                fixedSize: Size(double.infinity, 50),
                side: BorderSide(color: Colors.redAccent, width: 1.5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Iconsax.map, color: Colors.redAccent),
                  SizedBox(width: 10),
                  Text('Показать на карте',
                      style: TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void openYandexMaps(String address) async {
    final Uri url = Uri.parse(
        "yandexmaps://maps.yandex.ru/?text=${Uri.encodeComponent(address)}");

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      final Uri webUrl = Uri.parse(
          "https://yandex.ru/maps/?text=${Uri.encodeComponent(address)}");
      await launchUrl(webUrl, mode: LaunchMode.externalApplication);
    }
  }

  Widget _buildInfoRow(IconData icon, String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.black54),
          SizedBox(width: 10),
          Text('$title:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              )),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoreInfo(CurrentApplication application) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Основная характеристика',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
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
                    Iconsax.refresh_square_2, 'Характер', application.accident),
                SizedBox(height: 10),
                _buildInfoRow(Iconsax.refresh_square_2, 'Авария',
                    application.accidentCharacter),
                SizedBox(height: 10),
                _buildInfoRow(
                    Iconsax.refresh_square_2, 'Материал', application.material),
                SizedBox(height: 10),
                _buildInfoRow(Iconsax.refresh_square_2, 'Тип поломки',
                    application.typeDamage),
                SizedBox(height: 10),
                _buildInfoRow(
                    Iconsax.document, 'Место поломки', application.typeDamage),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.only(left: 34),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Описание:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        application.description,
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
