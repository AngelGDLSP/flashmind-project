import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import '../core/api_constants.dart';
 
class AuthService {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: ApiConstants.baseUrl),
  );
 
  // ✅ FIX: flutter_secure_storage en lugar de SharedPreferences.
  // SharedPreferences guarda en texto plano — cualquier app con acceso
  // al dispositivo puede leer el JWT. Secure storage lo cifra.
  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'jwt_token';
 
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post(
        ApiConstants.login,
        data: {
          'email': email,
          'password': password,
        },
      );
 
      if (response.statusCode == 200) {
        final token = response.data['access_token'];
 
        // ✅ FIX: Guardado seguro del token
        await _storage.write(key: _tokenKey, value: token);
 
        return response.data;
      }
 
      throw Exception('Error en el login');
    } catch (e) {
      rethrow;
    }
  }
 
  Future<void> register(String nombre, String email, String password) async {
    try {
      await _dio.post(
        ApiConstants.register,
        data: {
          'nombre': nombre,
          'email': email,
          'password': password,
        },
      );
    } catch (e) {
      rethrow;
    }
  }
 
  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }
 
  Future<void> logout() async {
    await _storage.delete(key: _tokenKey);
  }
 
  // ✅ NUEVO: Verifica si hay sesión activa al arrancar la app.
  // AuthProvider llama esto en su constructor para restaurar
  // el usuario sin pedirle que haga login de nuevo.
  Future<Map<String, dynamic>?> tryRestoreSession() async {
    try {
      final token = await _storage.read(key: _tokenKey);
      if (token == null) return null;
 
      final response = await _dio.get(
        ApiConstants.me, // '/api/auth/me'
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
 
      if (response.statusCode == 200) {
        return {
          'access_token': token,
          'user': response.data['user'] ?? response.data,
        };
      }
 
      // Token expirado o inválido — lo borramos
      await _storage.delete(key: _tokenKey);
      return null;
    } catch (e) {
      // Si falla (offline, token inválido), sesión no restaurada
      await _storage.delete(key: _tokenKey);
      return null;
    }
  }
}
 