import 'package:kanban_app/models/base_model.dart';

class Project extends BaseModel {
  String name;
  String description;

  Project({
    required super.id,
    required super.createdOn,
    required super.createdBy,
    super.updatedOn,
    super.updatedBy,
    super.isActive = true,
    required this.name,
    required this.description,
  });
}
