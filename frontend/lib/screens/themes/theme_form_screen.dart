import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/custom_textfield.dart';

class ThemeFormScreen extends StatefulWidget {
  const ThemeFormScreen({super.key});

  @override
  State<ThemeFormScreen> createState() => _ThemeFormScreenState();
}

class _ThemeFormScreenState extends State<ThemeFormScreen> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nuevo Tema")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                controller: _nameController,
                label: "Nombre del Tema",
                icon: Icons.title,
                validator: (v) => v!.isEmpty ? "Campo requerido" : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _descController,
                label: "Descripción",
                icon: Icons.description,
                maxLines: 3,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _submit(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Guardar Tema"),
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
      final success = await context.read<ThemeProvider>().createTheme(
            _nameController.text,
            _descController.text,
            1, // ID Categoria por defecto
          );
      if (success && mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Tema creado con éxito")),
        );
      }
    }
  }
}
