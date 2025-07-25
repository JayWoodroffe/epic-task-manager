import 'package:kanban_app/models/base_model.dart';

class List extends BaseModel {
  String name;
  int boardId;
  int position; //left to right ordering of list within the board
  String statusId;

  List({
    required super.id,
    required super.createdOn,
    required super.createdBy,
    super.updatedOn,
    super.updatedBy,
    super.isActive = true,
    required this.name,
    required this.boardId,
    required this.position,
    required this.statusId,
  });
}
