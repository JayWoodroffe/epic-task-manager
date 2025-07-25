import 'package:flutter/material.dart';
import 'package:kanban_app/models/base_model.dart';

class Status extends BaseModel {
  String name;
  Color color;

  Status({
    required super.id,
    required super.createdOn,
    required super.createdBy,
    super.updatedOn,
    super.updatedBy,
    super.isActive = true,
    required this.name,
    required this.color,
  });
}
