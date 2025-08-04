class Task {
  final String id;
  final String name;
  final String listId;
  final int order; //this task's order in the list

  Task({
    required this.id,
    required this.name,
    required this.listId,
    required this.order,
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json['guid']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        listId: json['listId']?.toString() ?? '',
        order: (json['position'] ?? 0) is int
            ? json['position']
            : int.tryParse(json['position'].toString()) ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'guid': id,
        'name': name,
        'listId': listId,
        'position': order,
      };

//only used when creating a new project and guid key shouldn't be included
  Map<String, dynamic> toCreateJson() => {
        'name': name,
        'position': order,
      };

  bool isSameAs(Task other) {
    if (id != other.id) return false;
    if (name != other.name) return false;
    if (order != other.order) return false;
    if (listId != other.listId) return false;

    return true;
  }

  Task copyWith({
    String? id,
    String? name,
    String? listId,
    int? order,
  }) {
    return Task(
      id: id ?? this.id,
      name: name ?? this.name,
      listId: listId ?? this.listId,
      order: order ?? this.order,
    );
  }
}
