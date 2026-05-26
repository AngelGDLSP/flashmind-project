import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/quiz_result_model.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  List<QuizResultModel> _results = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final prefs = await SharedPreferences.getInstance();
    final resultsJson = prefs.getStringList('quiz_results') ?? [];
    
    setState(() {
      _results = resultsJson
          .map((item) => QuizResultModel.fromJson(jsonDecode(item)))
          .toList()
          .reversed
          .toList();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    final totalQuizzes = _results.length;
    final totalCorrect = _results.fold(0, (sum, item) => sum + item.correctAnswers);
    final totalIncorrect = _results.fold(0, (sum, item) => sum + item.incorrectAnswers);
    final avgScore = totalQuizzes > 0 
        ? _results.fold(0.0, (sum, item) => sum + item.percentage) / totalQuizzes 
        : 0.0;

    return Scaffold(
      appBar: AppBar(title: const Text("Estadísticas")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Resumen General",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: _buildSummaryCard("Quizzes", totalQuizzes.toString(), Colors.blue)),
                const SizedBox(width: 16),
                Expanded(child: _buildSummaryCard("Promedio", "${avgScore.toInt()}%", Colors.orange)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildSummaryCard("Correctas", totalCorrect.toString(), Colors.green)),
                const SizedBox(width: 16),
                Expanded(child: _buildSummaryCard("Incorrectas", totalIncorrect.toString(), Colors.red)),
              ],
            ),
            const SizedBox(height: 40),
            Text(
              "Actividad Reciente",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (_results.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Text("No hay actividad registrada", style: TextStyle(color: Colors.grey)),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _results.length > 5 ? 5 : _results.length,
                itemBuilder: (context, index) {
                  final res = _results[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      title: Text(res.themeName),
                      subtitle: Text("${res.date.day}/${res.date.month}/${res.date.year}"),
                      trailing: Text(
                        "${res.percentage.toInt()}%",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: res.percentage >= 70 ? Colors.green : Colors.orange,
                        ),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }
}
