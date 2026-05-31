// lib/repositories/cart_repository_impl.dart
import '../models/cart_models.dart';
import '../services/api_client.dart';
import '../viewmodels/cart_viewmodel.dart';

class CartRepositoryImpl implements CartRepository {
  final ApiClient apiClient;
  CartRepositoryImpl(this.apiClient);

  @override
  Future<CartListResponse> getCarts() async {
    final res = await apiClient.dio.get('/carts');
    return CartListResponse.fromJson(res.data);
  }

  @override
  Future<Cart> getCartById(int id) async {
    final res = await apiClient.dio.get('/carts/$id');
    return Cart.fromJson(res.data);
  }

  @override
  Future<CartListResponse> getUserCarts(int userId) async {
    final res = await apiClient.dio.get('/carts/user/$userId');
    return CartListResponse.fromJson(res.data);
  }

  @override
  Future<Cart> addCart({
    required int userId,
    required List<Map<String, int>> products,
  }) async {
    final res = await apiClient.dio.post('/carts/add', data: {
      'userId': userId,
      'products': products,
    });
    return Cart.fromJson(res.data);
  }

  @override
  Future<Cart> updateCart(
      int id, {
        required List<Map<String, int>> products,
        bool merge = false,
      }) async {
    final res = await apiClient.dio.put('/carts/$id', data: {
      'merge': merge,
      'products': products,
    });
    return Cart.fromJson(res.data);
  }

  @override
  Future<void> deleteCart(int id) async {
    await apiClient.dio.delete('/carts/$id');
  }
}