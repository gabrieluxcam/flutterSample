import 'package:flutter/foundation.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  String? _email;
  String? _avatarPath;
  bool get isLoggedIn => _isLoggedIn;
  String? get email => _email;
  String? get avatarPath => _avatarPath;

  Future<void> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    if (email.isNotEmpty && password.isNotEmpty) {
      _email = email;
      _isLoggedIn = true;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    _email = null;
    _avatarPath = null;
    notifyListeners();
  }

  void setAvatar(String path) {
    _avatarPath = path;
    notifyListeners();
  }

  /// Allows changing the user's email after login
  Future<void> updateEmail(String newEmail) async {
    _email = newEmail;
    notifyListeners();
  }
}
