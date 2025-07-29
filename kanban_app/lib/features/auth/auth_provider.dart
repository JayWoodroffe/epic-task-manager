import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:kanban_app/features/auth/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  String? _token;
  String? _email;
  String? _role;
  String? _guid;

  bool get isLoggedIn => _token != null;
  String? get guid => _guid;
  String? get role => _role;

  Future<bool> login(String email, String password) async {
    final loggedIn = await _authService.login(
        email, password); //login returns a bool to show success

    if (loggedIn) {
      _token = await _authService.getToken();

      // Decode the JWT
      final payload = JwtDecoder.decode(_token!);
      _email = payload['email'];
      _guid = payload['guid'];
      _role = payload['role'];

      notifyListeners();
      return true;
    }

    return false;
  }

  void logout() {
    _token = null;
    _email = null;
    _guid = null;
    _role = null;
    _authService.logout();
    notifyListeners();
  }
}
