import 'dart:convert';
import 'dart:developer';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:kanban_app/models/board.dart';

class BoardApi {
  static const String baseUrl = 'http://192.168.1.54:5285/api';

  Future<List<dynamic>> getBoardsForProject(String projectGuid) async {
    final token = await FlutterSecureStorage().read(key: 'auth_token');
    final response = await http
        .get(Uri.parse('$baseUrl/boards/project/$projectGuid'), headers: {
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
      throw Exception('Failed to load boards for project: $projectGuid');
    }
  }

  Future<void> updateBoard(Board board) async {
    final token = await FlutterSecureStorage().read(key: 'auth_token');
    final response = await http.put(
      Uri.parse('$baseUrl/boards/${board.id}'),
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
      throw Exception('Board not found');
    } else {
      throw Exception('Failed to update board: ${response.statusCode}');
    }
  }

  Future<void> deleteBoard(Board board) async {
    final token = await FlutterSecureStorage().read(key: 'auth_token');
    final response = await http.delete(
      Uri.parse('$baseUrl/boards/${board.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 204 || response.statusCode == 200) {
      return; // Success: no content or optional body
    } else if (response.statusCode == 400) {
      throw Exception('Bad request: invalid board ID or format');
    } else if (response.statusCode == 404) {
      throw Exception('Board not found');
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized: invalid or expired token');
    } else if (response.statusCode == 403) {
      throw Exception(
          'Forbidden: you do not have permission to delete this board');
    } else {
      throw Exception(
          'Failed to delete board: ${response.statusCode} - ${response.body}');
    }
  }

  Future<void> createBoard(Board board, String projectId) async {
    final token = await FlutterSecureStorage().read(key: 'auth_token');
    final response = await http.post(
      Uri.parse('$baseUrl/boards/$projectId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(board.toCreateJson()),
    );

    if (response.statusCode == 201) {
      // NoContent — update succeeded, nothing to return
      return;
    } else if (response.statusCode == 400) {
      throw Exception('Bad request: check GUIDs or JSON structure');
    } else if (response.statusCode == 404) {
      throw Exception('Board not found');
    } else {
      throw Exception('Failed to create board: ${response.statusCode}');
    }
  }
}
