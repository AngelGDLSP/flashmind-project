import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/flashcard_provider.dart';
import '../../widgets/custom_textfield.dart';

class FlashcardFormScreen extends StatefulWidget {
  final int themeId;
  const FlashcardFormScreen({super.key, required this.themeId});

  @override
  State<FlashcardFormScreen> createState() => _FlashcardFormScreenState();
}

class _FlashcardFormScreenState extends State<FlashcardFormScreen> {
  final _qController = TextEditingController();
  final _aController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nueva Ficha")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                controller: _qController,
                label: "Pregunta",
                icon: Icons.question_mark,
                maxLines: 2,
                validator: (v) => v!.isEmpty ? "Campo requerido" : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _aController,
                label: "Respuesta",
                icon: Icons.check_circle_outline,
                maxLines: 3,
                validator: (v) => v!.isEmpty ? "Campo requerido" : null,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _submit(context),
                  child: const Text("Crear Ficha"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit(BuildContext context) async {
    if (_formKey.currentState!.validate()) {

      print("🟢 BOTÓN PRESIONADO");

      final success = await context.read<FlashcardProvider>().createFlashcard(
        widget.themeId,
        _qController.text,
        _aController.text,
      );

      print("📊 RESULTADO: $success");

      if (success && mounted) {
        context.pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error al crear la ficha")),
        );
      }
    }
  }
}