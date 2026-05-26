import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../providers/user_stats_provider.dart';
import '../../providers/review_provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/connectivity_provider.dart';
import '../../services/sync_service.dart';
import '../../widgets/streak_badge.dart';
import '../../widgets/offline_banner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SyncService _syncService = SyncService();

  @override
  void initState() {
    super.initState();
    // ✅ FIX: Future.microtask evita llamar a providers durante el build,
    // lo que causaba "setState() called during build"
    Future.microtask(() => _refreshData());
  }

  Future<void> _refreshData() async {
    if (!mounted) return;

    final themeProvider = context.read<ThemeProvider>();
    await themeProvider.fetchThemes();

    if (!mounted) return;

    final themeIds = themeProvider.themes.map((t) => t.id).toList();
    context.read<ReviewProvider>().fetchOverdueCards(themeIds);

    // ✅ FIX: Sincronización también diferida para evitar conflictos
    if (!mounted) return;
    if (context.read<ConnectivityProvider>().isOnline) {
      Future.microtask(() => _syncService.syncPendingChanges(context));
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final statsProvider = context.watch<UserStatsProvider>();
    final reviewProvider = context.watch<ReviewProvider>();
    final user = authProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text("FlashMind"),
        actions: [
          StreakBadge(streak: statsProvider.streak),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/settings'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => authProvider.logout(),
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(20),
          child: OfflineBanner(),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "¡Hola, ${user?.nombre ?? 'Estudiante'}!",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text("Tu progreso hoy se ve excelente."),
              const SizedBox(height: 32),
              _buildDailyReviewCard(context, reviewProvider),
              const SizedBox(height: 32),
              Text(
                "Acciones Rápidas",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildQuickAction(
                      context,
                      "Temas",
                      Icons.style,
                      Colors.blue,
                      () => context.push('/themes'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildQuickAction(
                      context,
                      "Stats",
                      Icons.bar_chart,
                      Colors.orange,
                      () => context.push('/stats'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/themes/new'),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildDailyReviewCard(BuildContext context, ReviewProvider provider) {
    final count = provider.overdueCards.length;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[900]!, Colors.blue[600]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "REPASO DIARIO",
            style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          const SizedBox(height: 16),
          Text(
            count > 0 ? "$count tarjetas pendientes" : "¡Todo al día!",
            style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: count > 0 ? () => context.push('/daily-review') : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue[900],
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("COMENZAR REPASO", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction(BuildContext context, String label, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 12),
            Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
