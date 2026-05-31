// lib/repositories/product_repository_impl.dart
import 'package:dio/dio.dart';
import '../models/product_models.dart';
import '../services/api_client.dart';
import '../viewmodels/product_viewmodel.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ApiClient apiClient;
  ProductRepositoryImpl(this.apiClient);

  @override
  Future<ProductListResponse> getProducts({int limit = 30, int skip = 0}) async {
    final res = await apiClient.dio.get('/products', queryParameters: {
      'limit': limit,
      'skip': skip,
    });
    return ProductListResponse.fromJson(res.data);
  }

  @override
  Future<Product> getProductById(int id) async {
    final res = await apiClient.dio.get('/products/$id');
    return Product.fromJson(res.data);
  }

  @override
  Future<ProductListResponse> searchProducts(String query) async {
    final res = await apiClient.dio.get('/products/search', queryParameters: {
      'q': query,
    });
    return ProductListResponse.fromJson(res.data);
  }

  @override
  Future<List<String>> getCategories() async {
    final res = await apiClient.dio.get('/products/category-list');
    return List<String>.from(res.data ?? []);
  }

  @override
  Future<ProductListResponse> getProductsByCategory(String category) async {
    final res = await apiClient.dio.get('/products/category/$category');
    return ProductListResponse.fromJson(res.data);
  }
}