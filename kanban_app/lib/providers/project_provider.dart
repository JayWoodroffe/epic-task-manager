import 'package:flutter/material.dart';
import 'package:kanban_app/models/project.dart';
import 'package:kanban_app/api/project_api.dart';

class ProjectProvider with ChangeNotifier {
  List<dynamic> _projects = [];
  List<dynamic> _users = [];
  bool _isLoading = false;

  List<dynamic> get projects => _projects;
  bool get isLoading => _isLoading;
  List<dynamic> get users => _users;

  //used for admins
  Future<void> fetchAllProjects() async {
    _isLoading = true;
    notifyListeners();

    try {
      _projects = await ProjectApi().getAllProjects();
    } catch (e) {
      print('Error fetching projects: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  //for regular users
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
    try {
      _users = await ProjectApi().getAllUsers();
      print('Fetched ${_users.length} users.');
    } catch (e) {
      print('Error fetching users: $e');
    }
  }

  Future<void> updateProject(Project project) async {
    try {
      await ProjectApi().updateProject(project);
    } catch (e) {
      print('Error updating project: $e');
    }

    //update only the changed project in your local list
    final index = _projects.indexWhere((p) => p.id == project.id);
    if (index != -1) {
      _projects[index] = project;
      notifyListeners();
    }
  }

  Future<void> createProject(Project project) async {
    try {
      await ProjectApi().createProject(project);
    } catch (e) {
      print('Error updating project: $e');
    }

    await fetchAllProjects();
  }

  Future<void> deleteProject(Project project) async {
    try {
      await ProjectApi().deleteProject(project);
    } catch (e) {
      print('Error deleting project: $e');
    }

    _projects.remove(project);
    notifyListeners();
  }
}
