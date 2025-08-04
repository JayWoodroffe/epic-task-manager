import 'package:kanban_app/models/task.dart';

class ListType {
  final String id;
  final String name;
  final int position; //left to right ordering of list within the board
  final String status;
  final String color;
  List<Task> tasks;

  ListType(
      {required this.id,
      required this.name,
      required this.position,
      required this.status,
      required this.color,
      this.tasks = const []});

  factory ListType.fromJson(Map<String, dynamic> json) => ListType(
      id: json['guid'] as String,
      name: json['name'],
      position: json['position'] as int,
      status: json['status'],
      color: json['color'],
      tasks: (json['tasks'] as List<dynamic>?)
              ?.map((u) => Task.fromJson(u))
              .toList() ??
          []);

  Map<String, dynamic> toJson() => {
        'guid': id,
        'name': name,
        'position': position,
        'status': status,
        'color': color,
        'tasks': tasks.map((u) => u.toJson()).toList(),
      };

//only used when creating a new list and guid key shouldn't be included
  Map<String, dynamic> toCreateJson() => {
        'name': name,
        'position': position,
        'status': status.isNotEmpty ? status : "",
        'color': color.isNotEmpty ? color : "",
        'tasks': tasks.map((u) => u.toJson()).toList(),
      };

  bool isSameAs(ListType other) {
    if (id != other.id) return false;
    if (name != other.name) return false;
    if (status != other.status) return false;
    if (color != other.status) return false;

    // Compare tasks list length first
    if (tasks.length != other.tasks.length) return false;

    // Compare each task
    for (int i = 0; i < tasks.length; i++) {
      if (tasks[i] != other.tasks[i]) return false;
    }
    return true;
  }
}
