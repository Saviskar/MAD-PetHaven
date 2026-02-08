import 'package:flutter/foundation.dart';
import '../models/wishlist_item.dart';
import '../models/product.dart';
import '../services/database_helper.dart';

class WishlistController extends ChangeNotifier {
  static final WishlistController _instance = WishlistController._();
  factory WishlistController() => _instance;
  WishlistController._();

  List<WishlistItem> _items = [];
  List<WishlistItem> get items => _items;

  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<void> load() async {
    _items = await _dbHelper.readAllWishlistItems();
    notifyListeners();
  }

  Future<void> toggleWishlist(Product product) async {
    final isFav = await _dbHelper.isFavorite(product.id);
    if (isFav) {
      await _dbHelper.delete(product.id);
    } else {
      final item = WishlistItem(
        productId: product.id,
        name: product.name,
        price: product.price,
        imageUrl: product.imageUrl,
        category: product.category,
      );
      await _dbHelper.create(item);
    }
    await load();
  }

  bool isFavorite(int productId) {
    return _items.any((item) => item.productId == productId);
  }
}
