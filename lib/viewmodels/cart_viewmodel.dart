// lib/viewmodels/cart_viewmodel.dart
import 'package:flutter/foundation.dart';
import '../models/cart_models.dart';
import '../models/product_models.dart';

abstract class CartRepository {
  Future<CartListResponse> getCarts();
  Future<Cart> getCartById(int id);
  Future<CartListResponse> getUserCarts(int userId);
  Future<Cart> addCart({required int userId, required List<Map<String, int>> products});
  Future<Cart> updateCart(int id, {required List<Map<String, int>> products, bool merge});
  Future<void> deleteCart(int id);
}

class CartViewModel extends ChangeNotifier {
  final CartRepository repository;
  CartViewModel(this.repository);

  bool isLoading = false;
  String? errorMessage;
  List<Cart> carts = [];
  Cart? selectedCart;

  Future<void> loadCarts() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final res = await repository.getCarts();
      carts = res.carts;
      if (carts.isNotEmpty && selectedCart == null) {
        selectedCart = carts.first;
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadCart(int id) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      selectedCart = await repository.getCartById(id);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadUserCarts(int userId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final res = await repository.getUserCarts(userId);
      carts = res.carts;
      if (carts.isNotEmpty) {
        selectedCart = carts.first;
      } else if (selectedCart == null) {
        selectedCart = Cart(
          id: 1,
          products: [],
          total: 0.0,
          discountedTotal: 0.0,
          userId: userId,
          totalProducts: 0,
          totalQuantity: 0,
        );
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addItems(int userId, List<Map<String, int>> items) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      selectedCart = await repository.addCart(userId: userId, products: items);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ==========================================
  // LOCAL-FIRST CART MUTATION (Robust & Offline Support)
  // ==========================================

  void addToCart(Product product, {int quantity = 1}) {
    if (selectedCart == null) {
      selectedCart = Cart(
        id: 1,
        products: [],
        total: 0.0,
        discountedTotal: 0.0,
        userId: 1,
        totalProducts: 0,
        totalQuantity: 0,
      );
    }

    final currentProducts = List<CartItem>.from(selectedCart!.products);
    final existingIndex = currentProducts.indexWhere((p) => p.id == product.id);

    if (existingIndex >= 0) {
      final existingItem = currentProducts[existingIndex];
      final newQty = existingItem.quantity + quantity;
      final newTotal = newQty * product.price;
      currentProducts[existingIndex] = CartItem(
        id: product.id,
        title: product.title,
        price: product.price,
        quantity: newQty,
        total: newTotal,
        discountPercentage: product.discountPercentage,
        discountedTotal: newQty * product.discountedPrice,
        thumbnail: product.thumbnail,
      );
    } else {
      currentProducts.add(CartItem(
        id: product.id,
        title: product.title,
        price: product.price,
        quantity: quantity,
        total: quantity * product.price,
        discountPercentage: product.discountPercentage,
        discountedTotal: quantity * product.discountedPrice,
        thumbnail: product.thumbnail,
      ));
    }

    _recalculateCart(currentProducts);
  }

  void updateQuantity(int productId, int quantity) {
    if (selectedCart == null) return;
    if (quantity <= 0) {
      removeFromCart(productId);
      return;
    }

    final currentProducts = List<CartItem>.from(selectedCart!.products);
    final index = currentProducts.indexWhere((p) => p.id == productId);
    if (index >= 0) {
      final item = currentProducts[index];
      currentProducts[index] = CartItem(
        id: item.id,
        title: item.title,
        price: item.price,
        quantity: quantity,
        total: quantity * item.price,
        discountPercentage: item.discountPercentage,
        discountedTotal: quantity * (item.price * (1 - item.discountPercentage / 100)),
        thumbnail: item.thumbnail,
      );
      _recalculateCart(currentProducts);
    }
  }

  void removeFromCart(int productId) {
    if (selectedCart == null) return;
    final currentProducts = List<CartItem>.from(selectedCart!.products);
    currentProducts.removeWhere((p) => p.id == productId);
    _recalculateCart(currentProducts);
  }

  void clearCart() {
    if (selectedCart == null) return;
    _recalculateCart([]);
  }

  void _recalculateCart(List<CartItem> products) {
    if (selectedCart == null) return;

    double total = 0.0;
    double discountedTotal = 0.0;
    int totalQuantity = 0;

    for (final item in products) {
      total += item.total;
      discountedTotal += item.discountedTotal;
      totalQuantity += item.quantity;
    }

    selectedCart = Cart(
      id: selectedCart!.id,
      products: products,
      total: total,
      discountedTotal: discountedTotal,
      userId: selectedCart!.userId,
      totalProducts: products.length,
      totalQuantity: totalQuantity,
    );
    notifyListeners();
  }
}