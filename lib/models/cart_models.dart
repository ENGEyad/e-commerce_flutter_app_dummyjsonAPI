// lib/models/cart_models.dart

class CartListResponse {
  final List<Cart> carts;
  final int total;
  final int skip;
  final int limit;

  CartListResponse({
    required this.carts,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory CartListResponse.fromJson(Map<String, dynamic> json) {
    return CartListResponse(
      carts: (json['carts'] as List<dynamic>? ?? [])
          .map((e) => Cart.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] ?? 0,
      skip: json['skip'] ?? 0,
      limit: json['limit'] ?? 0,
    );
  }
}

class Cart {
  final int id;
  final List<CartItem> products;
  final double total;
  final double discountedTotal;
  final int userId;
  final int totalProducts;
  final int totalQuantity;

  Cart({
    required this.id,
    required this.products,
    required this.total,
    required this.discountedTotal,
    required this.userId,
    required this.totalProducts,
    required this.totalQuantity,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'] ?? 0,
      products: (json['products'] as List<dynamic>? ?? [])
          .map((e) => CartItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] ?? 0).toDouble(),
      discountedTotal: (json['discountedTotal'] ?? 0).toDouble(),
      userId: json['userId'] ?? 0,
      totalProducts: json['totalProducts'] ?? 0,
      totalQuantity: json['totalQuantity'] ?? 0,
    );
  }
}

class CartItem {
  final int id;
  final String title;
  final double price;
  final int quantity;
  final double total;
  final double discountPercentage;
  final double discountedTotal;
  final String thumbnail;

  CartItem({
    required this.id,
    required this.title,
    required this.price,
    required this.quantity,
    required this.total,
    required this.discountPercentage,
    required this.discountedTotal,
    required this.thumbnail,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 0,
      total: (json['total'] ?? 0).toDouble(),
      discountPercentage: (json['discountPercentage'] ?? 0).toDouble(),
      discountedTotal: (json['discountedTotal'] ?? 0).toDouble(),
      thumbnail: json['thumbnail'] ?? '',
    );
  }
}