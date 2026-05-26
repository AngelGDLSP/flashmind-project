import 'package:dio/dio.dart';
import '../models/flashcard_model.dart';
import 'api_client.dart';

// ✅ FIX: Se quitó /api de todas las rutas.
// ApiClient ya tiene baseUrl = 'http://127.0.0.1:5000/api'
// así que las rutas deben ser relativas: /themes/... no /api/themes/...

class FlashcardService {
  final Dio _dio = ApiClient.instance;

  Future<List<FlashcardModel>> getFlashcardsByTheme(int themeId) async {
    try {
      final response = await _dio.get('/themes/$themeId/flashcards');
      return (response.data as List)
          .map((json) => FlashcardModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      print("❌ ERROR GET flashcards: ${e.response?.statusCode}");
      rethrow;
    }
  }

  Future<FlashcardModel> createFlashcard(int themeId, Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(
        '/themes/$themeId/flashcards',
        data: data,
      );
      return FlashcardModel.fromJson(response.data);
    } on DioException catch (e) {
      print("❌ ERROR CREATE: ${e.response?.statusCode}");
      throw Exception(e.response?.data ?? "Error creando flashcard");
    }
  }

  // ✅ FIX: El backend requiere themeId en la URL para update y delete
  Future<FlashcardModel> updateFlashcard(int themeId, int id, Map<String, dynamic> data) async {
    try {
      final response = await _dio.put('/themes/$themeId/flashcards/$id', data: data);
      return FlashcardModel.fromJson(response.data);
    } on DioException catch (e) {
      print("❌ ERROR UPDATE: ${e.response?.data}");
      rethrow;
    }
  }

  Future<void> deleteFlashcard(int themeId, int id) async {
    try {
      await _dio.delete('/themes/$themeId/flashcards/$id');
    } on DioException catch (e) {
      print("❌ ERROR DELETE: ${e.response?.data}");
      rethrow;
    }
  }
}