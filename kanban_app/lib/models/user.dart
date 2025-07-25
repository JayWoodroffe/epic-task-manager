import 'package:kanban_app/models/base_model.dart';

class User extends BaseModel {
  String fullName;
  String role;
  String email;

  User(
      {required super.id,
      required super.createdOn,
      required super.createdBy,
      super.updatedOn,
      super.updatedBy,
      super.isActive = true,
      required this.fullName,
      this.role = 'user',
      required this.email});
}
