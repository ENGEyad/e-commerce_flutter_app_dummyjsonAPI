import 'package:flutter/cupertino.dart';

abstract class BaseViewModel extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  @protected
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  @protected
  void setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  @protected
  Future<void> runAsync(Future<void> Function() action) async {
    setLoading(true);
    setError(null);
    try {
      await action();
    } catch (e) {
      setError(_mapError(e));
    } finally {
      setLoading(false);
    }
  }

  String _mapError(dynamic e) {
    return e.toString().replaceAll("Exception: ", "");
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}