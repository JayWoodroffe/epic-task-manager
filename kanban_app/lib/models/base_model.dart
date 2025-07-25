abstract class BaseModel {
  final String id; //guid
  final DateTime createdOn;
  final DateTime? updatedOn;
  final String createdBy;
  final String? updatedBy;
  final bool isActive;

  BaseModel({
    required this.id,
    required this.createdOn,
    required this.createdBy,
    this.updatedOn,
    this.updatedBy,
    this.isActive = true,
  });
}
