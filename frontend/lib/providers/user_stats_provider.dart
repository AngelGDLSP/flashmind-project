import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UserStatsProvider extends ChangeNotifier {
  int _streak = 0;
  DateTime? _lastStudyDate;
  int _xp = 0;

  int get streak => _streak;
  int get xp => _xp;
  DateTime? get lastStudyDate => _lastStudyDate;

  UserStatsProvider() {
    _loadStats();
  }

  Future<void> _loadStats() async {
    final prefs = await SharedPreferences.getInstance();
    _streak = prefs.getInt('user_streak') ?? 0;
    _xp = prefs.getInt('user_xp') ?? 0;
    final lastDateStr = prefs.getString('last_study_date');
    if (lastDateStr != null) {
      _lastStudyDate = DateTime.parse(lastDateStr);
    }
    _checkStreak();
    notifyListeners();
  }

  void _checkStreak() {
    if (_lastStudyDate == null) return;

    final now = DateTime.now();
    final difference = now.difference(_lastStudyDate!).inDays;

    if (difference > 1) {
      _streak = 0; // Se perdió la racha
      _saveStats();
    }
  }

  Future<void> recordStudySession(int xpGained) async {
    final now = DateTime.now();
    
    // Solo aumentar racha si es un día diferente
    if (_lastStudyDate == null || 
        (now.day != _lastStudyDate!.day || now.month != _lastStudyDate!.month || now.year != _lastStudyDate!.year)) {
      _streak++;
    }

    _lastStudyDate = now;
    _xp += xpGained;
    await _saveStats();
    notifyListeners();
  }

  Future<void> _saveStats() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_streak', _streak);
    await prefs.setInt('user_xp', _xp);
    if (_lastStudyDate != null) {
      await prefs.setString('last_study_date', _lastStudyDate!.toIso8601String());
    }
  }
}
