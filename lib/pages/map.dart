import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart' as yandex_map;
import 'package:yandex_geocoder/yandex_geocoder.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late final yandex_map.YandexMapController _mapController;
  final List<yandex_map.MapObject> _mapObjects = [];
  final YandexGeocoder _geocoder = YandexGeocoder(apiKey: 'a5dd7848-9cc6-4f52-964d-ac246873012d');
  bool _isLoading = false;

  // Список адресов для отображения
  final List<String> _addresses = [
    "Казань, улица Беломорская, 81",
    "Казань, Кремлевская улица, 18",
    "Казань, улица Баумана, 44",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          yandex_map.YandexMap(
            onMapCreated: (controller) {
              _mapController = controller;
              // Устанавливаем начальную позицию - Казань
              _setInitialCameraPosition();
              // Добавляем метки
              _addAllMarkers();
            },
            mapObjects: _mapObjects,
          ),
          if (_isLoading)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  Future<void> _setInitialCameraPosition() async {
    // Координаты центра Казани
    final kazanCenter = yandex_map.Point(
      latitude: 55.796127,
      longitude: 49.106414,
    );
    
    await _mapController.moveCamera(
      yandex_map.CameraUpdate.newCameraPosition(
        yandex_map.CameraPosition(
          target: kazanCenter,
          zoom: 11, // Оптимальный zoom для просмотра всего города
        ),
      ),
    );
  }

  Future<void> _addAllMarkers() async {
    setState(() => _isLoading = true);
    _mapObjects.clear(); // Очищаем старые метки
    
    try {
      for (final address in _addresses) {
        await _addMarkerForAddress(address);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _addMarkerForAddress(String address) async {
    try {
      final point = await _geocodeAddress(address);
      
      setState(() {
        _mapObjects.add(
          yandex_map.PlacemarkMapObject(
            mapId: yandex_map.MapObjectId('marker_${address.hashCode}'),
            point: point,
            icon: yandex_map.PlacemarkIcon.single(
              yandex_map.PlacemarkIconStyle(
                image: yandex_map.BitmapDescriptor.fromAssetImage('assets/marker.png'),
                scale: 0.5, // Уменьшаем размер метки в 2 раза
              ),
            ),
            text: yandex_map.PlacemarkText(
              text: address,
              style: const yandex_map.PlacemarkTextStyle(
                color: Colors.black,
                size: 10.0, // Уменьшаем размер текста
              ),
            ),
            opacity: 0.9, // Прозрачность метки
          ),
        );
      });
    } catch (e) {
      debugPrint('Ошибка добавления метки для $address: $e');
    }
  }

  Future<yandex_map.Point> _geocodeAddress(String address) async {
    final response = await _geocoder.getGeocode(
      DirectGeocodeRequest(addressGeocode: address),
    );

    if (response.firstPoint == null) {
      throw Exception('Адрес не найден: $address');
    }

    final pointRecord = response.firstPoint!;
    return yandex_map.Point(
      latitude: pointRecord.lat, 
      longitude: pointRecord.lon
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}