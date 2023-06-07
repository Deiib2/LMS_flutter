import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lms_app/components/navigation_drawer.dart';
import 'package:lms_app/constants.dart';
import 'package:provider/provider.dart';

import 'auth_provider.dart';
import 'components/my_appbar.dart';
import 'explore_screen.dart';

class LoginScreen extends StatelessWidget {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> submitLogin(authProvider, context) async {
    isLoading = true;
    const url = '$baseUrl/api/auth/signIn';
    final body = {
      'email': emailController.text,
      'password': passwordController.text,
    };
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode(body),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    final json = jsonDecode(response.body);
    if (response.statusCode == 200) {
      await authProvider.useLogin(json['email'], json['type'], json['token']);
      print('Login successful');
      print('Email: ${authProvider.getUserEmail()}');
      print('User Type: ${authProvider.getUserType()}');
      print('JWT Token: ${authProvider.getJwtToken()}');
      print('Is Logged In: ${authProvider.isLoggedIn()}');
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const ExploreScreen(),
      ));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login Successful'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      print('Login failed');
      print('Error: ${json['error']}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login Failed: ${json['error']}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return (Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: myAppBar(),
        drawer: const MyDrawer(),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Icon(Icons.lock, size: 100, color: Colors.black),
                  const SizedBox(
                    height: 40,
                  ),
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: 'Email Address',
                      prefixIcon: Icon(
                        Icons.email,
                      ),
                      border: OutlineInputBorder(),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    onFieldSubmitted: (value) {
                      // handle the submit
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: passwordController,
                    decoration: const InputDecoration(
                      hintText: 'Password',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.black,
                      ),
                      child: MaterialButton(
                          onPressed: () async {
                            submitLogin(authProvider, context);
                          },
                          child: const Text('LOGIN',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              )))),
                  if (isLoading) const LinearProgressIndicator()
                ],
              ),
            ))));
  }
}
