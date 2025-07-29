import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:kanban_app/models/project.dart';

class ProjectApi {
  static const String baseUrl = 'http://192.168.1.54:5285/api';
  String userguid = "a4f4a006-6b13-11f0-8177-842afdcb8544";

  Future<List<dynamic>> getProjectsForUser() async {
    final response =
        await http.get(Uri.parse('$baseUrl/users/$userguid/projects'));

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
