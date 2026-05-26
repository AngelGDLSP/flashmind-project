import 'package:flutter/material.dart';
import '../services/ai_service.dart';

class AiProvider extends ChangeNotifier {
  final AiService _aiService = AiService();
  
  bool _isLoading = false;
  List<Map<String, dynamic>> _generatedCards = [];

  bool get isLoading => _isLoading;
  List<Map<String, dynamic>> get generatedCards => _generatedCards;

  Future<bool> generate(String texto, int cantidad) async {
    _isLoading = true;
    notifyListeners();

    try {
      _generatedCards = await _aiService.generateFlashcards(texto, cantidad);
      return true;
    } catch (e) {
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    _generatedCards = [];
    notifyListeners();
  }

  void removeCard(int index) {
    _generatedCards.removeAt(index);
    notifyListeners();
  }
}
