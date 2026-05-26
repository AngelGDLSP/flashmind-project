import 'package:flutter/material.dart';
import '../models/flashcard_model.dart';

class StudyFlashcard extends StatefulWidget {
  final FlashcardModel flashcard;
  const StudyFlashcard({super.key, required this.flashcard});

  @override
  State<StudyFlashcard> createState() => _StudyFlashcardState();
}

class _StudyFlashcardState extends State<StudyFlashcard> {
  bool _showAnswer = false;

  @override
  void didUpdateWidget(covariant StudyFlashcard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.flashcard.id != widget.flashcard.id) {
      _showAnswer = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _showAnswer = !_showAnswer),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
          border: Border.all(color: Colors.blue.withOpacity(0.1)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _showAnswer ? "RESPUESTA" : "PREGUNTA",
              style: TextStyle(
                letterSpacing: 2,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.blue[300],
              ),
            ),
            const SizedBox(height: 48),
            Text(
              _showAnswer ? widget.flashcard.respuesta : widget.flashcard.pregunta,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: _showAnswer ? Colors.blue[900] : Colors.black87,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            Text(
              "Toca para voltear",
              style: TextStyle(color: Colors.grey[400], fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
