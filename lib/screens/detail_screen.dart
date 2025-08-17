import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_state.dart';

class DetailScreenArgs {
  final int itemId;
  final String title;
  final String description;

  DetailScreenArgs({
    required this.itemId,
    required this.title,
    required this.description,
  });
}

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key, required this.args});
  static const String routeName = '/detail';

  final DetailScreenArgs args;

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final bool isFav = appState.favoriteItemIds.contains(args.itemId);
    return Scaffold(
      appBar: AppBar(title: const Text('Detail')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(child: Text(args.itemId.toString())),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          args.title,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Favorite',
                        icon: Icon(
                          isFav
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          color: isFav ? Colors.pink : null,
                        ),
                        onPressed: () => appState.toggleFavorite(args.itemId),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(args.description),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.info_outline_rounded),
              title: const Text('About this item'),
              subtitle: const Text('Powered by JSONPlaceholder API'),
            ),
          ),
        ],
      ),
    );
  }
}
