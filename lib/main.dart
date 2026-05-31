// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:dio/dio.dart';

import 'core/theme/app_colors.dart';

// ViewModels
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/product_viewmodel.dart';
import 'viewmodels/cart_viewmodel.dart';

// Models
import 'models/user_models.dart';
import 'models/product_models.dart';
import 'models/cart_models.dart';

// Screens
import 'views/login_screen.dart';
import 'views/product_list_screen.dart';
import 'views/product_detail_screen.dart';
import 'views/cart_screen.dart';
import 'views/profile_screen.dart';

// ==========================================
// REAL NETWORK IMPLEMENTATIONS (Dio + DummyJSON)
// ==========================================

class RealAuthRepository implements AuthRepository {
  final Dio _dio;
  RealAuthRepository(this._dio);

  @override
  Future<AuthResponse> login({required String username, required String password}) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'username': username,
        'password': password,
      });
      return AuthResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Login Failed: ${e.toString()}');
    }
  }

  @override
  Future<User> me(String accessToken) async {
    try {
      final response = await _dio.get(
        '/auth/me',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );
      return User.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load profile: ${e.toString()}');
    }
  }

  @override
  Future<AuthResponse> refresh(String refreshToken) async {
    try {
      final response = await _dio.post('/auth/refresh', data: {
        'refreshToken': refreshToken,
      });
      return AuthResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Token refresh failed');
    }
  }
}

class RealProductRepository implements ProductRepository {
  final Dio _dio;
  RealProductRepository(this._dio);

  @override
  Future<ProductListResponse> getProducts({int limit = 30, int skip = 0}) async {
    try {
      final response = await _dio.get('/products', queryParameters: {
        'limit': limit,
        'skip': skip,
      });
      return ProductListResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load products');
    }
  }

  @override
  Future<Product> getProductById(int id) async {
    try {
      final response = await _dio.get('/products/$id');
      return Product.fromJson(response.data);
    } catch (e) {
      throw Exception('Product detail error');
    }
  }

  @override
  Future<ProductListResponse> searchProducts(String query) async {
    try {
      final response = await _dio.get('/products/search', queryParameters: {'q': query});
      return ProductListResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Search failed');
    }
  }

  @override
  Future<List<String>> getCategories() async {
    try {
      final response = await _dio.get('/products/categories');
      if (response.data is List) {
        // DummyJSON sometimes returns a list of category objects or strings depending on API version
        return (response.data as List).map((c) => c is Map ? c['slug'].toString() : c.toString()).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to load categories');
    }
  }

  @override
  Future<ProductListResponse> getProductsByCategory(String category) async {
    try {
      final response = await _dio.get('/products/category/$category');
      return ProductListResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to filter by category');
    }
  }
}

class RealCartRepository implements CartRepository {
  final Dio _dio;
  RealCartRepository(this._dio);

  @override
  Future<CartListResponse> getCarts() async {
    try {
      final response = await _dio.get('/carts');
      return CartListResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load carts');
    }
  }

  @override
  Future<Cart> getCartById(int id) async {
    try {
      final response = await _dio.get('/carts/$id');
      return Cart.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch cart');
    }
  }

  @override
  Future<CartListResponse> getUserCarts(int userId) async {
    try {
      final response = await _dio.get('/carts/user/$userId');
      return CartListResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load your cart');
    }
  }

  @override
  Future<Cart> addCart({required int userId, required List<Map<String, int>> products}) async {
    try {
      final response = await _dio.post('/carts/add', data: {
        'userId': userId,
        'products': products,
      });
      return Cart.fromJson(response.data);
    } catch (e) {
      throw Exception('Could not add item to cart');
    }
  }

  @override
  Future<Cart> updateCart(int id, {required List<Map<String, int>> products, bool merge = true}) async {
    try {
      final response = await _dio.put('/carts/$id', data: {
        'merge': merge,
        'products': products,
      });
      return Cart.fromJson(response.data);
    } catch (e) {
      throw Exception('Could not modify cart contents');
    }
  }

  @override
  Future<void> deleteCart(int id) async {
    try {
      await _dio.delete('/carts/$id');
    } catch (e) {
      throw Exception('Failed to remove cart');
    }
  }
}

// ==========================================
// APP INITIALIZATION ENTRYPOINT
// ==========================================

void main() {
  // Initialize shared network client configuration
  final dioClient = Dio(BaseOptions(
    baseUrl: 'https://dummyjson.com',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel(RealAuthRepository(dioClient))),
        ChangeNotifierProvider(create: (_) => ProductViewModel(RealProductRepository(dioClient))),
        ChangeNotifierProvider(create: (_) => CartViewModel(RealCartRepository(dioClient))),
      ],
      child: const ECommerceApp(),
    ),
  );
}

class ECommerceApp extends StatefulWidget {
  const ECommerceApp({super.key});

  @override
  State<ECommerceApp> createState() => _ECommerceAppState();
}

class _ECommerceAppState extends State<ECommerceApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();

    _router = GoRouter(
      initialLocation: '/login',
      redirect: (context, state) {
        final authVm = context.read<AuthViewModel>();
        final isLoggedIn = authVm.currentUser != null;
        final isLoggingIn = state.matchedLocation == '/login';

        if (!isLoggedIn && !isLoggingIn) return '/login';
        if (isLoggedIn && isLoggingIn) return '/products';
        return null;
      },
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/products',
          builder: (context, state) => const ProductListScreen(),
          routes: [
            GoRoute(
              path: 'product/:id',
              builder: (context, state) {
                final id = int.parse(state.pathParameters['id']!);
                return ProductDetailScreen(productId: id);
              },
            ),
          ],
        ),
        GoRoute(
          path: '/cart',
          builder: (context, state) => const CartScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Shop With EYAD',
      theme: AppColors.lightTheme,
      darkTheme: AppColors.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}