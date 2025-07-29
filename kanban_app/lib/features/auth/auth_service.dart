import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

//handle user login, receiving anf securely storing JWT token from the backend,
class AuthService {
  final _storage = const FlutterSecureStorage();
  final String baseUrl = 'http://192.168.1.54:5285/api';
  String? _role;

  String? get role => _role;

  Future<bool> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/auth/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];

      // Decode JWT to extract role
      Map<String, dynamic> decoded = JwtDecoder.decode(token!);
      _role = decoded['role'];

      await _storage.write(
          key: 'auth_token',
          value: token); //saving the retrieved JWT token to secure storage
      return true;
    } else {
      return false;
    }
  }

  //returning the JWT token
  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  //deleting the JWT token upon logout
  Future<void> logout() async {
    await _storage.delete(key: 'auth_token');
  }
}
