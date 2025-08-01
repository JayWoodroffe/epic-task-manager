import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:jwt_decoder/jwt_decoder.dart';

//handle user login, receiving anf securely storing JWT token from the backend,
class AuthService {
  final _storage = const FlutterSecureStorage();
  final String baseUrl = 'http://192.168.1.54:5285/api';

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

      await _storage.write(
          key: 'auth_token',
          value: token); //saving the retrieved JWT token to secure storage
      return true;
    } else {
      return false;
    }
  }

  Future<String?> register(String name, String email, String password,
      String confirmPassword) async {
    final url = Uri.parse('$baseUrl/auth/register');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "fullName": name,
        "email": email,
        "password": password,
        "confirmPassword": confirmPassword
      }),
    );

    if (response.statusCode == 200) {
      final token = jsonDecode(response.body)['token'];
      await _storage.write(key: 'auth_token', value: token);
      return null;
    } else {
      try {
        final body = jsonDecode(response.body);
        if (body is Map<String, dynamic> && body.containsKey('message')) {
          return body['message'];
        } else {
          return 'Unexpected error response format.';
        }
      } catch (e) {
        return 'Server error: ${response.statusCode}';
      }
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
