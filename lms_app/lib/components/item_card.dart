import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lms_app/constants.dart';
import 'package:lms_app/item_model.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

Widget buildItemCard(Item item) {
  final itemcover = item.title == 'Rich Dad, Poor Dad'
      ? 'assets/images/Rich_dad_cover.jpg'
      : item.title == 'The Lord of the Rings'
          ? 'assets/images/lotr_cover.jpg'
          : 'assets/images/bookcover.jpg';
  return Card(
    margin: const EdgeInsets.all(8),
    child: Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image(
            image: AssetImage(itemcover),
            height: 200.0,
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  item.description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Text(
                  'Author: ${item.author}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class MyItemCard extends StatefulWidget {
  final Item item;
  final String? token;
  const MyItemCard({super.key, required this.item, required this.token});

  @override
  State<MyItemCard> createState() => _MyItemCardState();
}

class _MyItemCardState extends State<MyItemCard> {
  final newDateController = TextEditingController();
  String newDate = DateFormat('yyyy-MM-dd')
      .format(DateTime.now().add(const Duration(days: 14)));
  Future<DateTime>? dueDate;
  bool loading1 = false;

  Future<DateTime> getDueDate() async {
    final url = '$baseUrl/api/reader/getDueDate/${widget.item.id}';
    final response = await http.get(Uri.parse(url), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${widget.token}'
    });
    final json = jsonDecode(response.body);
    print("json $json");
    print('object DateTime parsed ${DateTime.parse(json)}');
    return DateTime.parse(json);
  }

  Future<void> extendDueDate(context) async {
    setState(() {
      loading1 = true;
    });
    const url = '$baseUrl/api/reader/requestExtension';
    final body = {
      'itemId': widget.item.id,
      'newDate': newDate,
    };
    final response = await http
        .post(Uri.parse(url), body: jsonEncode(body), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${widget.token}'
    });
    final json = jsonDecode(response.body);
    print("json $json");
    setState(() {
      loading1 = false;
    });
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Request successfully sent!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Request failed!'),
          backgroundColor: Colors.red,
        ),
      );
      print('error $json');
    }
  }

  onPressMore() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Due date extension request'),
            content: Column(
              children: [
                const Text(
                    'Please enter the date you wish to extend the due date to.'),
                const SizedBox(height: 10),
                TextField(
                  controller: newDateController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    icon: Icon(Icons.calendar_today),
                    hintText: 'Date',
                  ),
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now().add(const Duration(days: 14)),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      setState(() {
                        newDate = DateFormat('yyyy-MM-dd').format(picked);
                        newDateController.text = newDate;
                      });
                    }
                  },
                ),
                const SizedBox(height: 4),
                if (loading1) const LinearProgressIndicator(),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () async {
                  await extendDueDate(context);
                },
                child: const Text('SUBMIT REQUEST'),
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    dueDate = getDueDate();
    newDateController.text = newDate;
  }

  @override
  Widget build(BuildContext context) {
    final itemcover = widget.item.title == 'Rich Dad, Poor Dad'
        ? 'assets/images/Rich_dad_cover.jpg'
        : widget.item.title == 'The Lord of the Rings'
            ? 'assets/images/lotr_cover.jpg'
            : 'assets/images/bookcover.jpg';
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              image: AssetImage(itemcover),
              height: 200.0,
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      widget.item.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.item.description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Author: ${widget.item.author}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 5),
                  FutureBuilder(
                    future: dueDate,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text('Due date: loading...');
                      } else if (snapshot.hasData) {
                        final formattedDate =
                            DateFormat('dd-MM-yyyy').format(snapshot.data!);
                        return Text('Due date: $formattedDate');
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }
                      return const Text('');
                    },
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      MaterialButton(
                        onPressed: onPressMore,
                        child: const Icon(Icons.more_vert),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
