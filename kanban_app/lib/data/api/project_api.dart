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
      print(response.body);
      final List<dynamic> data = json['\$values'];
      return data.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<void> updateProject(Project project) async {
    final token = await FlutterSecureStorage().read(key: 'auth_token');
    final response = await http.put(
      Uri.parse('$baseUrl/projects/${project.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(project.toJson()),
    );

    if (response.statusCode == 204) {
      // NoContent — update succeeded, nothing to return
      return;
    } else if (response.statusCode == 400) {
      throw Exception('Bad request: mismatched GUIDs');
    } else if (response.statusCode == 404) {
      throw Exception('Project not found');
    } else {
      throw Exception('Failed to update project: ${response.statusCode}');
    }
  }

  Future<void> createProject(Project project) async {
    final token = await FlutterSecureStorage().read(key: 'auth_token');
    final response = await http.post(
      Uri.parse('$baseUrl/projects'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(project.toCreateJson()),
    );

    if (response.statusCode == 201) {
      // NoContent — update succeeded, nothing to return
      return;
    } else if (response.statusCode == 400) {
      throw Exception('Bad request: check GUIDs or JSON structure');
    } else if (response.statusCode == 404) {
      throw Exception('Project not found');
    } else {
      throw Exception('Failed to update project: ${response.statusCode}');
    }
  }

  Future<void> deleteProject(Project project) async {
    final token = await FlutterSecureStorage().read(key: 'auth_token');
    final response = await http.delete(
      Uri.parse('$baseUrl/projects/${project.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 201) {
      // NoContent — update succeeded, nothing to return
      return;
    } else if (response.statusCode == 400) {
      throw Exception('Bad request: check GUIDs or JSON structure');
    } else if (response.statusCode == 404) {
      throw Exception('Project not found');
    } else {
      throw Exception('Failed to update project: ${response.statusCode}');
    }
  }
}
