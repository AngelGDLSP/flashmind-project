import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/flashcard_provider.dart';
import '../../providers/quiz_provider.dart';
import '../../widgets/flashcard_card.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/empty_state_widget.dart';

class FlashcardsScreen extends StatefulWidget {
  final int themeId;
  final String themeName;

  const FlashcardsScreen({
    super.key,
    required this.themeId,
    required this.themeName,
  });

  @override
  State<FlashcardsScreen> createState() => _FlashcardsScreenState();
}

class _FlashcardsScreenState extends State<FlashcardsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<FlashcardProvider>().fetchFlashcards(widget.themeId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FlashcardProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.themeName),
        actions: [
          if (provider.flashcards.isNotEmpty)
            TextButton.icon(
              onPressed: () {
                context.read<QuizProvider>().startQuiz(provider.flashcards, widget.themeName);
                context.push('/quiz');
              },
              icon: const Icon(Icons.play_arrow),
              label: const Text("Estudiar"),
            ),
        ],
      ),
      body: _buildBody(context, provider),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.small(
            onPressed: () => context.push('/ai-generate/${widget.themeId}'),
            backgroundColor: Colors.purple[50],
            child: const Icon(Icons.auto_awesome, color: Colors.purple),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () => context.push('/themes/${widget.themeId}/flashcards/new'),
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, FlashcardProvider provider) {
    if (provider.isLoading) return const LoadingWidget(message: "Cargando fichas...");

    if (provider.flashcards.isEmpty) {
      return const EmptyStateWidget(
        title: "Sin fichas",
        message: "Agrega preguntas para empezar a practicar este tema.",
        icon: Icons.quiz_outlined,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: provider.flashcards.length,
      itemBuilder: (context, index) {
        final card = provider.flashcards[index];
        return FlashcardCard(
          flashcard: card,
          // ✅ FIX: deleteFlashcard ahora requiere themeId + id
          onDelete: () => provider.deleteFlashcard(widget.themeId, card.id),
        );
      },
    );
  }
}