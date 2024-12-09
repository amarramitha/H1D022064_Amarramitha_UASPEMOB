class Product {
  final String id;
  final String name;
  final double price;

  Product({
    required this.id,
    required this.name,
    required this.price,
  });

  // Method to create a Product object from a Firestore document
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] ?? '', // Provide a fallback if the value is null
      name: map['name'] ?? '',
      price: map['price'] ?? 0.0,
    );
  }

  // Method to convert a Product object to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
    };
  }
}
