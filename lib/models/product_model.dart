class Product {
  final int id;
  final String title;
  final String description;
  final String category;
  final String brand;
  final String thumbnail;
  final double price;
  final double rating;
  final int stock;

  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.brand,
    required this.thumbnail,
    required this.price,
    required this.rating,
    required this.stock,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title']?.toString() ?? 'Untitled',
      description: json['description']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      brand: json['brand']?.toString() ?? 'Generic',
      thumbnail: json['thumbnail']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      stock: (json['stock'] as num?)?.toInt() ?? 0,
    );
  }
}
