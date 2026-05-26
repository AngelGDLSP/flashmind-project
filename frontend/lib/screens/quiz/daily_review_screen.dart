import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/review_provider.dart';
import '../../providers/flashcard_provider.dart';
import '../../providers/user_stats_provider.dart';
import '../../widgets/study_flashcard.dart';
import '../../widgets/quiz_progress_bar.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/empty_state_widget.dart';

class DailyReviewScreen extends StatefulWidget {
  const DailyReviewScreen({super.key});

  @override
  State<DailyReviewScreen> createState() => _DailyReviewScreenState();
}

class _DailyReviewScreenState extends State<DailyReviewScreen> {
  @override
  Widget build(BuildContext context) {
    final reviewProvider = context.watch<ReviewProvider>();
    final flashcardProvider = context.read<FlashcardProvider>();
    final statsProvider = context.read<UserStatsProvider>();

    if (reviewProvider.isLoading) {
      return const Scaffold(body: LoadingWidget(message: "Buscando tarjetas pendientes..."));
    }

    if (reviewProvider.overdueCards.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text("Repaso Diario")),
        body: const EmptyStateWidget(
          title: "¡Todo al día!",
          message: "Has completado todos tus repasos de hoy. ¡Buen trabajo!",
          icon: Icons.check_circle_outline,
        ),
      );
    }

    final card = reviewProvider.overdueCards.first;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Repaso Diario"),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(child: Text("${reviewProvider.remainingCount} restantes")),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            QuizProgressBar(progress: reviewProvider.progress),
            const Spacer(),
            StudyFlashcard(flashcard: card),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      // ✅ FIX: updateReview ahora requiere themeId — lo tomamos del card
                      await flashcardProvider.updateReview(card.idTema, card.id, false);
                      reviewProvider.removeCurrentCard();
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: Colors.red),
                    ),
                    child: const Text("Olvidada", style: TextStyle(color: Colors.red)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      // ✅ FIX: updateReview ahora requiere themeId — lo tomamos del card
                      await flashcardProvider.updateReview(card.idTema, card.id, true);
                      reviewProvider.removeCurrentCard();
                      if (reviewProvider.overdueCards.isEmpty) {
                        await statsProvider.recordStudySession(10);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Recordada"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}