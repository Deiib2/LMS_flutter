import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  bool isLoggedIn() {
    // Check if the user is signed in by verifying if the required data exists in shared_preferences
    String? email = _prefs?.getString('email');
    String? userType = _prefs?.getString('userType');
    String? jwtToken = _prefs?.getString('jwtToken');

    return email != null && userType != null && jwtToken != null;
  }

  String? getUserEmail() {
    return _prefs?.getString('email');
  }

  String? getUserType() {
    return _prefs?.getString('userType');
  }

  String? getJwtToken() {
    return _prefs?.getString('jwtToken');
  }

  Future<void> useLogin(String email, String userType, String jwtToken) async {
    // Save user data to shared_preferences
    await _prefs?.setString('email', email);
    await _prefs?.setString('userType', userType);
    await _prefs?.setString('jwtToken', jwtToken);
  }

  Future<void> useLogout() async {
    // Clear user data from shared_preferences
    await _prefs?.remove('email');
    await _prefs?.remove('userType');
    await _prefs?.remove('jwtToken');
    print('Logged out');
  }
}
