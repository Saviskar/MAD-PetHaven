import 'package:dio/dio.dart';
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

  // Keeping this for reference but commenting out to avoid lints with new Product model
  /*
  final List<Product> _products = const [
    Product(
      id: 1,
      name: 'Dog Kibble',
      // ...
    ),
  ];
  */

  // Temporary fallback if needed, but we want to force API usage
  List<Product> all() => [];

  Product? byId(int id) {
    // For now returning null or implementation needs to fetch from API or cache
    return null;
  }
}

class ProductPaginatedResponse {
  final List<Product> products;
  final int lastPage;

  ProductPaginatedResponse({required this.products, required this.lastPage});
}
