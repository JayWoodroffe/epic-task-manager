import 'package:flutter/material.dart';
import 'package:kanban_app/api/list_api.dart';
import 'package:kanban_app/models/list.dart';
import 'package:kanban_app/models/task.dart';

//manages both the lists of a given baord as well as the tasks in that list
class ListProvider with ChangeNotifier {
  List<dynamic> _lists = [];
  String currentBoardId = "";
  bool _isLoadingList = false; //for when list data is being loaded
  bool _isLoadingTask = false; //for when task data is being loaded

  List<dynamic> get lists => _lists;
  bool get isLoadingList => _isLoadingList;
  bool get isLoadingTask => _isLoadingTask;

  Future<void> fetchListsForBoard() async {
    _isLoadingList = true;
    notifyListeners();

    try {
      _lists = await ListApi().getListsForBoard(currentBoardId);
    } catch (e) {
      print('Error fetching lists: $e');
    }

    _isLoadingList = false;
    notifyListeners();
  }

  Future<void> createList(ListType list, String boardId) async {
    _isLoadingList = true;
    notifyListeners();
    try {
      await ListApi().createList(list, boardId);
    } catch (e) {
      print('Error creating list: $e');
    }

    await fetchListsForBoard();
    _isLoadingList = false;
    notifyListeners();
  }

  Future<void> updateList(ListType list) async {
    _isLoadingTask = true;
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
    _isLoadingTask = false;
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
    _isLoadingTask = true;
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
      _isLoadingTask = false;
      notifyListeners();
    }
  }

  //for reordering tasks within a single list
  Future<void> reorderTasks(List<Task> updatedTasks, String listId) async {
    _isLoadingTask = true;
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

    _isLoadingTask = false;
    notifyListeners();
  }

  Future<void> createTask(Task task, String listId) async {
    _isLoadingTask = true;
    notifyListeners();
    try {
      await ListApi().createTask(task, listId);
      //updating the local data
      final listIndex = _lists.indexWhere((l) => l.id == listId);
      if (listIndex != -1) {
        final list = _lists[listIndex] as ListType;
        list.tasks.add(task);
        _lists[listIndex] = list;
      }
    } catch (e) {
      print('Error creating list: $e');
    }

    // await fetchListsForBoard();
    _isLoadingTask = false;
    notifyListeners();
  }

  //for moving tasks between different lists
  Future<void> moveTaskToList(Task task, String oldListId) async {
    _isLoadingTask = true;
    notifyListeners();

    try {
      //updating the local data
      //remove task from previous list
      final oldListIndex = _lists.indexWhere((l) => l.id == oldListId);
      if (oldListIndex != -1) {
        final oldList = _lists[oldListIndex] as ListType;
        oldList.tasks.removeWhere((t) => t.id == task.id);
        _lists[oldListIndex] = oldList;
      }

      //add task to new list
      final newListIndex = _lists.indexWhere((l) => l.id == task.listId);
      if (newListIndex != -1) {
        final newList = _lists[newListIndex] as ListType;
        newList.tasks.add(task);
        _lists[newListIndex] = newList;
      }
      await ListApi().moveTask(task);
    } catch (e) {
      print('Error moving task: $e');
    }

    _isLoadingTask = false;
    notifyListeners();
  }
}
