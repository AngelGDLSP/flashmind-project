import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/theme_card.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/empty_state_widget.dart';

class ThemesScreen extends StatefulWidget {
  const ThemesScreen({super.key});

  @override
  State<ThemesScreen> createState() => _ThemesScreenState();
}

class _ThemesScreenState extends State<ThemesScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<ThemeProvider>().fetchThemes(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mis Temas"),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: themeProvider.fetchThemes,
        child: _buildBody(themeProvider),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/themes/new'),
        icon: const Icon(Icons.add),
        label: const Text("Nuevo Tema"),
      ),
    );
  }

 Widget _buildBody(ThemeProvider provider) {
  if (provider.isLoading) {
    return const LoadingWidget(message: "Cargando temas...");
  }

  if (provider.error != null) {
    return Center(
      child: Text(
        provider.error!,
        style: const TextStyle(color: Colors.red),
      ),
    );
  }

  if (provider.themes.isEmpty) {
    return const EmptyStateWidget(
      title: "No hay temas",
      message: "Crea tu primer tema para empezar a estudiar.",
      icon: Icons.style_outlined,
    );
  }

  return ListView.builder(
    padding: const EdgeInsets.all(16),
    itemCount: provider.themes.length,
    itemBuilder: (context, index) {
      final theme = provider.themes[index];

      return ThemeCard(
        theme: theme,
        onTap: () => context.push(
          '/themes/${theme.id}/flashcards',
          extra: theme.nombre,
        ),
        onDelete: () => _confirmDelete(context, theme.id),
      );
    },
  );
}

  void _confirmDelete(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("¿Eliminar tema?"),
        content: const Text("Esta acción eliminará también todas las fichas asociadas."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              context.read<ThemeProvider>().deleteTheme(id);
              Navigator.pop(context);
            },
            child: const Text("Eliminar", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}


