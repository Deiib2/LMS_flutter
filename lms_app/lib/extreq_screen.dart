import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lms_app/components/extension_request_card.dart';
import 'package:lms_app/models/borrowed_item_model.dart';
import 'components/my_appbar.dart';
import 'components/navigation_drawer.dart';
import 'constants.dart';

class ExtReqScreen extends StatefulWidget {
  const ExtReqScreen({super.key});

  @override
  State<ExtReqScreen> createState() => _ExtReqScreenState();
}

class _ExtReqScreenState extends State<ExtReqScreen> {
  Future<List<BorrowedItem>> borrowedItemsFuture = getBorrowedItems();
  static Future<List<BorrowedItem>> getBorrowedItems() async {
    const url = '$baseUrl/api/librarian/getAllExtensionRequests';
    final response = await http.get(Uri.parse(url), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });
    final json = jsonDecode(response.body);
    if (response.statusCode == 200) {
      print('success');
      print(json);
      print(response.body);
    } else {
      print('failed');
      print(json);
    }
    return json.map<BorrowedItem>(BorrowedItem.fromJson).toList();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    borrowedItemsFuture = getBorrowedItems();
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: myAppBar(),
        drawer: const MyDrawer(),
        body: Column(
          children: [
            const SizedBox(height: 10),
            const Text(
              'Extension Requests',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Expanded(
              child: FutureBuilder(
                future: borrowedItemsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasData) {
                    final borroweditems = snapshot.data!;
                    return SingleChildScrollView(
                        physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics()),
                        child: ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) =>
                              ExtCard(borrowedItem: borroweditems[index]),
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 10),
                          itemCount: borroweditems.length,
                        ));
                  } else {
                    return const Center(
                      child: Text('No extension requests found'),
                    );
                  }
                },
              ),
            )
          ],
        ));
  }
}
