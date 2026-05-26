import 'package:flutter/material.dart';
import '../models/flashcard_model.dart';
import '../services/flashcard_service.dart';

class ReviewProvider extends ChangeNotifier {
  final FlashcardService _service = FlashcardService();
  
  List<FlashcardModel> _overdueCards = [];
  bool _isLoading = false;
  int _initialCount = 0;

  List<FlashcardModel> get overdueCards => _overdueCards;
  bool get isLoading => _isLoading;
  int get initialCount => _initialCount;
  int get remainingCount => _overdueCards.length;
  double get progress => _initialCount == 0 ? 1 : (1 - (remainingCount / _initialCount));

  Future<void> fetchOverdueCards(List<int> themeIds) async {
    _isLoading = true;
    _overdueCards = [];
    notifyListeners();

    try {
      for (var id in themeIds) {
        final cards = await _service.getFlashcardsByTheme(id);
        final now = DateTime.now();
        _overdueCards.addAll(cards.where((f) => f.nextReview.isBefore(now)));
      }
      _initialCount = _overdueCards.length;
    } catch (e) {
      print("Error fetching overdue: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void removeCurrentCard() {
    if (_overdueCards.isNotEmpty) {
      _overdueCards.removeAt(0);
      notifyListeners();
    }
  }
}
