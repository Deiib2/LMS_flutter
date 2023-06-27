import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'components/my_appbar.dart';
import 'components/navigation_drawer.dart';
import 'constants.dart';

class CreateItem extends StatefulWidget {
  const CreateItem({super.key});

  @override
  State<CreateItem> createState() => _CreateItemState();
}

class _CreateItemState extends State<CreateItem> {
  final _titleController = TextEditingController();
  final _typeController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _authorController = TextEditingController();
  final _totalCopiesController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  submitItem() async {
    const url = '$baseUrl/api/librarian/newItem';
    if (_totalCopiesController.text == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter total copies of the item'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    final body = {
      'title': _titleController.text,
      'type': _typeController.text,
      'imageUrl': _imageUrlController.text,
      'description': _descriptionController.text,
      'author': _authorController.text,
      'totalCopies': int.parse(_totalCopiesController.text),
    };
    print(jsonEncode(body));
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode(body),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    final json = jsonDecode(response.body);
    if (response.statusCode == 200) {
      print('hiii $json');
      _titleController.clear();
      _typeController.clear();
      _imageUrlController.clear();
      _descriptionController.clear();
      _authorController.clear();
      _totalCopiesController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Item created successfully'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      print('error $json');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $json'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
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
                const Text('Create a new Item',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(height: 30),
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Title',
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _typeController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Type',
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _imageUrlController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Image URL',
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Description',
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _authorController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Author',
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _totalCopiesController,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Total Copies',
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.black,
                    ),
                    child: MaterialButton(
                        onPressed: submitItem,
                        child: const Text('SUBMIT',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            )))),
              ]),
            )));
  }
}
