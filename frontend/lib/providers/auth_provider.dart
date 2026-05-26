import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
 
class AuthProvider extends ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;
  String? _error;
 
  // ✅ NUEVO: Mientras false, la app no redirige a /login prematuramente.
  // Cambia a true cuando termina de verificar si hay sesión guardada.
  bool _sessionChecked = false;
 
  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;
  bool get sessionChecked => _sessionChecked;
 
  final AuthService _authService = AuthService();
 
  AuthProvider() {
    // ✅ NUEVO: Intenta restaurar sesión al arrancar.
    // GoRouter re-evalúa el redirect cuando sessionChecked cambia a true.
    _restoreSession();
  }
 
  Future<void> _restoreSession() async {
    try {
      final data = await _authService.tryRestoreSession();
      if (data != null) {
        _user = UserModel.fromJson(data['user']);
      }
    } catch (_) {
      _user = null;
    } finally {
      _sessionChecked = true;
      notifyListeners();
    }
  }
 
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
 
    try {
      final data = await _authService.login(email, password);
 
      if (data['user'] == null || data['access_token'] == null) {
        _error = "Respuesta inválida del servidor";
        _isLoading = false;
        notifyListeners();
        return false;
      }
 
      _user = UserModel.fromJson(data['user']);
      _isLoading = false;
      notifyListeners(); // GoRouter detecta isAuthenticated = true → /home
      return true;
    } catch (e) {
      _error = "Credenciales inválidas o error de conexión";
      _user = null;
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
 
  Future<void> logout() async {
    await _authService.logout();
    _user = null;
    notifyListeners(); // GoRouter detecta isAuthenticated = false → /login
  }
 
  void clearError() {
    _error = null;
    notifyListeners();
  }
}