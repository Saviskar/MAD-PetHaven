import 'dart:async';
import 'dart:convert';
import 'package:pet_haven/data/cart_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartManager {
  static final CartManager _instance = CartManager._();
  factory CartManager() => _instance;
  CartManager._();

  final List<CartItem> _items = [];
  static const _key = 'cart';

  List<CartItem> get items => List.unmodifiable(_items);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw != null) {
      final List decoded = jsonDecode(raw);
      _items
        ..clear()
        ..addAll(decoded.map((e) => CartItem.fromJson(e)));
    }
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final list = _items.map((e) => e.toJson()).toList();
    final raw = jsonEncode(list);
    await prefs.setString(_key, raw);
  }

  Future<void> add(int productId, {int quantity = 1}) async {
    final index = _items.indexWhere((e) => e.productId == productId);
    if (index == -1) {
      _items.add(CartItem(productId: productId, quantity: quantity));
    } else {
      _items[index].quantity += quantity;
    }
    await _save();
  }

  Future<void> update(int productId, int quantity) async {
    if (quantity <= 0) {
      _items.removeWhere((e) => e.productId == productId);
    } else {
      final index = _items.indexWhere((e) => e.productId == productId);
      if (index != -1) {
        _items[index].quantity = quantity;
      }
    }
    await _save();
  }

  Future<void> clear() async {
    _items.clear();
    await _save();
  }
}
