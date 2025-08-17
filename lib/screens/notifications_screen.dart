import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});
  static const String routeName = '/notifications';

  @override
  Widget build(BuildContext context) {
    final dummyNotifications = <Map<String, String>>[
      {
        'title': 'Welcome to Capstone App',
        'body': 'Thanks for installing! Explore the feed to get started.',
      },
      {
        'title': 'Weekly Summary',
        'body': 'You have 3 new items and 1 new favorite this week.',
      },
      {
        'title': 'Feature Tip',
        'body': 'Try dark mode from Settings for a different look!',
      },
      {
        'title': 'Reminder',
        'body': 'Enable notifications in Settings to stay updated.',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        leading: const Icon(Icons.notifications_rounded),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: dummyNotifications.length,
        separatorBuilder: (_, __) => const SizedBox(height: 6),
        itemBuilder: (context, index) {
          final n = dummyNotifications[index];
          return Card(
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFF3B82F6),
                child: Icon(Icons.notifications_rounded, color: Colors.white),
              ),
              title: Text(n['title'] ?? ''),
              subtitle: Text(
                n['body'] ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () {},
            ),
          );
        },
      ),
    );
  }
}
