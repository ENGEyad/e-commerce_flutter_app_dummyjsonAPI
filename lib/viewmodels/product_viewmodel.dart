// lib/viewmodels/product_viewmodel.dart
import 'package:flutter/foundation.dart';
import '../models/product_models.dart';

abstract class ProductRepository {
  Future<ProductListResponse> getProducts({int limit = 30, int skip = 0});
  Future<Product> getProductById(int id);
  Future<ProductListResponse> searchProducts(String query);
  Future<List<String>> getCategories();
  Future<ProductListResponse> getProductsByCategory(String category);
}

class ProductViewModel extends ChangeNotifier {
  final ProductRepository repository;
  ProductViewModel(this.repository);

  bool isLoading = false;
  String? errorMessage;
  List<Product> products = [];
  Product? selectedProduct;
  List<String> categories = [];
  int total = 0;
  int skip = 0;
  int limit = 30;

  Future<void> loadInitial() async {
    await Future.wait([loadProducts(), loadCategories()]);
  }

  Future<void> loadProducts({int pageLimit = 30, int pageSkip = 0}) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final res = await repository.getProducts(limit: pageLimit, skip: pageSkip);
      products = res.products;
      total = res.total;
      skip = res.skip;
      limit = res.limit;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      await loadProducts();
      return;
    }
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final res = await repository.searchProducts(query);
      products = res.products;
      total = res.total;
      skip = res.skip;
      limit = res.limit;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadByCategory(String category) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final res = await repository.getProductsByCategory(category);
      products = res.products;
      total = res.total;
      skip = res.skip;
      limit = res.limit;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadProductDetails(int id) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      selectedProduct = await repository.getProductById(id);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadCategories() async {
    try {
      categories = await repository.getCategories();
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
  }
}