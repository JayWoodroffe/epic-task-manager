import 'dart:convert';
import 'dart:developer';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:kanban_app/models/board.dart';

class BoardApi {
  static const String baseUrl = 'http://192.168.1.54:5285/api';

  Future<List<dynamic>> getBoardsForProject(String projectGuid) async {
    final token = await FlutterSecureStorage().read(key: 'auth_token');
    final response =
        await http.get(Uri.parse('$baseUrl/boards/$projectGuid'), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final json =
          jsonDecode(response.body); //accessing the list inside the map first
      final List<dynamic> data = json['\$values'];
      log(response.body);
      print(response.body);
      return data.map((json) => Board.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load boards');
    }
  }

  Future<void> updateBoard(Board board) async {
    final token = await FlutterSecureStorage().read(key: 'auth_token');
    final response = await http.put(
      Uri.parse('$baseUrl/projects/${board.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(board.toJson()),
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
}
