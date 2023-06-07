import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lms_app/auth_provider.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../models/borrowed_item_model.dart';

class ExtCard extends StatefulWidget {
  BorrowedItem borrowedItem;
  ExtCard({super.key, required this.borrowedItem});

  @override
  State<ExtCard> createState() => _ExtCardState();
}

class _ExtCardState extends State<ExtCard> {
  bool isCardVisible = true;
  Future<String> getItemName() async {
    final url = '$baseUrl/api/librarian/getItem/${widget.borrowedItem.itemId}';
    final response = await http.get(Uri.parse(url));
    final json = jsonDecode(response.body);
    print(' status ${response.statusCode}');
    if (response.statusCode == 200) {
      print('hiii $json');
      return json['title'];
    } else {
      print('error $json');
      return 'Can\'t get item name';
    }
  }

  Future<String> getReaderName() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final url =
        '$baseUrl/api/librarian/getReader/${widget.borrowedItem.readerId}';
    final response = await http.get(Uri.parse(url), headers: {
      'Authorization': 'Bearer ${authProvider.getJwtToken()}',
    });
    final json = jsonDecode(response.body);
    print(' status ${response.statusCode}');
    if (response.statusCode == 200) {
      print('hiii $json');
      return json['name'];
    } else {
      print('error $json');
      return 'Can\'t get reader name';
    }
  }

  Future<String> getReaderEmail() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final url =
        '$baseUrl/api/librarian/getUserEmail/${widget.borrowedItem.readerId}';
    final response = await http.get(Uri.parse(url), headers: {
      'Authorization': 'Bearer ${authProvider.getJwtToken()}',
    });
    final json = jsonDecode(response.body);
    print(' status ${response.statusCode}');
    if (response.statusCode == 200) {
      print('hiii $json');
      return json;
    } else {
      print('error $json');
      return 'Can\'t get reader email';
    }
  }

  Future<void> onGrant() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    const url = '$baseUrl/api/librarian/grantExtension';
    final body = {
      'borrowedId': widget.borrowedItem.id,
      'newDate': widget.borrowedItem.extensionDate
    };
    final response = await http
        .put(Uri.parse(url), body: jsonEncode(body), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${authProvider.getJwtToken()}'
    });
    print('body not encoded: $body');
    print('body encoded: ${jsonEncode(body)}');
    final json = jsonDecode(response.body);
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Request Granted Successfully'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      setState(() {
        isCardVisible = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Action Failed: ${json['error']}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> onDeny() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    const url = '$baseUrl/api/librarian/denyExtension';
    final body = {'borrowedId': widget.borrowedItem.id};
    final response = await http
        .put(Uri.parse(url), body: jsonEncode(body), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${authProvider.getJwtToken()}'
    });
    final json = jsonDecode(response.body);
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Request Denied Successfully'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      setState(() {
        isCardVisible = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Action Failed: ${json['error']}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future<String> itemName = getItemName();
    Future<String> readerName = getReaderName();
    Future<String> readerEmail = getReaderEmail();
    String currDueDate = widget.borrowedItem.returnDate.substring(0, 10);
    String requestedDueDate =
        widget.borrowedItem.extensionDate.substring(0, 10);
    if (!isCardVisible) {
      return Container();
    }
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(children: [
          const Text("Item name:",
              style: TextStyle(
                fontSize: 12,
              )),
          FutureBuilder(
              future: itemName,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LinearProgressIndicator(
                    color: Colors.black,
                  );
                } else if (snapshot.hasError) {
                  return SelectableText('${snapshot.error}');
                } else if (snapshot.hasData) {
                  return Text(
                    '${snapshot.data}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                } else {
                  return const Text('Could not load data from the server');
                }
              }),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(
                child: Column(children: [
              const Text("Reader name:",
                  style: TextStyle(
                    fontSize: 12,
                  )),
              FutureBuilder(
                future: readerName,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const LinearProgressIndicator(
                      color: Colors.black,
                    );
                  } else if (snapshot.hasError) {
                    return SelectableText('${snapshot.error}');
                  } else if (snapshot.hasData) {
                    return Text(
                      '${snapshot.data}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  } else {
                    return const Text('Could not load data from the server');
                  }
                },
              )
            ])),
            Expanded(
              child: Column(children: [
                const Text('Reader Email:',
                    style: TextStyle(
                      fontSize: 12,
                    )),
                FutureBuilder(
                  future: readerEmail,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const LinearProgressIndicator(
                        color: Colors.black,
                      );
                    } else if (snapshot.hasError) {
                      return SelectableText('${snapshot.error}');
                    } else if (snapshot.hasData) {
                      return Text(
                        '${snapshot.data}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    } else {
                      return const Text('Could not load data from the server');
                    }
                  },
                )
              ]),
            ),
          ]),
          const SizedBox(height: 16),
          const Text(
            'Current Due date:',
            style: TextStyle(
              fontSize: 12,
            ),
          ),
          Text(
            currDueDate,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Requested Due date:',
            style: TextStyle(
              fontSize: 12,
            ),
          ),
          Text(
            requestedDueDate,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton(
              onPressed: onGrant,
              //style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text('GRANT'),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
                onPressed: onDeny,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                ),
                child: const Text(
                  'DENY',
                  style: TextStyle(color: Colors.black),
                )),
          ]),
        ]),
      ),
    );
  }
}
