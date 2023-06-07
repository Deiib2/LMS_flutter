import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lms_app/auth_provider.dart';
import 'package:lms_app/constants.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'components/item_card.dart';
import 'components/my_appbar.dart';
import 'components/navigation_drawer.dart';
import 'item_model.dart';

class MyItemsScreen extends StatefulWidget {
  const MyItemsScreen({super.key});

  @override
  State<MyItemsScreen> createState() => _MyItemsScreenState();
}

class _MyItemsScreenState extends State<MyItemsScreen> {
  static Future<List<Item>> getMyItems(authProvider) async {
    const url = '$baseUrl/api/reader/currentBorrowedItems';
    final token = authProvider.getJwtToken();
    final response = await http.get(Uri.parse(url), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    });
    final json = jsonDecode(response.body);
    return json.map<Item>(Item.fromJson).toList();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    Future<List<Item>> itemsFuture = getMyItems(authProvider);
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: myAppBar(),
        drawer: const MyDrawer(),
        body: Column(
          children: [
            const SizedBox(height: 10),
            const Text('My Items',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Expanded(
                child: FutureBuilder<List<Item>>(
                    future: itemsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                            child: SelectableText('${snapshot.error}'));
                      } else if (snapshot.hasData) {
                        final items = snapshot.data!;
                        return SingleChildScrollView(
                            physics: const BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics()),
                            child: Column(children: [
                              ListView.separated(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) => MyItemCard(
                                        item: items[index],
                                        token: authProvider.getJwtToken(),
                                      ),
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(height: 10),
                                  itemCount: items.length)
                            ]));
                      } else {
                        return const Center(
                            child: Text('Could not load data from the server'));
                      }
                    })),
          ],
        ));
  }
}
