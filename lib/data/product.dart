class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final String imageAsset;
  final String category;
  final List<String>? colors;
  final List<String>? quantities;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageAsset,
    required this.category,
    this.colors,
    this.quantities,
  });
}
