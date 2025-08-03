import 'dart:convert';
import 'dart:developer';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:kanban_app/models/list.dart';
import 'package:kanban_app/models/task.dart';

//this handles requests to both the task and list endpoints of the API since the two object types are so tightly coupled
class ListApi {
  static const String baseUrl = 'http://192.168.1.54:5285/api';

  Future<List<dynamic>> getListsForBoard(String boardGuid) async {
    final token = await FlutterSecureStorage().read(key: 'auth_token');
    final response =
        await http.get(Uri.parse('$baseUrl/lists/board/$boardGuid'), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final json =
          jsonDecode(response.body); //accessing the list inside the map first
      final List<dynamic> data = json['\$values'];
      log(response.body);
      print(response.body);
      return data.map((json) => ListType.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load lists for board: $boardGuid');
    }
  }

  Future<void> updateList(ListType list) async {
    final token = await FlutterSecureStorage().read(key: 'auth_token');
    final response = await http.put(
      Uri.parse('$baseUrl/lists/${list.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(list.toJson()),
    );

    if (response.statusCode == 204) {
      // NoContent — update succeeded, nothing to return
      return;
    } else if (response.statusCode == 400) {
      throw Exception('Bad request: mismatched GUIDs');
    } else if (response.statusCode == 404) {
      throw Exception('List not found');
    } else {
      throw Exception('Failed to update list: ${response.statusCode}');
    }
  }

  Future<void> deleteList(ListType list) async {
    final token = await FlutterSecureStorage().read(key: 'auth_token');
    final response = await http.delete(
      Uri.parse('$baseUrl/lists/${list.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 204 || response.statusCode == 200) {
      return; // Success: no content or optional body
    } else if (response.statusCode == 400) {
      throw Exception('Bad request: invalid list ID or format');
    } else if (response.statusCode == 404) {
      throw Exception('List not found');
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized: invalid or expired token');
    } else if (response.statusCode == 403) {
      throw Exception(
          'Forbidden: you do not have permission to delete this list');
    } else {
      throw Exception(
          'Failed to delete list: ${response.statusCode} - ${response.body}');
    }
  }

  Future<void> createList(ListType list, String boardId) async {
    final token = await FlutterSecureStorage().read(key: 'auth_token');
    final response = await http.post(
      Uri.parse('$baseUrl/lists/$boardId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(list.toCreateJson()),
    );

    if (response.statusCode == 201) {
      // NoContent — update succeeded, nothing to return
      return;
    } else if (response.statusCode == 400) {
      throw Exception('Bad request: check GUIDs or JSON structure');
    } else if (response.statusCode == 404) {
      throw Exception('Board not found');
    } else {
      throw Exception('Failed to create list: ${response.statusCode}');
    }
  }

  Future<void> createTask(Task task, String listId) async {
    final token = await FlutterSecureStorage().read(key: 'auth_token');
    final response = await http.post(
      Uri.parse('$baseUrl/tasks?listGuid=$listId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(task.toCreateJson()),
    );

    if (response.statusCode == 201) {
      // NoContent — update succeeded, nothing to return
      return;
    } else if (response.statusCode == 400) {
      throw Exception('Bad request: check GUIDs or JSON structure');
    } else if (response.statusCode == 404) {
      throw Exception('List not found');
    } else {
      throw Exception('Failed to create task: ${response.statusCode}');
    }
  }

  Future<void> deleteTask(Task task) async {
    final token = await FlutterSecureStorage().read(key: 'auth_token');
    final response = await http.delete(
      Uri.parse('$baseUrl/tasks/${task.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 204 || response.statusCode == 200) {
      return; // Success: no content or optional body
    } else if (response.statusCode == 400) {
      throw Exception('Bad request: invalid list ID or format');
    } else if (response.statusCode == 404) {
      throw Exception('List not found');
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized: invalid or expired token');
    } else if (response.statusCode == 403) {
      throw Exception(
          'Forbidden: you do not have permission to delete this list');
    } else {
      throw Exception(
          'Failed to delete list: ${response.statusCode} - ${response.body}');
    }
  }

  //update the order values for tasks in a list
  Future<void> updateTaskOrder(List<Task> updatedTasks, String listGuid) async {
    final token = await FlutterSecureStorage().read(key: 'auth_token');
    final body = updatedTasks
        .map((task) => {
              "taskGuid": task.id,
              "position": task.order,
            })
        .toList();

    final response = await http.put(
      Uri.parse('$baseUrl/lists/$listGuid/tasks/reorder'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(body),
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to update task order');
    }
  }

  Future<void> moveTask(Task task) async {
    final url = Uri.parse('$baseUrl/tasks/${task.id}/move');

    final token = await FlutterSecureStorage().read(key: 'auth_token');
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "newListId": task.listId,
        "newOrder": task.order,
      }),
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to move task');
    }
  }
}
