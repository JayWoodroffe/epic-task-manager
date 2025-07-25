import 'package:kanban_app/models/base_model.dart';

class Task extends BaseModel {
  String name;
  int listId;
  int statusId;
  int order; //this task's order in the list

  Task({
    required super.id,
    required super.createdOn,
    required super.createdBy,
    super.updatedOn,
    super.updatedBy,
    super.isActive = true,
    required this.name,
    required this.listId,
    required this.statusId,
    required this.order,
  });
}
