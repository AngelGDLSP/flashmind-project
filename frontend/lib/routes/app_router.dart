import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../screens/auth/login_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/themes/themes_screen.dart';
import '../screens/themes/theme_form_screen.dart';
import '../screens/flashcards/flashcards_screen.dart';
import '../screens/flashcards/flashcard_form_screen.dart';
import '../screens/quiz/quiz_screen.dart';
import '../screens/quiz/quiz_result_screen.dart';
import '../screens/stats/stats_screen.dart';
import '../screens/ai/ai_generate_screen.dart';
import '../screens/quiz/daily_review_screen.dart';
import '../screens/settings/settings_screen.dart';
 
class AppRouter {
  // ✅ FIX: Ya no es static final — recibe el AuthProvider como parámetro
  // para que GoRouter pueda suscribirse a sus cambios con refreshListenable.
  static GoRouter createRouter(AuthProvider authProvider) {
    return GoRouter(
      initialLocation: '/login',
 
      // ✅ FIX PRINCIPAL: refreshListenable hace que GoRouter re-evalúe
      // el redirect cada vez que AuthProvider llama notifyListeners().
      // Sin esto, GoRouter es ciego a los cambios de estado del provider.
      refreshListenable: authProvider,
 
      redirect: (context, state) {
        // ✅ NUEVO: Mientras la app verifica la sesión guardada (token en
        // secure storage), no redirigimos a nadie. El splash o la pantalla
        // actual se quedan quietas hasta que sessionChecked = true.
        if (!authProvider.sessionChecked) return null;
 
        final isLoggedIn = authProvider.isAuthenticated;
        final isOnLogin = state.matchedLocation == '/login';
 
        // No autenticado y no está en login → manda a login
        if (!isLoggedIn && !isOnLogin) return '/login';
 
        // Autenticado y está en login → manda a home
        if (isLoggedIn && isOnLogin) return '/home';
 
        // Sin redirección necesaria
        return null;
      },
 
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsScreen(),
        ),
        GoRoute(
          path: '/daily-review',
          builder: (context, state) => const DailyReviewScreen(),
        ),
        GoRoute(
          path: '/stats',
          builder: (context, state) => const StatsScreen(),
        ),
        GoRoute(
          path: '/quiz',
          builder: (context, state) => const QuizScreen(),
          routes: [
            GoRoute(
              path: 'result',
              builder: (context, state) => const QuizResultScreen(),
            ),
          ],
        ),
        GoRoute(
          path: '/ai-generate/:themeId',
          builder: (context, state) {
            final themeId = int.parse(state.pathParameters['themeId']!);
            return AiGenerateScreen(themeId: themeId);
          },
        ),
        GoRoute(
          path: '/themes',
          builder: (context, state) => const ThemesScreen(),
          routes: [
            GoRoute(
              path: 'new',
              builder: (context, state) => const ThemeFormScreen(),
            ),
            GoRoute(
              path: ':themeId/flashcards',
              builder: (context, state) {
                final themeId = int.parse(state.pathParameters['themeId']!);
                final themeName = state.extra as String? ?? 'Fichas';
                return FlashcardsScreen(themeId: themeId, themeName: themeName);
              },
              routes: [
                GoRoute(
                  path: 'new',
                  builder: (context, state) {
                    final themeId =
                        int.parse(state.pathParameters['themeId']!);
                    return FlashcardFormScreen(themeId: themeId);
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}