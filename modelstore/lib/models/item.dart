class Item {
  final int productId;
  final String name;
  final String description;
  final int price;
  final String imageUrl;
  final int creatorId;
  final String creatorUsername;
  final String creatorEmail;

  Item(this.productId, this.name, this.description, this.price, this.imageUrl,
      this.creatorId, this.creatorUsername, this.creatorEmail);

  // Для того, чтобы можно было создавать объекты из JSON
  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      json['product_id'],
      json['name'],
      json['description'],
      json['price'],
      json['image_url'],
      json['creator_id'],
      json['username'],
      json['email'],
    );
  }
}
