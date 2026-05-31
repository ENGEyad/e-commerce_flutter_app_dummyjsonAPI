import 'package:dio/dio.dart';
import '../models/user_models.dart';
import '../viewmodels/auth_viewmodel.dart';

class AuthRepositoryImpl implements AuthRepository {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://dummyjson.com'));

  @override
  Future<AuthResponse> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'username': username,
        'password': password,
      });

      if (response.statusCode == 200) {
        // Map the JSON response to your AuthResponse model
        return AuthResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to authenticate');
      }
    } catch (e) {
      throw Exception('Login Error: ${e.toString()}');
    }
  }

  @override
  Future<User> me(String accessToken) async {
    try {
      final response = await _dio.get('/auth/me',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );
      return User.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch user profile: $e');
    }
  }

  @override
  Future<AuthResponse> refresh(String refreshToken) async {
    // Implement token refresh logic here if needed
    throw UnimplementedError();
  }
}