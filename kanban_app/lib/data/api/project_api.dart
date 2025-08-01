import 'dart:convert';
import 'dart:developer';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:kanban_app/models/project.dart';
import 'package:kanban_app/models/user.dart';

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

  Future<List<dynamic>> getAllProjects() async {
    final token = await FlutterSecureStorage().read(key: 'auth_token');
    final response = await http.get(Uri.parse('$baseUrl/projects'), headers: {
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

  Future<List<dynamic>> getAllUsers() async {
    final token = await FlutterSecureStorage().read(key: 'auth_token');
    final response = await http.get(Uri.parse('$baseUrl/users'), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final List<dynamic> data = json['\$values'];
      return data.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load projects');
    }
  }
}
