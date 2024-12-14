class Product {
  final int? id;
  final String sku;
  final String name;
  final String description;
  final double price;
  final double discountedPrice;
  final int quantity;
  final String manufacturer;
  final String imageUrl;

  Product({
    this.id,
    required this.sku,
    required this.name,
    required this.description,
    required this.price,
    required this.discountedPrice,
    required this.quantity,
    required this.manufacturer,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sku': sku,
      'name': name,
      'description': description,
      'price': price,
      'discounted_price': discountedPrice,
      'quantity': quantity,
      'manufacturer': manufacturer,
      'image_url': imageUrl,
    };
  }

  static Product fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      sku: map['sku'],
      name: map['name'],
      description: map['description'],
      price: map['price'],
      discountedPrice: map['discounted_price'],
      quantity: map['quantity'],
      manufacturer: map['manufacturer'],
      imageUrl: map['image_url'],
    );
  }

  Product copyWith({
    int? id,
    String? sku,
    String? name,
    String? description,
    double? price,
    double? discountedPrice,
    int? quantity,
    String? manufacturer,
    String? imageUrl,
  }) {
    return Product(
      id: id ?? this.id,
      sku: sku ?? this.sku,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      discountedPrice: discountedPrice ?? this.discountedPrice,
      quantity: quantity ?? this.quantity,
      manufacturer: manufacturer ?? this.manufacturer,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}

