import 'package:kanban_app/models/base_model.dart';
import 'package:kanban_app/models/user.dart';

class Project {
  final String id;
  final String name;
  final String description;
  final List<User> users;

  Project(
      {required this.id,
      required this.name,
      required this.description,
      this.users = const []});

  factory Project.fromJson(Map<String, dynamic> json) => Project(
        id: json['guid'] as String,
        name: json['name'],
        description: json['description'],
        users: (json['users'] as List<dynamic>?)
                ?.map((u) => User.fromJson(u))
                .toList() ??
            [],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'users': users.map((u) => u.toJson()).toList(),
      };
}
