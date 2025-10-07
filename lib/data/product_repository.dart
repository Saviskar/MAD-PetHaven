import 'product.dart';

class ProductRepository {
  // Singleton Pattern
  ProductRepository._internal();
  static final ProductRepository _instance = ProductRepository._internal();
  factory ProductRepository() => _instance;

  final List<Product> _products = const [
    Product(
      id: 1,
      name: 'Dog Kibble 1kg',
      description:
          'A balanced, high-protein kibble made with real chicken and rice. '
          'Fortified with essential vitamins, minerals, and Omega-3 fatty acids to promote strong muscles, shiny coats, and overall vitality. '
          'Ideal for adult dogs of all breeds.',
      price: 1990.00,
      imageAsset: 'assets/images/dog_food.png',
      category: 'Food',
    ),
    Product(
      id: 2,
      name: 'Cat Toy Mouse',
      description:
          'A soft plush mouse toy designed to stimulate your cat’s natural hunting instincts. '
          'Features a built-in jingle bell that creates sound during play to keep your feline engaged and active. '
          'Perfect for indoor exercise and stress relief.',
      price: 750.00,
      imageAsset: 'assets/images/dog_food.png',
      category: 'Toys',
    ),
    Product(
      id: 4,
      name: 'Fish Tank Cleaner',
      description:
          'Magnetic aquarium glass cleaner designed for tanks up to 12mm thick. '
          'The strong magnet allows you to clean algae without getting your hands wet. '
          'Ergonomic grip ensures easy use and streak-free cleaning.',
      price: 2200.00,
      imageAsset: 'assets/images/dog_food.png',
      category: 'Accessories',
    ),
    Product(
      id: 5,
      name: 'Dog Leash (Nylon)',
      description:
          'A heavy-duty nylon dog leash with a padded handle for extra comfort. '
          'Features a rust-resistant metal clasp and reflective stitching for nighttime walks. '
          '1.5 meters in length, suitable for dogs of all sizes.',
      price: 1200.00,
      imageAsset: 'assets/images/dog_food.png',
      category: 'Accessories',
    ),
    Product(
      id: 6,
      name: 'Cat Scratching Post',
      description:
          'A tall, sturdy scratching post wrapped with natural sisal rope to satisfy your cat’s scratching needs. '
          'Encourages healthy claws while preventing damage to your furniture. '
          'Includes a stable wooden base for extra safety.',
      price: 3200.00,
      imageAsset: 'assets/images/dog_food.png',
      category: 'Toys',
    ),
    Product(
      id: 7,
      name: 'Bird Cage Swing',
      description:
          'A handcrafted wooden swing designed to keep your birds entertained. '
          'Made with natural wood and non-toxic rope, it promotes exercise and reduces boredom. '
          'Ideal for parakeets, cockatiels, and small parrots.',
      price: 850.00,
      imageAsset: 'assets/images/dog_food.png',
      category: 'Accessories',
    ),
    Product(
      id: 8,
      name: 'Aquarium Filter Pump',
      description:
          'An energy-efficient aquarium filter that provides mechanical and biological filtration. '
          'Helps maintain crystal-clear water while being whisper-quiet. '
          'Suitable for aquariums up to 60 liters.',
      price: 3500.00,
      imageAsset: 'assets/images/dog_food.png',
      category: 'Accessories',
    ),
    Product(
      id: 9,
      name: 'Dog Shampoo 250ml',
      description:
          'A gentle oatmeal-based dog shampoo formulated to soothe sensitive skin. '
          'Leaves coats soft, shiny, and smelling fresh with natural lavender extracts. '
          'pH-balanced and safe for regular use.',
      price: 950.00,
      imageAsset: 'assets/images/dog_food.png',
      category: 'Grooming',
    ),
    Product(
      id: 10,
      name: 'Cat Litter 5kg',
      description:
          'Premium clumping cat litter made with activated charcoal for superior odor control. '
          'Dust-free and easy to scoop, keeping your cat’s litter box fresh and hygienic. '
          'Long-lasting and safe for multi-cat households.',
      price: 1850.00,
      imageAsset: 'assets/images/dog_food.png',
      category: 'Accessories',
    ),
    Product(
      id: 11,
      name: 'Parrot Food Mix 1kg',
      description:
          'A nutritious seed and nut blend formulated for parrots. '
          'Includes sunflower seeds, millet, dried fruits, and fortified vitamins. '
          'Supports healthy feathers, energy levels, and beak strength.',
      price: 2100.00,
      imageAsset: 'assets/images/dog_food.png',
      category: 'Food',
    ),
    Product(
      id: 12,
      name: 'Fish Food Flakes 200g',
      description:
          'Balanced fish food flakes enriched with protein and essential nutrients. '
          'Suitable for goldfish, guppies, and most tropical fish. '
          'Floats longer in water to encourage active feeding.',
      price: 600.00,
      imageAsset: 'assets/images/dog_food.png',
      category: 'Food',
    ),
    Product(
      id: 13,
      name: 'Dog Bed (Medium)',
      description:
          'A soft, cushioned dog bed with high-density foam and a removable washable cover. '
          'Designed with raised edges for extra comfort and security. '
          'Ideal for medium-sized breeds such as Beagles and Cocker Spaniels.',
      price: 4800.00,
      imageAsset: 'assets/images/dog_food.png',
      category: 'Accessories',
    ),
    Product(
      id: 14,
      name: 'Cat Carrier Bag',
      description:
          'Lightweight and breathable carrier bag for cats and small pets. '
          'Made with durable mesh panels for ventilation and a padded base for comfort. '
          'Foldable design makes it convenient for travel and storage.',
      price: 4200.00,
      imageAsset: 'assets/images/dog_food.png',
      category: 'Accessories',
    ),
    Product(
      id: 15,
      name: 'Rabbit Hay 2kg',
      description:
          'Fresh timothy hay harvested for maximum nutritional value. '
          'High in fiber to support digestive health and dental care for rabbits, guinea pigs, and chinchillas. '
          'Packed in a resealable bag to preserve freshness.',
      price: 1350.00,
      imageAsset: 'assets/images/dog_food.png',
      category: 'Food',
    ),
  ];

  List<Product> all() => List.unmodifiable(_products);

  Product? byId(int id) {
    for (final product in _products) {
      if (product.id == id) return product;
    }
    return null;
  }
}
