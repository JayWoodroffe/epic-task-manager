import 'package:flutter/material.dart';
import 'package:kanban_app/api/board_api.dart';
import 'package:kanban_app/models/board.dart';

//provides the current boards that have been retrieved for a project
//if a project is opened, its boards will be loaded into _boards[]
class BoardProvider with ChangeNotifier {
  List<dynamic> _boards = [];
  String currentProjectId = "";
  bool _isLoading = false;

  List<dynamic> get boards => _boards;
  bool get isLoading => _isLoading;

  Future<void> fetchBoardsForProject() async {
    _isLoading = true;
    notifyListeners();
    // currentProjectId = projectGuid;

    try {
      _boards = await BoardApi().getBoardsForProject(currentProjectId);
      print('Fetched ${_boards.length} boards.');
    } catch (e) {
      print('Error fetching boards: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> createBoard(Board board, String projectId) async {
    _isLoading = true;
    notifyListeners();
    try {
      await BoardApi().createBoard(board, projectId);
    } catch (e) {
      print('Error creating board: $e');
    }

    await fetchBoardsForProject();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateBoard(Board board) async {
    _isLoading = true;
    notifyListeners();
    try {
      await BoardApi().updateBoard(board);
    } catch (e) {
      print('Error updating board: $e');
    }

    //update only the changed project in your local list
    final index = _boards.indexWhere((b) => b.id == board.id);
    if (index != -1) {
      _boards[index] = board;
      notifyListeners();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteBoard(Board board) async {
    try {
      await BoardApi().deleteBoard(board);
    } catch (e) {
      print('Error deleting board: $e');
    }

    _boards.remove(board);
    notifyListeners();
  }
}
