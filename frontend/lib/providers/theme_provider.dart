import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/local_storage_service.dart';
import 'package:flutter/material.dart';
import '../models/theme_model.dart';
import '../services/theme_service.dart';

class ThemeProvider extends ChangeNotifier {
  final ThemeService _themeService = ThemeService();
  
  List<ThemeModel> _themes = [];
  bool _isLoading = false;
  String? _error;

  List<ThemeModel> get themes => _themes;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchThemes() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Cargar caché local inmediatamente para velocidad
      final localThemes = LocalStorageService.getThemes();
      if (localThemes.isNotEmpty) {
        _themes = localThemes.map((json) => ThemeModel.fromJson(json)).toList();
        notifyListeners();
      }

      // Intentar actualizar desde API si hay conexión
      _themes = await _themeService.getThemes();
      await LocalStorageService.saveThemes(_themes.map((t) => t.toJson()).toList());
    } catch (e) {
      if (_themes.isEmpty) {
        _error = "Sin conexión y sin datos locales";
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createTheme(String nombre, String descripcion, int idCategoria) async {
    final data = {
      'nombre': nombre,
      'descripcion': descripcion,
      'id_categoria': idCategoria,
    };

    try {
      final newTheme = await _themeService.createTheme(data);
      _themes.insert(0, newTheme);
      await LocalStorageService.saveThemes(_themes.map((t) => t.toJson()).toList());
      notifyListeners();
      return true;
    } catch (e) {
      // Offline fallback: Guardar acción para sincronizar después
      await LocalStorageService.addToSyncQueue({
        'action': 'create_theme',
        'data': data,
        'timestamp': DateTime.now().toIso8601String(),
      });
      return true; // Mentira piadosa UX: Decimos que OK y sincronizamos luego
    }
  }

  Future<bool> deleteTheme(int id) async {
    try {
      await _themeService.deleteTheme(id);
      _themes.removeWhere((t) => t.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }
}
