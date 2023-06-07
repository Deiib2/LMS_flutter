import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lms_app/constants.dart';
import 'components/my_appbar.dart';
import 'components/navigation_drawer.dart';

class CreateUserScreen extends StatefulWidget {
  const CreateUserScreen({super.key});

  @override
  State<CreateUserScreen> createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _typeController = TextEditingController();

  createUser() async {
    String method;
    if (_typeController.text == 'librarian') {
      method = 'Librarian';
    } else {
      method = 'Reader';
    }
    final url = '$baseUrl/api/librarian/register$method';
    final body = {
      'email': _emailController.text,
      'password': _passwordController.text,
      'name': _nameController.text,
    };
    print(method);
    print(body);
    print(jsonEncode(body));
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode(body),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    final json = jsonDecode(response.body);
    print(' status ${response.statusCode}');
    if (response.statusCode == 200) {
      print('hiii $json');
      _emailController.clear();
      _passwordController.clear();
      _nameController.clear();
      _typeController.clear();
    } else {
      print('error $json');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: myAppBar(),
        drawer: const MyDrawer(),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(children: [
                const Text('Register a new User',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(height: 30),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Name',
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _typeController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'User Type',
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),
                // InputDecorator(
                //   decoration: const InputDecoration(
                //     border: OutlineInputBorder(),
                //     labelText: 'User Type',
                //     filled: true,
                //     fillColor: Colors.white,
                //   ),
                //   child: DropdownButtonHideUnderline(
                //     child: DropdownButton<String>(
                //       hint: const Text('User Type'),
                //       value: userType,
                //       onChanged: (newValue) {
                //         setState(() {
                //           userType = newValue!;
                //         });
                //         print('type is $userType');
                //       },
                //       items:
                //           <String>['librarian', 'reader'].map((String value) {
                //         return DropdownMenuItem<String>(
                //           value: value,
                //           child: Text(value),
                //         );
                //       }).toList(),
                //     ),
                //   ),
                // ),
                const SizedBox(height: 15),
                Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.black,
                    ),
                    child: MaterialButton(
                        onPressed: createUser,
                        child: const Text('SUBMIT',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            )))),
              ]),
            )));
  }
}
