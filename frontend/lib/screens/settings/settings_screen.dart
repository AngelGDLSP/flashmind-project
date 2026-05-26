import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Ajustes")),
      body: ListView(
        children: [
          const _SectionHeader(title: "Notificaciones"),
          SwitchListTile(
            title: const Text("Recordatorios Diarios"),
            subtitle: const Text("Recibe un aviso para tus repasos"),
            value: settings.notificationsEnabled,
            onChanged: (v) => settings.toggleNotifications(v),
          ),
          ListTile(
            title: const Text("Hora del Recordatorio"),
            subtitle: Text(settings.reminderTime.format(context)),
            trailing: const Icon(Icons.access_time),
            enabled: settings.notificationsEnabled,
            onTap: () async {
              final time = await showTimePicker(
                context: context,
                initialTime: settings.reminderTime,
              );
              if (time != null) settings.updateReminder(time);
            },
          ),
          const Divider(),
          const _SectionHeader(title: "Apariencia"),
          SwitchListTile(
            title: const Text("Modo Oscuro"),
            value: settings.darkMode,
            onChanged: (v) => settings.toggleDarkMode(v),
          ),
          const Divider(),
          const _SectionHeader(title: "Datos"),
          ListTile(
            title: const Text("Exportar Datos"),
            leading: const Icon(Icons.download),
            onTap: () {},
          ),
          ListTile(
            title: const Text("Cerrar Sesión"),
            leading: const Icon(Icons.logout, color: Colors.red),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
          fontSize: 12,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
