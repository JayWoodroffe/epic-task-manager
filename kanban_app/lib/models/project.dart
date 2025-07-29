import 'package:kanban_app/models/base_model.dart';

class Project {
  final String id;
  final String name;
  final String description;

  Project({
    required this.id,
    required this.name,
    required this.description,
  });

  factory Project.fromJson(Map<String, dynamic> json) => Project(
        id: json['guid'] as String,
        name: json['name'],
        description: json['description'],
      );

  Map<String, dynamic> toJson() => {'name': name, 'description': description};
}
