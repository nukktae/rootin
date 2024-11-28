import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

const String baseUrl = "https://api.rootin.me";

class ApiClient {
  ApiClient();

  Future<Map<String, dynamic>> identifyPlant(String filePath) async {
    final url = Uri.parse('$baseUrl/v1/plant-types/images');
    final String? fcmToken = dotenv.env['FCM_TOKEN'];

    if (fcmToken == null || fcmToken.isEmpty) {
      throw Exception("FCM Token is not defined. Check your .env file.");
    }

    final request = http.MultipartRequest('POST', url)
      ..headers['Authorization'] = 'Bearer $fcmToken'
      ..headers['Accept'] = 'application/json'
      ..files.add(await http.MultipartFile.fromPath('file', filePath));

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      return jsonDecode(responseBody);
    } else {
      final errorBody = await response.stream.bytesToString();
      throw Exception(
          'Failed to identify plant. Status code: ${response.statusCode}. Error: $errorBody');
    }
  }
}
