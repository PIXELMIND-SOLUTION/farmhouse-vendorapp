import 'package:farmhouse_vendor/helper/shared_preference.dart';
import 'package:farmhouse_vendor/model/vendor_model.dart';
import 'package:farmhouse_vendor/services/auth/login_service.dart';
import 'package:flutter/foundation.dart';

enum AuthState { initial, loading, authenticated, unauthenticated, error }

class VendorProvider extends ChangeNotifier {
  AuthState _authState = AuthState.initial;
  VendorModel? _vendor;
  FarmhouseModel? _farmhouse;
  String? _errorMessage;

  // ─── Getters ──────────────────────────────────────────────────────────────────

  AuthState get authState => _authState;
  VendorModel? get vendor => _vendor;
  FarmhouseModel? get farmhouse => _farmhouse;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _authState == AuthState.loading;
  bool get isAuthenticated => _authState == AuthState.authenticated;

  // ─── Login ────────────────────────────────────────────────────────────────────

  Future<bool> login(String name, String password) async {
    _setLoading();

    try {
      final response = await VendorService.instance.login(
        name: name,
        password: password,
      );

      _vendor = response.vendor;
      _farmhouse = response.farmhouse;
      _errorMessage = null;
      _authState = AuthState.authenticated;

      await SharedPrefHelper.saveLoginData(response);

      notifyListeners();
      return true;
    } on ServiceException catch (e) {
      _errorMessage = e.message;
      _authState = AuthState.error;
      notifyListeners();
      return false;
    } catch (e, stackTrace) {
      debugPrint('❌ LOGIN ERROR: $e');
      debugPrint('📍 STACK TRACE: $stackTrace');
      _errorMessage = e.toString();
      _authState = AuthState.error;
      notifyListeners();
      return false;
    }
  }

  // ─── Restore Session ──────────────────────────────────────────────────────────

  Future<void> restoreSession() async {
    _setLoading();

    final loggedIn = await SharedPrefHelper.isLoggedIn();
    if (!loggedIn) {
      _authState = AuthState.unauthenticated;
      notifyListeners();
      return;
    }

    _vendor = await SharedPrefHelper.getVendor();
    _farmhouse = await SharedPrefHelper.getFarmhouse();

    if (_vendor != null && _farmhouse != null) {
      _authState = AuthState.authenticated;
    } else {
      _authState = AuthState.unauthenticated;
    }

    notifyListeners();
  }

  // ─── Logout ───────────────────────────────────────────────────────────────────

  Future<void> logout() async {
    await SharedPrefHelper.clearAll();
    _vendor = null;
    _farmhouse = null;
    _errorMessage = null;
    _authState = AuthState.unauthenticated;
    notifyListeners();
  }

  // ─── Clear Error ──────────────────────────────────────────────────────────────

  void clearError() {
    _errorMessage = null;
    if (_authState == AuthState.error) {
      _authState = AuthState.unauthenticated;
    }
    notifyListeners();
  }

  // ─── Private Helpers ──────────────────────────────────────────────────────────

  void _setLoading() {
    _authState = AuthState.loading;
    _errorMessage = null;
    notifyListeners();
  }
}
