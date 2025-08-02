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
        'guid': id,
        'name': name,
        'description': description,
        'users': users.map((u) => u.toJson()).toList(),
      };

//only used when creating a new project and guid key shouldn't be included
  Map<String, dynamic> toCreateJson() => {
        'name': name,
        'description': description,
        'users': users.map((u) => u.toJson()).toList(),
      };

  bool isSameAs(Project other) {
    if (id != other.id) return false;
    if (name != other.name) return false;
    if (description != other.description) return false;

    // Compare users list length first
    if (users.length != other.users.length) return false;

    // Compare each user
    for (int i = 0; i < users.length; i++) {
      if (users[i] != other.users[i]) return false;
    }

    return true;
  }
}
