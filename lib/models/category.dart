class Category {
  final int id;
  final String name;
  final String? imageUrl;

  const Category({required this.id, required this.name, this.imageUrl});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] is int
          ? json['id']
          : (int.tryParse(json['id']?.toString() ?? '0') ?? 0),
      name: json['name']?.toString() ?? 'Unknown',
      imageUrl: json['image_url']?.toString(),
    );
  }
}
