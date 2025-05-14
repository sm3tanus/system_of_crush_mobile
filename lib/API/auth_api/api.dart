// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:system_of_crush_mobile_app/API/config.dart';

Future loginUser(String login, String password) async {
  final url = Uri.parse('$apiURL/auth/login');
  final secureStorage = FlutterSecureStorage();

  final headers = {"Content-Type": "application/json"};
  final body = jsonEncode({
    'login': login,
    'password': password,
  });

  try {
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      var responseBody = json.decode(response.body); 
      var data = responseBody['token'];
      await secureStorage.write(key: 'token', value: data);
      final token = await secureStorage.read(key: 'token');
      var user = parseJWT(token!);

      if (user?['role_id'] == 3) {
        await secureStorage.write(
            key: 'fio',
            value:
                '${user?['last_name']} ${user?['first_name'][0]}.${user?['patronymic'][0]}.');
        await secureStorage.write(key: 'role', value: '${user?['role_name']}');
        await secureStorage.write(key: 'idBrigadir', value: '${user?['id']}');

        return true;
      } else {
        return 'Доступ ограничен.';
      }
    } else {
      print('Ошибка: ${response.statusCode}, тело: ${response.body}');
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data['error'];
    }
  } catch (e) {
    print('Ошибка соединения: $e');
    return false;
  }
}

Map<String, dynamic>? parseJWT(String token) {
  final parts = token.split('.');
  if (parts.length != 3) {
    return null;
  }

  final String base64Url = parts[1];
  final String normalizedBase64 =
      base64Url.replaceAll('-', '+').replaceAll('_', '/');
  final String decodedString =
      utf8.decode(base64.decode(base64.normalize(normalizedBase64)));

  return json.decode(decodedString);
}
