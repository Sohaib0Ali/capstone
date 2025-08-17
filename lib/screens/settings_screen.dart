import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  static const String routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const _SettingsHeader(),
          SwitchListTile.adaptive(
            secondary: const Icon(Icons.dark_mode_rounded),
            title: const Text('Dark Mode'),
            value: appState.isDarkMode,
            onChanged: (v) => appState.toggleTheme(v),
          ),
          SwitchListTile.adaptive(
            secondary: const Icon(Icons.notifications_active_rounded),
            title: const Text('Enable Notifications'),
            value: appState.notificationsEnabled,
            onChanged: (v) => appState.toggleNotifications(v),
          ),
          ListTile(
            leading: const Icon(Icons.notification_important_rounded),
            title: const Text('Send Test Notification'),
            subtitle: const Text('Tap to trigger a sample notification'),
            onTap: () => appState.sendTestNotification(),
          ),
          ListTile(
            leading: const Icon(Icons.info_rounded),
            title: const Text('About'),
            subtitle: const Text('Version 1.0.0'),
            onTap: () => showAboutDialog(
              context: context,
              applicationName: 'Capstone App',
              applicationVersion: '1.0.0',
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsHeader extends StatelessWidget {
  const _SettingsHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: const [
          Icon(Icons.settings_rounded, color: Colors.white),
          SizedBox(width: 8),
          Text(
            'App Preferences',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
