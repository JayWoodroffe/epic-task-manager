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
  bool get isAdmin => _role == "admin";

  Future<bool> login(String email, String password) async {
    final loggedIn = await _authService.login(
        email, password); //login returns a bool to show success

    if (loggedIn) {
      _token = await _authService.getToken();

      // Decode the JWT
      final payload = JwtDecoder.decode(_token!);
      _email = payload['email'];
      _guid = payload['guid'];
      _role = payload[
          'http://schemas.microsoft.com/ws/2008/06/identity/claims/role'];

      debugPrint('Decoded JWT payload: $payload');
      debugPrint('Extracted role: $_role');

      notifyListeners();
      return true;
    }

    return false;
  }

  Future<String?> register(String name, String email, String password,
      String confirmPassword) async {
    final errorMessage =
        await _authService.register(name, email, password, confirmPassword);

    if (errorMessage == null) {
      _token = await _authService.getToken();
      final payload = JwtDecoder.decode(_token!);
      _email = payload['email'];
      _guid = payload['guid'];
      _role = payload[
          'http://schemas.microsoft.com/ws/2008/06/identity/claims/role'];
      notifyListeners();
    }
    //returns null if successful, error message otherwise
    return errorMessage;
  }

  String checkPasswordValidity(String password) {
    String _errorMessage = '';

    // Password length greater than 6
    if (password.length < 6) {
      _errorMessage += 'Password must be longer than 6 characters.\n';
    }
    // Contains at least one uppercase letter
    if (!password.contains(RegExp(r'[A-Z]'))) {
      _errorMessage += '• Uppercase letter is missing.\n';
    }
    // Contains at least one lowercase letter
    if (!password.contains(RegExp(r'[a-z]'))) {
      _errorMessage += '• Lowercase letter is missing.\n';
    }
    // Contains at least one digit
    if (!password.contains(RegExp(r'[0-9]'))) {
      _errorMessage += '• Digit is missing.\n';
    }
    // Contains at least one special character
    if (!password.contains(RegExp(r'[!@#%^&*(),.?":{}|<>]'))) {
      _errorMessage += '• Special character is missing.\n';
    }
    // If there are no error messages, the password is valid
    return _errorMessage;
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
