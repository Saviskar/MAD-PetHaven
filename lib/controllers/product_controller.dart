import 'package:flutter/foundation.dart' hide Category;
import 'package:pet_haven/models/category.dart';
import 'package:pet_haven/models/product.dart';
import 'package:pet_haven/services/product_service.dart';
import 'package:pet_haven/services/cache_service.dart';
import 'package:pet_haven/services/connectivity_service.dart';

/// Controller for managing product data with offline support.
///
/// Handles fetching products and categories from API when online,
/// and falls back to cached local JSON data when offline.
class ProductController extends ChangeNotifier {
  final ProductService _productService = ProductService();
  final CacheService _cacheService = CacheService();
  final ConnectivityService _connectivityService = ConnectivityService();

  List<Product> _products = [];
  List<Category> _categories = [];
  List<Product> _promotedProducts = [];

  bool _isLoading = false;
  bool _isCategoriesLoading = false;
  bool _isPromotedLoading = false;
  bool _isOffline = false;
  String? _cacheAge;

  String? _error;

  // Pagination State
  int _currentPage = 1;
  int _lastPage = 1;
  bool _isFetchingMore = false;

  List<Product> get products => _products;
  List<Category> get categories => _categories;
  List<Product> get promotedProducts => _promotedProducts;

  bool get isLoading => _isLoading;
  bool get isCategoriesLoading => _isCategoriesLoading;
  bool get isPromotedLoading => _isPromotedLoading;
  bool get isFetchingMore => _isFetchingMore;
  String? get error => _error;
  bool get hasMore => _currentPage < _lastPage;

  /// Whether data was loaded from cache (offline mode)
  bool get isOffline => _isOffline;

  /// Human-readable cache age (e.g., "5 min ago")
  String? get cacheAge => _cacheAge;

  ProductController() {
    refresh();
  }

  Future<void> fetchCategories() async {
    _isCategoriesLoading = true;
    notifyListeners();

    try {
      final isOnline = await _connectivityService.isOnline();

      if (isOnline) {
        debugPrint('📶 Online: Fetching categories from API...');
        _categories = await _productService.fetchCategories();
        debugPrint('✅ Fetched ${_categories.length} categories from API');

        // Cache the categories for offline use
        await _cacheService.cacheCategories(_categories);
      } else {
        debugPrint('📴 Offline: Loading categories from cache...');
        final cached = await _cacheService.getCachedCategories();
        if (cached != null && cached.isNotEmpty) {
          _categories = cached;
          debugPrint('✅ Loaded ${_categories.length} categories from cache');
        }
      }
    } catch (e) {
      debugPrint("❌ Error fetching categories: $e");
      // Try cache as fallback
      final cached = await _cacheService.getCachedCategories();
      if (cached != null && cached.isNotEmpty) {
        _categories = cached;
        debugPrint(
          '🔄 Fallback: Loaded ${_categories.length} categories from cache',
        );
      }
    } finally {
      _isCategoriesLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchPromotedProducts() async {
    _isPromotedLoading = true;
    notifyListeners();

    try {
      final isOnline = await _connectivityService.isOnline();

      if (isOnline) {
        debugPrint('📶 Online: Fetching promoted products from API...');
        _promotedProducts = await _productService.fetchPromotedProducts();
        debugPrint(
          '✅ Fetched ${_promotedProducts.length} promoted products from API',
        );
      }
      // Note: Promoted products are not cached separately for simplicity
    } catch (e) {
      debugPrint("❌ Error fetching promoted products: $e");
    } finally {
      _isPromotedLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    // Refresh products and categories
    fetchCategories();
    fetchPromotedProducts();

    _isLoading = true;
    _error = null;
    _currentPage = 1;
    _products = [];
    notifyListeners();

    try {
      final isOnline = await _connectivityService.isOnline();

      if (isOnline) {
        _isOffline = false;
        debugPrint('📶 Online: Fetching products from API...');

        final response = await _productService.fetchProducts(page: 1);
        _products = response.products;
        _lastPage = response.lastPage;
        _currentPage = 1;

        debugPrint('✅ Fetched ${_products.length} products from API');

        // Cache the products for offline use
        await _cacheService.cacheProducts(_products);
        _cacheAge = null;
      } else {
        _isOffline = true;
        debugPrint('📴 Offline: Loading products from cache...');

        final cached = await _cacheService.getCachedProducts();
        if (cached != null && cached.isNotEmpty) {
          _products = cached;
          _cacheAge = await _cacheService.getCacheAge('products');
          _lastPage = 1; // No pagination in offline mode
          debugPrint('✅ Loaded ${_products.length} products from cache');
        } else {
          _error = 'No internet connection and no cached data available';
        }
      }
    } catch (e) {
      debugPrint("❌ Error fetching products: $e");

      // Try cache as fallback
      final cached = await _cacheService.getCachedProducts();
      if (cached != null && cached.isNotEmpty) {
        _products = cached;
        _isOffline = true;
        _cacheAge = await _cacheService.getCacheAge('products');
        debugPrint(
          '🔄 Fallback: Loaded ${_products.length} products from cache',
        );
      } else {
        _error = e.toString().contains('Exception:')
            ? e.toString().split('Exception: ')[1]
            : e.toString();
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchNextPage() async {
    if (_isFetchingMore || _currentPage >= _lastPage || _isOffline) return;

    _isFetchingMore = true;
    notifyListeners();

    try {
      final nextPage = _currentPage + 1;
      final response = await _productService.fetchProducts(page: nextPage);

      _products.addAll(response.products);
      _currentPage = nextPage;
      _lastPage = response.lastPage;

      // Update cache with all products
      await _cacheService.cacheProducts(_products);
    } catch (e) {
      debugPrint('Failed to load more products: $e');
    } finally {
      _isFetchingMore = false;
      notifyListeners();
    }
  }
}
