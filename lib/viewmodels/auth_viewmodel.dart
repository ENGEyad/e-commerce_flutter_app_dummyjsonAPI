// lib/viewmodels/auth_viewmodel.dart
import 'package:flutter/foundation.dart';
import '../models/user_models.dart';

abstract class AuthRepository {
  Future<AuthResponse> login({
    required String username,
    required String password,
  });

  Future<User> me(String accessToken);
  Future<AuthResponse> refresh(String refreshToken);
}

class AuthViewModel extends ChangeNotifier {
  final AuthRepository repository;

  AuthViewModel(this.repository);

  bool isLoading = false;
  String? errorMessage;
  AuthResponse? auth;
  User? currentUser;

  Future<void> login(String username, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      auth = await repository.login(username: username, password: password);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadCurrentUser(String token) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      currentUser = await repository.me(token);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshSession(String refreshToken) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      auth = await repository.refresh(refreshToken);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}