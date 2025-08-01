import 'package:flutter/material.dart';
import 'package:kanban_app/models/project.dart';
import 'package:kanban_app/data/api/project_api.dart';

class ProjectProvider with ChangeNotifier {
  List<dynamic> _projects = [];
  List<dynamic> _users = [];
  bool _isLoading = false;

  List<dynamic> get projects => _projects;
  bool get isLoading => _isLoading;
  List<dynamic> get users => _users;

  Future<void> fetchAllProjects() async {
    _isLoading = true;
    notifyListeners();

    try {
      _projects = await ProjectApi().getAllProjects();
      print('Fetched ${_projects.length} projects.');
    } catch (e) {
      print('Error fetching projects: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchProjectsForUser() async {
    _isLoading = true;
    notifyListeners();

    try {
      _projects = await ProjectApi().getProjectsForUser();
      print('Fetched ${_projects.length} projects.');
    } catch (e) {
      print('Error fetching projects: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchAllUsers() async {
    _isLoading = true;
    notifyListeners();

    try {
      _users = await ProjectApi().getAllUsers();
      print('Fetched ${_users.length} users.');
    } catch (e) {
      print('Error fetching users: $e');
    }
  }
}
