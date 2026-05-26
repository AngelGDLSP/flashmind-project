import 'package:hive_flutter/hive_flutter.dart';

class LocalStorageService {
  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox('themes_box');
    await Hive.openBox('flashcards_box');
    await Hive.openBox('settings_box');
    await Hive.openBox('sync_queue'); // Para cambios pendientes de subir
  }

  // Themes
  static Future<void> saveThemes(List<Map<String, dynamic>> themes) async {
    final box = Hive.box('themes_box');
    await box.put('list', themes);
  }

  static List<Map<String, dynamic>> getThemes() {
    final box = Hive.box('themes_box');
    final List<dynamic>? data = box.get('list');
    return data?.cast<Map<String, dynamic>>() ?? [];
  }

  // Flashcards
  static Future<void> saveFlashcards(int themeId, List<Map<String, dynamic>> cards) async {
    final box = Hive.box('flashcards_box');
    await box.put('theme_$themeId', cards);
  }

  static List<Map<String, dynamic>> getFlashcards(int themeId) {
    final box = Hive.box('flashcards_box');
    final List<dynamic>? data = box.get('theme_$themeId');
    return data?.cast<Map<String, dynamic>>() ?? [];
  }

  // Sync Queue (Offline changes)
  static Future<void> addToSyncQueue(Map<String, dynamic> action) async {
    final box = Hive.box('sync_queue');
    final List<dynamic> queue = box.get('items', defaultValue: []);
    queue.add(action);
    await box.put('items', queue);
  }

  static List<Map<String, dynamic>> getSyncQueue() {
    final box = Hive.box('sync_queue');
    final List<dynamic> queue = box.get('items', defaultValue: []);
    return queue.cast<Map<String, dynamic>>();
  }

  static Future<void> clearSyncQueue() async {
    await Hive.box('sync_queue').delete('items');
  }
}
