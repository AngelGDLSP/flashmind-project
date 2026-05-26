import 'package:flutter/material.dart';
import '../models/flashcard_model.dart';
import '../services/flashcard_service.dart';
import '../services/local_storage_service.dart';

class FlashcardProvider extends ChangeNotifier {
  final FlashcardService _flashcardService = FlashcardService();

  List<FlashcardModel> _flashcards = [];
  bool _isLoading = false;
  String? _error;

  List<FlashcardModel> get flashcards => _flashcards;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchFlashcards(int themeId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final localCards = LocalStorageService.getFlashcards(themeId);
      if (localCards.isNotEmpty) {
        _flashcards = localCards
            .map((json) => FlashcardModel.fromJson(Map<String, dynamic>.from(json)))
            .toList();
        notifyListeners();
      }

      final remoteCards = await _flashcardService.getFlashcardsByTheme(themeId);
      _flashcards = remoteCards;

      await LocalStorageService.saveFlashcards(
        themeId,
        _flashcards.map((f) => f.toJson()).toList(),
      );
    } catch (e) {
      if (_flashcards.isEmpty) {
        _error = "Error al cargar las fichas";
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createFlashcard(int themeId, String pregunta, String respuesta) async {
    final data = {
      'pregunta': pregunta,
      'respuesta': respuesta,
    };

    try {
      final newCard = await _flashcardService.createFlashcard(themeId, data);
      _flashcards.add(newCard);
      await LocalStorageService.saveFlashcards(
        themeId,
        _flashcards.map((f) => f.toJson()).toList(),
      );
      notifyListeners();
      return true;
    } catch (e) {
      await LocalStorageService.addToSyncQueue({
        'action': 'create_flashcard',
        'themeId': themeId,
        'data': data,
      });
      return false;
    }
  }

  // ✅ FIX: deleteFlashcard ahora recibe themeId para construir la URL correcta
  Future<bool> deleteFlashcard(int themeId, int id) async {
    try {
      await _flashcardService.deleteFlashcard(themeId, id);
      _flashcards.removeWhere((f) => f.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      print("❌ ERROR deleteFlashcard: $e");
      return false;
    }
  }

  // ✅ FIX: updateReview ahora recibe themeId para construir la URL correcta
  Future<void> updateReview(int themeId, int id, bool isCorrect) async {
    final index = _flashcards.indexWhere((f) => f.id == id);
    if (index == -1) return;

    final card = _flashcards[index];

    int repetitions = isCorrect ? card.repetitions + 1 : 0;
    double easeFactor = card.easeFactor;

    if (isCorrect && repetitions > 1) {
      easeFactor = card.easeFactor + (0.1 - (5 - 4) * (0.08 + (5 - 4) * 0.02));
    } else if (!isCorrect) {
      easeFactor = (card.easeFactor - 0.2).clamp(1.3, 2.5);
    }

    int interval;
    if (repetitions == 0) {
      interval = 0;
    } else if (repetitions == 1) {
      interval = 1;
    } else if (repetitions == 2) {
      interval = 6;
    } else {
      interval = (card.interval * easeFactor).round();
    }

    final nextReview = DateTime.now().add(Duration(days: interval));

    try {
      await _flashcardService.updateFlashcard(themeId, id, {
        'interval': interval,
        'ease_factor': easeFactor,
        'repetitions': repetitions,
        'next_review': nextReview.toIso8601String(),
        'veces_repasada': card.vecesRepasada + 1,
      });

      _flashcards[index] = FlashcardModel(
        id: card.id,
        pregunta: card.pregunta,
        respuesta: card.respuesta,
        dificultad: card.dificultad,
        idTema: card.idTema,
        vecesRepasada: card.vecesRepasada + 1,
        interval: interval,
        easeFactor: easeFactor,
        repetitions: repetitions,
        nextReview: nextReview,
      );

      notifyListeners();
    } catch (e) {
      print("❌ ERROR updateReview: $e");
    }
  }

  List<FlashcardModel> getDueFlashcards() {
    final now = DateTime.now();
    return _flashcards.where((f) => f.nextReview.isBefore(now)).toList();
  }
}