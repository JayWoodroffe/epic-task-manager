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
    this.updatedOn,
    required this.createdBy,
    this.updatedBy,
    this.isActive = true,
  });
}
