import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  static final Dio _dio = _createDio();
  static const _storage = FlutterSecureStorage();

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        // ✅ IMPORTANTE: QUITA /api aquí
        baseUrl: 'http://127.0.0.1:5000/api',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.read(key: 'jwt_token');

          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            await _storage.delete(key: 'jwt_token');
          }
          return handler.next(e);
        },
      ),
    );

    return dio;
  }

  static Dio get instance => _dio;
}