import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/ai_provider.dart';
import '../../providers/flashcard_provider.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/loading_widget.dart';

class AiGenerateScreen extends StatefulWidget {
  final int themeId;
  const AiGenerateScreen({super.key, required this.themeId});

  @override
  State<AiGenerateScreen> createState() => _AiGenerateScreenState();
}

class _AiGenerateScreenState extends State<AiGenerateScreen> {
  final _textController = TextEditingController();
  int _count = 5;

  @override
  Widget build(BuildContext context) {
    final aiProvider = context.watch<AiProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Generar con IA")),
      body: aiProvider.isLoading 
          ? const LoadingWidget(message: "La IA está analizando tu texto...")
          : aiProvider.generatedCards.isNotEmpty 
              ? _buildPreview(aiProvider)
              : _buildInputForm(aiProvider),
    );
  }

  Widget _buildInputForm(AiProvider provider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Pega el contenido educativo aquí:",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _textController,
            label: "Contenido (libros, artículos, apuntes...)",
            maxLines: 10,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Cantidad de fichas:"),
              DropdownButton<int>(
                value: _count,
                items: [3, 5, 10, 15].map((i) => DropdownMenuItem(value: i, child: Text(i.toString()))).toList(),
                onChanged: (v) => setState(() => _count = v!),
              ),
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => provider.generate(_textController.text, _count),
              icon: const Icon(Icons.auto_awesome),
              label: const Text("Generar Flashcards"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreview(AiProvider provider) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.generatedCards.length,
            itemBuilder: (context, index) {
              final card = provider.generatedCards[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text(card['pregunta']),
                  subtitle: Text(card['respuesta']),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => provider.removeCard(index),
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => provider.clear(),
                  child: const Text("Cancelar"),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _saveAll(context, provider),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                  child: const Text("Guardar Todas"),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _saveAll(BuildContext context, AiProvider provider) async {
    final flashcardProvider = context.read<FlashcardProvider>();
    for (var card in provider.generatedCards) {
      await flashcardProvider.createFlashcard(
        widget.themeId, 
        card['pregunta'], 
        card['respuesta']
      );
    }
    provider.clear();
    if (mounted) context.pop();
  }
}
