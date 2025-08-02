import 'package:flutter/material.dart';
import 'package:kanban_app/data/api/boards_api.dart';
import 'package:kanban_app/models/board.dart';
import 'package:kanban_app/models/project.dart';
import 'package:kanban_app/data/api/project_api.dart';

class BoardProvider with ChangeNotifier {
  List<dynamic> _boards = [];
  bool _isLoading = false;

  List<dynamic> get boards => _boards;
  bool get isLoading => _isLoading;

  Future<void> fetchBoardsForProject(String projectGuid) async {
    _isLoading = true;
    notifyListeners();

    try {
      _boards = await BoardApi().getBoardsForProject(projectGuid);
      print('Fetched ${_boards.length} boards.');
    } catch (e) {
      print('Error fetching boards: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateBoard(Board board) async {
    try {
      await BoardApi().updateBoard(board);
    } catch (e) {
      print('Error updating project: $e');
    }

    //update only the changed project in your local list
    final index = _boards.indexWhere((b) => b.id == board.id);
    if (index != -1) {
      _boards[index] = board;
      notifyListeners();
    }
  }
}
