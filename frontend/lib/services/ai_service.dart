import 'package:dio/dio.dart';
import 'api_client.dart';

class AiService {
  final Dio _dio = ApiClient.instance;

  Future<List<Map<String, dynamic>>> generateFlashcards(String texto, int cantidad) async {
    try {
      final response = await _dio.post('/ai/generate-flashcards', data: {
        'texto': texto,
        'cantidad': cantidad,
      });
      return List<Map<String, dynamic>>.from(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
