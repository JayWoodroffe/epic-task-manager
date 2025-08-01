class User {
  String fullName;
  String role;
  String email;

  User({required this.fullName, this.role = 'user', required this.email});

  // Factory constructor to create a User from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      fullName: json['fullName'],
      role: json['role'] ?? 'user',
      email: json['email'],
    );
  }

  // Method to convert a User to JSON
  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'role': role,
      'email': email,
    };
  }
}
