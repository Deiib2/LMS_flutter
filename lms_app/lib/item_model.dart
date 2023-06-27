class Item {
  String id;
  String title;
  String? imageUrl;
  String description;
  String author;

  Item({
    required this.id,
    required this.title,
    this.imageUrl,
    required this.description,
    required this.author,
  });

  static Item fromJson(json) => Item(
        id: json['_id'],
        title: json['title'],
        imageUrl: json['imageUrl'],
        description: json['description'],
        author: json['author'],
      );
}
