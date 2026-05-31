// lib/services/api_client.dart
import 'package:dio/dio.dart';

class ApiClient {
  final Dio dio;
  String? _accessToken;
  String? _refreshToken;

  // Callback to refresh token – will be set by AuthRepositoryImpl
  Future<String?> Function(String refreshToken)? onTokenRefresh;

  ApiClient({String baseUrl = 'https://dummyjson.com'})
      : dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      headers: {'Content-Type': 'application/json'},
    ),
  ) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (_accessToken != null && _accessToken!.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $_accessToken';
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          // If 401 and we have a refresh token, try to refresh
          if (error.response?.statusCode == 401 &&
              _refreshToken != null &&
              onTokenRefresh != null) {
            try {
              final newToken = await onTokenRefresh!(_refreshToken!);
              if (newToken != null && newToken.isNotEmpty) {
                _accessToken = newToken;
                // Retry the failed request with new token
                final requestOptions = error.requestOptions;
                requestOptions.headers['Authorization'] = 'Bearer $_accessToken';
                final response = await dio.fetch(requestOptions);
                return handler.resolve(response);
              }
            } catch (e) {
              // Refresh failed – clear tokens and force logout
              clearTokens();
            }
          }
          return handler.next(error);
        },
      ),
    );
  }

  void setTokens(String accessToken, String refreshToken) {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
  }

  void clearTokens() {
    _accessToken = null;
    _refreshToken = null;
  }

  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;
}