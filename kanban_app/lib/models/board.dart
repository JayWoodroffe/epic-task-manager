class Board {
  final String name;
  final String description;
  final String id;

  Board({required this.name, required this.description, required this.id});

  factory Board.fromJson(Map<String, dynamic> json) => Board(
        id: json['guid'] as String,
        name: json['name'],
        description: json['description'],
      );

  Map<String, dynamic> toJson() => {
        'guid': id,
        'name': name,
        'description': description,
      };

//only used when creating a new project and guid key shouldn't be included
  Map<String, dynamic> toCreateJson() => {
        'name': name,
        'description': description,
      };

  bool isSameAs(Board other) {
    if (id != other.id) return false;
    if (name != other.name) return false;
    if (description != other.description) return false;

    return true;
  }
}
