import 'package:flutter/material.dart';
import 'package:lms_app/components/item_card.dart';
import 'package:lms_app/item_model.dart';

class HomeScreen extends StatelessWidget {
  final Item item = Item(
    id: '1',
    title: 'The Great Gatsby',
    description:
        'The Great Gatsby is a 1925 novel by American writer F. Scott Fitzgerald. Set in the Jazz Age on Long Island, the novel depicts narrator Nick Carraway\'s interactions with mysterious millionaire Jay Gatsby and Gatsby\'s obsession to reunite with his former lover, Daisy Buchanan.',
    author: 'F. Scott Fitzgerald',
  );

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          leading: const Icon(Icons.menu),
          title: const Text('Library MS'),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              tooltip: 'Search',
              onPressed: () {
                // handle the press
              },
            ),
          ],
          elevation: 5,
          backgroundColor: const Color.fromARGB(255, 31, 80, 104),
        ),
        body: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Search',
                  prefixIcon: Icon(Icons.search),
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
                child: ListView.separated(
                    itemBuilder: (context, index) => buildItemCard(item),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemCount: 2))
          ],
        ));
  }
}
