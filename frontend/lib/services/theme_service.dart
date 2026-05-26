import 'package:dio/dio.dart';
import '../models/theme_model.dart';
import 'api_client.dart';

class ThemeService {
  final Dio _dio = ApiClient.instance;

  Future<List<ThemeModel>> getThemes() async {
    try {
      final response = await _dio.get('/themes/');
      return (response.data as List)
          .map((json) => ThemeModel.fromJson(json))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<ThemeModel> createTheme(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post('/themes/', data: data);
      return ThemeModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<ThemeModel> updateTheme(int id, Map<String, dynamic> data) async {
    try {
      final response = await _dio.put('/themes/$id', data: data);
      return ThemeModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteTheme(int id) async {
    try {
      await _dio.delete('/themes/$id');
    } catch (e) {
      rethrow;
    }
  }
}
