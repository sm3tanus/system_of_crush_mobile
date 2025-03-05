import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:system_of_crush_mobile_app/API/config.dart';
import 'package:system_of_crush_mobile_app/API/models.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future fetchCurrentApplications() async {
  final token = await FlutterSecureStorage().read(key: 'token');
  final idBrigadir = await FlutterSecureStorage().read(key: 'idBrigadir');
  final url = Uri.parse('$apiURL/api/applications/brigadir/$idBrigadir');
  var response = await http.get(
    url,
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body) ?? [];
    return data.map((json) => Application.fromJson(json)).toList();
  } else {
    print('Error: ${response.statusCode}');
    print('ErrorMessage: ${response.body}');
    return response.statusCode;
  }
}


Future fetchApplications() async {
  final token = await FlutterSecureStorage().read(key: 'token');
  final url = Uri.parse('$apiURL/api/applications');
  var response = await http.get(
    url,
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body) ?? [];
    return data.map((json) => Application.fromJson(json)).toList();
  } else {
    print('Error: ${response.statusCode}');
    print('ErrorMessage: ${response.body}');
    return response.statusCode;

  }
}


Future fetchApplication(String idApplication) async {
  final token = await FlutterSecureStorage().read(key: 'token');
  final url = Uri.parse('$apiURL/api/applications/$idApplication');
  var response = await http.get(
    url,
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    return Application.fromJson(data);
  } else {
    print('Error: ${response.statusCode}');
    print('ErrorMessage: ${response.body}');
    return response.statusCode;
  }
}
