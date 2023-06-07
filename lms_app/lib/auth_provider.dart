import 'package:flutter/material.dart';

import 'auth_service.dart';

class AuthProvider extends ChangeNotifier {
  AuthService authService;

  AuthProvider(this.authService);

  bool isLoggedIn() {
    return authService.isLoggedIn();
  }

  String? getUserEmail() {
    return authService.getUserEmail();
  }

  String? getUserType() {
    return authService.getUserType();
  }

  String? getJwtToken() {
    return authService.getJwtToken();
  }

  Future<void> useLogin(String email, String userType, String jwtToken) async {
    await authService.useLogin(email, userType, jwtToken);
    notifyListeners();
  }

  Future<void> useLogout() async {
    await authService.useLogout();
    notifyListeners();
  }

  // Delegate the remaining methods in a similar manner
}
