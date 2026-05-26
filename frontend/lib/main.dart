import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'providers/auth_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/flashcard_provider.dart';
import 'providers/quiz_provider.dart';
import 'providers/ai_provider.dart';
import 'providers/review_provider.dart';
import 'providers/user_stats_provider.dart';
import 'providers/connectivity_provider.dart';
import 'providers/settings_provider.dart';
import 'services/local_storage_service.dart';
import 'services/notification_service.dart';
import 'routes/app_router.dart';
 
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
 
  await LocalStorageService.init();
  await NotificationService.init();
 
  // ✅ FIX: AuthProvider se crea aquí, ANTES de runApp,
  // para poder pasarlo tanto al MultiProvider como al GoRouter.
  // Ambos deben usar LA MISMA INSTANCIA — de lo contrario
  // refreshListenable escucha un objeto diferente al que hace login.
  final authProvider = AuthProvider();
 
  runApp(
    MultiProvider(
      providers: [
        // ✅ FIX: Usamos .value para inyectar la instancia ya creada
        ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => FlashcardProvider()),
        ChangeNotifierProvider(create: (_) => QuizProvider()),
        ChangeNotifierProvider(create: (_) => AiProvider()),
        ChangeNotifierProvider(create: (_) => ReviewProvider()),
        ChangeNotifierProvider(create: (_) => UserStatsProvider()),
        ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: FlashMindApp(authProvider: authProvider),
    ),
  );
}
 
class FlashMindApp extends StatelessWidget {
  // ✅ FIX: Recibe el authProvider para pasárselo al router
  final AuthProvider authProvider;
 
  const FlashMindApp({super.key, required this.authProvider});
 
  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
 
    return MaterialApp.router(
      title: 'FlashMind',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: settings.darkMode ? Brightness.dark : Brightness.light,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      // ✅ FIX: createRouter recibe la misma instancia de authProvider
      // que está registrada en el MultiProvider
      routerConfig: AppRouter.createRouter(authProvider),
    );
  }
}
