import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:system_of_crush_mobile_app/pages/info_about_application.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class PlasemarksMapPage extends StatefulWidget {
  final String selectedApplicationId;

  const PlasemarksMapPage({super.key, required this.selectedApplicationId});

  @override
  State<PlasemarksMapPage> createState() => _PlasemarksMapPageState();
}

class _PlasemarksMapPageState extends State<PlasemarksMapPage> {
  late YandexMapController _mapController;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InfoAboutApplicationPage(
                    selectedApplicationId: widget.selectedApplicationId,
                  ),
                ),
              );
            },
            icon: const Icon(Iconsax.arrow_left_1),
            iconSize: 30,
          ),
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
        ),
        body: YandexMap(
          onMapCreated: (controller) {
            _mapController = controller;

            // Сразу переместим камеру при запуске
            _mapController.moveCamera(
              CameraUpdate.newCameraPosition(
                const CameraPosition(
                  target: Point(latitude: 55.751244, longitude: 37.618423), // Москва
                  zoom: 12,
                ),
              ),
              animation: const MapAnimation(type: MapAnimationType.smooth, duration: 1.5),
            );
          },
        ),
      ),
    );
  }
}
