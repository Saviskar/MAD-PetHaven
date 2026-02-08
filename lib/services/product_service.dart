import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:pet_haven/models/category.dart';
import 'package:pet_haven/models/product.dart';
import 'package:pet_haven/services/api_service.dart';

class ProductService {
  final ApiService _apiService = ApiService();

  // Singleton Pattern
  ProductService._internal();
  static final ProductService _instance = ProductService._internal();
  factory ProductService() => _instance;

  Future<ProductPaginatedResponse> fetchProducts({int page = 1}) async {
    try {
      final response = await _apiService.dio.get('/api/products?page=$page');

      if (response.statusCode == 200) {
        final data = response.data;
        List<dynamic> productList = [];
        int lastPage = 1;

        if (data is Map<String, dynamic>) {
          if (data.containsKey('data') && data['data'] is List) {
            productList = data['data'];
          }
          if (data.containsKey('last_page') && data['last_page'] is int) {
            lastPage = data['last_page'];
          }
        } else if (data is List) {
          productList = data;
        }

        final products = productList
            .map((json) => Product.fromJson(json))
            .toList();
        return ProductPaginatedResponse(products: products, lastPage: lastPage);
      }
      return ProductPaginatedResponse(products: [], lastPage: 1);
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Failed to load products');
    }
  }

  Future<Product?> fetchProductById(int id) async {
    try {
      final response = await _apiService.dio.get('/api/products/$id');
      if (response.statusCode == 200) {
        // Depending on API, it might be wrapped in 'data'
        final data = response.data;
        if (data is Map<String, dynamic>) {
          if (data.containsKey('data')) {
            return Product.fromJson(data['data']);
          }
          return Product.fromJson(data);
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<List<Category>> fetchCategories() async {
    try {
      final response = await _apiService.dio.get('/api/categories');
      debugPrint(
        'Categories API Response: ${response.statusCode} ${response.data}',
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is List) {
          return data
              .map((e) => Category.fromJson(e as Map<String, dynamic>))
              .toList();
        } else if (data is Map<String, dynamic> &&
            data.containsKey('data') &&
            data['data'] is List) {
          return (data['data'] as List)
              .map((e) => Category.fromJson(e as Map<String, dynamic>))
              .toList();
        }
      }
      return [];
    } catch (e) {
      debugPrint('ProductService fetchCategories error: $e');
      return [];
    }
  }

  Future<List<Product>> fetchPromotedProducts() async {
    try {
      final response = await _apiService.dio.get('/api/products/offers');

      if (response.statusCode == 200) {
        final data = response.data;
        List<dynamic> productList = [];

        if (data is Map<String, dynamic>) {
          if (data.containsKey('data') && data['data'] is List) {
            productList = data['data'];
          } else if (data.containsKey('products') && data['products'] is List) {
            productList = data['products'];
          }
        } else if (data is List) {
          productList = data;
        }

        return productList.map((json) => Product.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      debugPrint('ProductService fetchPromotedProducts error: $e');
      return [];
    }
  }
}

class ProductPaginatedResponse {
  final List<Product> products;
  final int lastPage;

  ProductPaginatedResponse({required this.products, required this.lastPage});
}
