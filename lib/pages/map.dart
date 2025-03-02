import 'package:flutter/material.dart';
import 'package:yandex_maps_mapkit/mapkit.dart';
import 'package:yandex_maps_mapkit/yandex_map.dart';
import 'package:yandex_maps_mapkit/mapkit_factory.dart';


class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  MapWindow? _mapWindow;
  bool _isMapkitActive = false;  // Переменная для контроля состояния карты
  
  // Метод для старта карты (активировать карту)
  void _startMapkit() {
    if (!_isMapkitActive) {
      _isMapkitActive = true;
      mapkit.onStart();  // Инициализация карты
    }
  }

  // Метод для остановки карты (деактивировать карту)
  void _stopMapkit() {
    if (_isMapkitActive) {
      _isMapkitActive = false;
      mapkit.onStop();  // Остановка карты
    }
  }

  @override
  void initState() {
    super.initState();
    // Активируем карту при старте
    _startMapkit();
  }

  @override
  void dispose() {
    // Останавливаем карту при уничтожении
    _stopMapkit();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Yandex Map Example'),
        ),
        body: YandexMap(
          onMapCreated: (mapWindow) {
            setState(() {
              _mapWindow = mapWindow;  // Сохраняем объект карты при ее создании
            });
            _startMapkit();  // Инициализация карты при ее создании
          },
        ),
      ),
    );
  }
}
