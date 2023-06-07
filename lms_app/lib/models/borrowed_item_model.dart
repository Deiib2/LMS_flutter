class BorrowedItem {
  String id;
  String itemId;
  String readerId;
  String returnDate;
  String extensionDate;
  bool extensionRequest;

  BorrowedItem({
    required this.id,
    required this.itemId,
    required this.readerId,
    required this.returnDate,
    required this.extensionDate,
    required this.extensionRequest,
  });

  static BorrowedItem fromJson(json) => BorrowedItem(
        id: json['_id'],
        itemId: json['itemId'],
        readerId: json['readerId'],
        returnDate: json['returnDate'],
        extensionDate: json['extensionDate'],
        extensionRequest: json['extensionRequest'],
      );
}
