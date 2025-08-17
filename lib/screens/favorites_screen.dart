import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_state.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});
  static const String routeName = '/favorites';

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final favoriteIds = appState.favoriteItemIds;
    final items = appState.items
        .where((i) => favoriteIds.contains(i.id))
        .toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: items.isEmpty
          ? const Center(child: Text('No favorites yet'))
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.favorite_rounded,
                      color: Colors.pink,
                    ),
                    title: Text(item.title),
                    subtitle: Text(
                      item.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              },
            ),
    );
  }
}
