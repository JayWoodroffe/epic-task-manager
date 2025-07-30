import 'dart:convert';
import 'dart:developer';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:kanban_app/models/project.dart';

class ProjectApi {
  static const String baseUrl = 'http://192.168.1.54:5285/api';

  Future<List<dynamic>> getProjectsForUser() async {
    final token = await FlutterSecureStorage().read(key: 'auth_token');
    final response =
        await http.get(Uri.parse('$baseUrl/projects/myprojects'), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final json =
          jsonDecode(response.body); //accessing the list inside the map first
      final List<dynamic> data = json['\$values'];
      log(response.body);
      print(response.body);
      return data.map((json) => Project.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load projects');
    }
  }
}
