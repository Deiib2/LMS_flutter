class Item {
  String id;
  String title;
  String description;
  String author;

  Item({
    required this.id,
    required this.title,
    required this.description,
    required this.author,
  });

  static Item fromJson(json) => Item(
        id: json['_id'],
        title: json['title'],
        description: json['description'],
        author: json['author'],
      );
}
