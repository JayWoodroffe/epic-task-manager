class User {
  String fullName;
  String role;
  String email;
  String id;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'User(email: $email)';

  User(
      {required this.id,
      required this.fullName,
      this.role = 'user',
      required this.email});

  // Factory constructor to create a User from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['guid'],
      fullName: json['fullName'],
      role: json['role'] ?? 'user',
      email: json['email'],
    );
  }

  // Method to convert a User to JSON
  Map<String, dynamic> toJson() {
    return {
      'guid': id,
      'fullName': fullName,
      'role': role,
      'email': email,
    };
  }
}
