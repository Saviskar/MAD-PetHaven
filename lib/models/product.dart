import 'package:pet_haven/services/api_service.dart';

class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final int stock;
  final List<String>?
  colors; // These might not be in API yet, keeping as nullable
  final List<String>?
  quantities; // These might not be in API yet, keeping as nullable

  // Helper to get a valid image provider (network or asset)
  // For now, we'll just expose the URL. UI can handle the NetworkImage logic.

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.stock,
    this.colors,
    this.quantities,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      imageUrl: (json['image_url'] != null)
          ? (json['image_url'].toString().startsWith('http')
                ? json['image_url']
                : '${ApiService.baseUrl}${json['image_url']}')
          : '',
      category: json['category'] is Map ? json['category']['name'] : 'Unknown',
      stock: json['stock'] is int
          ? json['stock']
          : int.tryParse(json['stock'].toString()) ?? 0,
    );
  }
}
