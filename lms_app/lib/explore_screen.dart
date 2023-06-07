import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lms_app/constants.dart';
import 'components/item_card.dart';
import 'components/my_appbar.dart';
import 'components/navigation_drawer.dart';
import 'item_model.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  var searchController = TextEditingController();
  Future<List<Item>> itemsFuture = getItems();

  static Future<List<Item>> getItems() async {
    const url = '$baseUrl/api/guest/allItems';
    final response = await http.get(Uri.parse(url));
    final body = json.decode(response.body);
    print(response.body);
    return body.map<Item>(Item.fromJson).toList();
  }

  Future<List<Item>> searchItems() async {
    const url = '$baseUrl/api/guest/search';
    final body1 = {
      'title': searchController.text,
      'author': searchController.text,
    };
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode(body1),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    final body = json.decode(response.body);
    return body.map<Item>(Item.fromJson).toList();
  }

  Future<void> refresh() async {
    setState(() {
      if (searchController.text == '') {
        itemsFuture = getItems();
      } else {
        itemsFuture = searchItems();
      }
    });
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
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                  // focusedBorder: OutlineInputBorder(
                  //   borderRadius: BorderRadius.all(Radius.circular(50)),
                  //   borderSide: BorderSide(color: Colors.black, width: 2),
                  // ),
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search),
                  fillColor: Colors.white,
                  filled: true,
                ),
                onChanged: (String value) {
                  setState(() {
                    print('valuee iss $value');
                    itemsFuture = searchItems();
                  });
                },
              ),
            ),
            const SizedBox(height: 10),
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
                                  itemBuilder: (context, index) =>
                                      buildItemCard(items[index]),
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(height: 10),
                                  itemCount: items.length)
                            ]));
                      } else {
                        return const Center(
                            child: Text('Could not load data from the server'));
                      }
                    }))
          ],
        ));
  }
}
