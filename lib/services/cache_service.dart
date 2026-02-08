import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' hide Category;
import 'package:path_provider/path_provider.dart';
import 'package:pet_haven/models/product.dart';
import 'package:pet_haven/models/category.dart';

/// Service for caching data locally as JSON files.
///
/// Provides methods to save and retrieve products and categories
/// from local storage, with timestamp tracking for cache freshness.
class CacheService {
  static const String _productsFileName = 'cached_products.json';
  static const String _categoriesFileName = 'cached_categories.json';
  static const String _cacheMetaFileName = 'cache_meta.json';

  /// Cache validity duration (1 hour)
  static const Duration cacheValidDuration = Duration(hours: 1);

  /// Get the local cache directory
  Future<Directory> get _cacheDir async {
    final appDir = await getApplicationDocumentsDirectory();
    final cacheDir = Directory('${appDir.path}/cache');
    if (!await cacheDir.exists()) {
      await cacheDir.create(recursive: true);
    }
    return cacheDir;
  }

  /// Save products to local JSON cache
  Future<void> cacheProducts(List<Product> products) async {
    try {
      final dir = await _cacheDir;
      final file = File('${dir.path}/$_productsFileName');

      final List<Map<String, dynamic>> jsonList = products
          .map(
            (p) => {
              'id': p.id,
              'name': p.name,
              'description': p.description,
              'price': p.price,
              'image_url': p.imageUrl,
              'category': {'name': p.category},
              'stock': p.stock,
              'is_promoted': p.isPromoted,
              'discount': p.discount,
            },
          )
          .toList();

      await file.writeAsString(jsonEncode(jsonList));
      await _updateCacheTimestamp('products');

      debugPrint('💾 Cached ${products.length} products to local storage');
    } catch (e) {
      debugPrint('❌ Error caching products: $e');
    }
  }

  /// Get cached products from local JSON file
  Future<List<Product>?> getCachedProducts() async {
    try {
      final dir = await _cacheDir;
      final file = File('${dir.path}/$_productsFileName');

      if (!await file.exists()) {
        debugPrint('📂 No cached products file found');
        return null;
      }

      final contents = await file.readAsString();
      final List<dynamic> jsonList = jsonDecode(contents);
      final products = jsonList.map((json) => Product.fromJson(json)).toList();

      debugPrint('📖 Loaded ${products.length} products from cache');
      return products;
    } catch (e) {
      debugPrint('❌ Error reading cached products: $e');
      return null;
    }
  }

  /// Save categories to local JSON cache
  Future<void> cacheCategories(List<Category> categories) async {
    try {
      final dir = await _cacheDir;
      final file = File('${dir.path}/$_categoriesFileName');

      final List<Map<String, dynamic>> jsonList = categories
          .map((c) => {'id': c.id, 'name': c.name})
          .toList();

      await file.writeAsString(jsonEncode(jsonList));
      await _updateCacheTimestamp('categories');

      debugPrint('💾 Cached ${categories.length} categories to local storage');
    } catch (e) {
      debugPrint('❌ Error caching categories: $e');
    }
  }

  /// Get cached categories from local JSON file
  Future<List<Category>?> getCachedCategories() async {
    try {
      final dir = await _cacheDir;
      final file = File('${dir.path}/$_categoriesFileName');

      if (!await file.exists()) {
        debugPrint('📂 No cached categories file found');
        return null;
      }

      final contents = await file.readAsString();
      final List<dynamic> jsonList = jsonDecode(contents);
      final categories = jsonList
          .map((json) => Category.fromJson(json))
          .toList();

      debugPrint('📖 Loaded ${categories.length} categories from cache');
      return categories;
    } catch (e) {
      debugPrint('❌ Error reading cached categories: $e');
      return null;
    }
  }

  /// Update cache timestamp for a given data type
  Future<void> _updateCacheTimestamp(String dataType) async {
    try {
      final dir = await _cacheDir;
      final file = File('${dir.path}/$_cacheMetaFileName');

      Map<String, dynamic> meta = {};
      if (await file.exists()) {
        final contents = await file.readAsString();
        meta = jsonDecode(contents);
      }

      meta['${dataType}_timestamp'] = DateTime.now().toIso8601String();
      await file.writeAsString(jsonEncode(meta));
    } catch (e) {
      debugPrint('❌ Error updating cache timestamp: $e');
    }
  }

  /// Check if cache is still valid (not expired)
  Future<bool> isCacheValid(String dataType) async {
    try {
      final dir = await _cacheDir;
      final file = File('${dir.path}/$_cacheMetaFileName');

      if (!await file.exists()) {
        return false;
      }

      final contents = await file.readAsString();
      final meta = jsonDecode(contents);
      final timestampStr = meta['${dataType}_timestamp'];

      if (timestampStr == null) {
        return false;
      }

      final timestamp = DateTime.parse(timestampStr);
      final age = DateTime.now().difference(timestamp);

      return age < cacheValidDuration;
    } catch (e) {
      debugPrint('❌ Error checking cache validity: $e');
      return false;
    }
  }

  /// Get cache age as a human-readable string
  Future<String?> getCacheAge(String dataType) async {
    try {
      final dir = await _cacheDir;
      final file = File('${dir.path}/$_cacheMetaFileName');

      if (!await file.exists()) {
        return null;
      }

      final contents = await file.readAsString();
      final meta = jsonDecode(contents);
      final timestampStr = meta['${dataType}_timestamp'];

      if (timestampStr == null) {
        return null;
      }

      final timestamp = DateTime.parse(timestampStr);
      final age = DateTime.now().difference(timestamp);

      if (age.inMinutes < 1) {
        return 'Just now';
      } else if (age.inMinutes < 60) {
        return '${age.inMinutes} min ago';
      } else if (age.inHours < 24) {
        return '${age.inHours} hr ago';
      } else {
        return '${age.inDays} days ago';
      }
    } catch (e) {
      return null;
    }
  }

  /// Clear all cached data
  Future<void> clearCache() async {
    try {
      final dir = await _cacheDir;
      if (await dir.exists()) {
        await dir.delete(recursive: true);
      }
      debugPrint('🗑️ Cache cleared');
    } catch (e) {
      debugPrint('❌ Error clearing cache: $e');
    }
  }
}
