import 'package:flutter/material.dart';
import '../services/local_storage_service.dart';
import '../services/theme_service.dart';

class SyncService {
  final ThemeService _themeService = ThemeService();

  Future<void> syncPendingChanges(BuildContext context) async {
    final queue = LocalStorageService.getSyncQueue();
    if (queue.isEmpty) return;

    debugPrint("Sincronizando ${queue.length} cambios pendientes...");

    for (var rawItem in queue) {
      // ✅ FIX: Hive devuelve LinkedMap<dynamic, dynamic> al leer del caché.
      // Hay que convertirlo explícitamente a Map<String, dynamic>
      // antes de acceder a sus keys, o Dart lanza un TypeError en runtime.
      final item = Map<String, dynamic>.from(rawItem as Map);

      try {
        if (item['action'] == 'create_theme') {
          final data = Map<String, dynamic>.from(item['data'] as Map);
          await _themeService.createTheme(data);
        }
        // Agregar más acciones aquí (crear ficha, actualizar SRS, etc.)
      } catch (e) {
        debugPrint("Error sincronizando item: $e");
        return; // Detener si falla la conexión de nuevo
      }
    }

    await LocalStorageService.clearSyncQueue();
  }
}