import 'package:flutter/foundation.dart' hide Category;
import 'package:pet_haven/models/category.dart';
import 'package:pet_haven/models/product.dart';
import 'package:pet_haven/services/product_service.dart';

class ProductController extends ChangeNotifier {
  final ProductService _productService = ProductService();

  List<Product> _products = [];
  List<Category> _categories = []; // New
  bool _isLoading = false;
  bool _isCategoriesLoading = false; // New
  String? _error;

  // Pagination State
  int _currentPage = 1;
  int _lastPage = 1;
  bool _isFetchingMore = false;

  List<Product> get products => _products;
  List<Category> get categories => _categories; // New
  bool get isLoading => _isLoading;
  bool get isCategoriesLoading => _isCategoriesLoading; // New
  bool get isFetchingMore => _isFetchingMore;
  String? get error => _error;
  bool get hasMore => _currentPage < _lastPage;

  ProductController() {
    refresh();
  }

  Future<void> fetchCategories() async {
    _isCategoriesLoading = true;
    notifyListeners();
    try {
      debugPrint('Fetching categories...');
      _categories = await _productService.fetchCategories();
      debugPrint('Fetched ${_categories.length} categories');
    } catch (e) {
      debugPrint("Error fetching categories: $e");
    } finally {
      _isCategoriesLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    // Refresh products and categories
    fetchCategories(); // Fire and forget or await? Let's not await to parallelize a bit if possible, but setState might conflict. Safe to call.

    _isLoading = true;
    _error = null;
    _currentPage = 1;
    // Don't clear products immediately if you want to keep showing something while loading,
    // but typically refresh clears the list or shows indicator. Let's clear for simplicity.
    _products = [];
    notifyListeners();

    try {
      final response = await _productService.fetchProducts(page: 1);
      _products = response.products;
      _lastPage = response.lastPage;
      _currentPage = 1;
    } catch (e) {
      _error = e.toString().contains('Exception:')
          ? e.toString().split('Exception: ')[1]
          : e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchNextPage() async {
    if (_isFetchingMore || _currentPage >= _lastPage) return;

    _isFetchingMore = true;
    notifyListeners();

    try {
      final nextPage = _currentPage + 1;
      final response = await _productService.fetchProducts(page: nextPage);

      _products.addAll(response.products);
      _currentPage = nextPage;
      _lastPage = response.lastPage;
    } catch (e) {
      debugPrint('Failed to load more products: $e');
      // Optionally set error state or use a flash message via other means
    } finally {
      _isFetchingMore = false;
      notifyListeners();
    }
  }
}
