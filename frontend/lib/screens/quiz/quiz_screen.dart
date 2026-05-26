import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/quiz_provider.dart';
import '../../widgets/quiz_progress_bar.dart';
import '../../widgets/study_flashcard.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<QuizProvider>();
    
    if (provider.isFinished) {
      Future.microtask(() => context.replace('/quiz/result'));
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final question = provider.currentQuestion;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Modo Estudio"),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          children: [
            QuizProgressBar(progress: provider.progress),
            const Spacer(),
            if (question != null)
              StudyFlashcard(flashcard: question),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => provider.markIncorrect(),
                    icon: const Icon(Icons.close, color: Colors.red),
                    label: const Text("Incorrecto", style: TextStyle(color: Colors.red)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: Colors.red),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => provider.markCorrect(),
                    icon: const Icon(Icons.check, color: Colors.white),
                    label: const Text("Correcto"),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
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
