import 'package:flutter/material.dart';
import 'package:kanban_app/data/api/boards_api.dart';
import 'package:kanban_app/data/api/list_api.dart';
import 'package:kanban_app/models/list.dart';
import 'package:kanban_app/models/task.dart';

//TODO: do i want this to also provide the tasks - ie: i a task gets moved, added, changed, would this provider update
class ListProvider with ChangeNotifier {
  List<dynamic> _lists = [];
  String currentBoardId = "";
  bool _isLoading = false;

  List<dynamic> get lists => _lists;
  bool get isLoading => _isLoading;

  Future<void> fetchListsForBoard() async {
    _isLoading = true;
    notifyListeners();

    try {
      _lists = await ListApi().getListsForBoard(currentBoardId);
      print('Fetched ${_lists.length} lists.');
    } catch (e) {
      print('Error fetching lists: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> createList(ListType list, String boardId) async {
    _isLoading = true;
    notifyListeners();
    try {
      await ListApi().createList(list, boardId);
    } catch (e) {
      print('Error creating list: $e');
    }

    await fetchListsForBoard();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateList(ListType list) async {
    _isLoading = true;
    notifyListeners();
    try {
      await ListApi().updateList(list);
    } catch (e) {
      print('Error updating list: $e');
    }

    //update only the changed list
    final index = _lists.indexWhere((l) => l.id == list.id);
    if (index != -1) {
      _lists[index] = list;
      notifyListeners();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteList(ListType list) async {
    try {
      await ListApi().deleteList(list);
    } catch (e) {
      print('Error deleting list: $e');
    }

    _lists.remove(list);
    notifyListeners();
  }

  Future<void> deleteTask(Task task) async {
    _isLoading = true;
    notifyListeners();
    try {
      await ListApi().deleteTask(task);
    } catch (e) {
      print('Error deleting task: $e');
    }

    //find the list the task belongs to
    final listIndex = _lists.indexWhere((l) => l.id == task.listId);

    if (listIndex != -1) //found the list
    {
      final list = _lists[listIndex] as ListType;
      list.tasks
          .removeWhere((t) => t.id == task.id); //remove the task from the list
      _lists[listIndex] = list; //update the list
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> reorderTasks(List<Task> updatedTasks, String listId) async {
    _isLoading = true;
    notifyListeners();

    try {
      // immediately update the local list's order
      final listIndex = _lists.indexWhere((l) => l.id == listId);
      if (listIndex != -1) {
        final list = _lists[listIndex] as ListType;
        list.tasks = List.from(updatedTasks); // replace with the reordered list
        _lists[listIndex] = list;
      }

      // sync with the backend
      await ListApi().updateTaskOrder(updatedTasks, listId);
    } catch (e) {
      print('Error reordering tasks: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> createTask(Task task, String listId) async {
    _isLoading = true;
    notifyListeners();
    try {
      await ListApi().createTask(task, listId);
    } catch (e) {
      print('Error creating list: $e');
    }

    await fetchListsForBoard();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> moveTaskToList(Task task, String oldListId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await ListApi().moveTask(task);
      await fetchListsForBoard(); // refresh all lists/tasks
    } catch (e) {
      print('Error moving task: $e');
    }

    _isLoading = false;
    notifyListeners();
  }
}
