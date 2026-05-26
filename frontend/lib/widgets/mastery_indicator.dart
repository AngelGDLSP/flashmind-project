import 'package:flutter/material.dart';
import '../models/flashcard_model.dart';

class MasteryIndicator extends StatelessWidget {
  final FlashcardModel flashcard;
  const MasteryIndicator({super.key, required this.flashcard});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;

    if (flashcard.repetitions >= 5) {
      color = Colors.green;
      label = "Dominada";
    } else if (flashcard.repetitions > 0) {
      color = Colors.blue;
      label = "Aprendiendo";
    } else if (flashcard.easeFactor < 1.5) {
      color = Colors.red;
      label = "Difícil";
    } else {
      color = Colors.grey;
      label = "Nueva";
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
