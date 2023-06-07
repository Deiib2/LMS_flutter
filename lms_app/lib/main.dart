import 'package:flutter/material.dart';
import 'package:lms_app/auth_service.dart';
import 'package:lms_app/home_screen.dart';
import 'package:lms_app/login_screen.dart';
import 'package:provider/provider.dart';

import 'auth_provider.dart';
import 'create_item_screen.dart';
import 'explore_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AuthService authService = AuthService();
  await authService.init();

  runApp(ChangeNotifierProvider<AuthProvider>(
      create: (_) => AuthProvider(authService), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const ExploreScreen(),
        theme: ThemeData(
          fontFamily: 'Poppins',
        ));
  }
}
