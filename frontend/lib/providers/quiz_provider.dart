import 'package:flutter/material.dart';
import '../models/flashcard_model.dart';
import '../models/quiz_result_model.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class QuizProvider extends ChangeNotifier {
  List<FlashcardModel> _questions = [];
  int _currentIndex = 0;
  int _correctCount = 0;
  int _incorrectCount = 0;
  bool _isFinished = false;
  String _currentThemeName = "";

  // Getters
  List<FlashcardModel> get questions => _questions;
  int get currentIndex => _currentIndex;
  int get correctCount => _correctCount;
  int get incorrectCount => _incorrectCount;
  bool get isFinished => _isFinished;
  double get progress => _questions.isEmpty ? 0 : (_currentIndex / _questions.length);
  FlashcardModel? get currentQuestion => _questions.isNotEmpty && _currentIndex < _questions.length 
      ? _questions[_currentIndex] : null;

  void startQuiz(List<FlashcardModel> flashcards, String themeName) {
    _questions = List.from(flashcards)..shuffle();
    _currentIndex = 0;
    _correctCount = 0;
    _incorrectCount = 0;
    _isFinished = false;
    _currentThemeName = themeName;
    notifyListeners();
  }

  void markCorrect() {
    _correctCount++;
    _nextQuestion();
  }

  void markIncorrect() {
    _incorrectCount++;
    _nextQuestion();
  }

  void _nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      _currentIndex++;
    } else {
      _isFinished = true;
      _saveResult();
    }
    notifyListeners();
  }

  Future<void> _saveResult() async {
    final result = QuizResultModel(
      totalQuestions: _questions.length,
      correctAnswers: _correctCount,
      incorrectAnswers: _incorrectCount,
      percentage: (_correctCount / _questions.length) * 100,
      date: DateTime.now(),
      themeName: _currentThemeName,
    );

    final prefs = await SharedPreferences.getInstance();
    final List<String> resultsJson = prefs.getStringList('quiz_results') ?? [];
    resultsJson.add(jsonEncode(result.toJson()));
    await prefs.setStringList('quiz_results', resultsJson);
  }
}
