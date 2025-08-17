import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_state.dart';
import '../widgets/app_logo.dart';
import 'detail_screen.dart';
import 'favorites_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const String routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            AppLogo(size: 28),
            SizedBox(width: 8),
            Text('Capstone App'),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Favorites',
            icon: const Icon(Icons.favorite_rounded),
            onPressed: () =>
                Navigator.pushNamed(context, FavoritesScreen.routeName),
          ),
          IconButton(
            tooltip: 'Settings',
            icon: const Icon(Icons.settings_rounded),
            onPressed: () =>
                Navigator.pushNamed(context, SettingsScreen.routeName),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(fontWeight: FontWeight.w700),
          // Make the selected indicator cover the entire tab with a clearer pill
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          indicator: BoxDecoration(
            color: Colors.white54,
            borderRadius: BorderRadius.circular(24),
          ),
          tabs: const [
            Tab(icon: Icon(Icons.list_alt_rounded), text: 'Feed'),
            Tab(icon: Icon(Icons.grid_view_rounded), text: 'Grid'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_FeedTab(), _GridTab()],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.notifications_active_rounded),
        label: const Text('Notify'),
        onPressed: () => appState.sendTestNotification(),
      ),
    );
  }
}

class _FeedTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final items = appState.items;
    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.inbox_rounded, size: 56, color: Colors.grey),
              const SizedBox(height: 12),
              const Text('No items yet', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              const Text(
                'Pull to refresh or tap Retry to load demo content.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Retry'),
                onPressed: () => context.read<AppState>().refreshItems(),
              ),
            ],
          ),
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: () => context.read<AppState>().refreshItems(),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          final bool isFav = appState.favoriteItemIds.contains(item.id);
          return Card(
            child: ListTile(
              leading: CircleAvatar(child: Text(item.id.toString())),
              title: Text(item.title),
              subtitle: Text(
                item.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    tooltip: 'Favorite',
                    icon: Icon(
                      isFav
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: isFav ? Colors.pink : null,
                    ),
                    onPressed: () => appState.toggleFavorite(item.id),
                  ),
                  const Icon(Icons.chevron_right_rounded),
                ],
              ),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  DetailScreen.routeName,
                  arguments: DetailScreenArgs(
                    itemId: item.id,
                    title: item.title,
                    description: item.description,
                  ),
                );
              },
              onLongPress: () {
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  builder: (ctx) {
                    return SafeArea(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: const Icon(Icons.open_in_new_rounded),
                            title: const Text('Open Details'),
                            onTap: () {
                              Navigator.pop(ctx);
                              Navigator.pushNamed(
                                context,
                                DetailScreen.routeName,
                                arguments: DetailScreenArgs(
                                  itemId: item.id,
                                  title: item.title,
                                  description: item.description,
                                ),
                              );
                            },
                          ),
                          ListTile(
                            leading: Icon(
                              isFav
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              color: isFav ? Colors.pink : null,
                            ),
                            title: Text(
                              isFav ? 'Remove Favorite' : 'Add to Favorites',
                            ),
                            onTap: () {
                              Navigator.pop(ctx);
                              appState.toggleFavorite(item.id);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}

  class _GridTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final items = appState.items;
    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.inbox_rounded, size: 56, color: Colors.grey),
              const SizedBox(height: 12),
              const Text('No items yet', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              const Text(
                'Tap Retry to load demo content.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Retry'),
                onPressed: () => context.read<AppState>().refreshItems(),
              ),
            ],
          ),
        ),
      );
    }
    final isWide = MediaQuery.of(context).size.width > 700;
    final crossAxisCount = isWide ? 4 : 2;
    // Fixed tile height to avoid overflow while keeping a balanced look
    final double tileHeight = isWide ? 200.0 : 170.0;
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisExtent: tileHeight,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => Navigator.pushNamed(
            context,
            DetailScreen.routeName,
            arguments: DetailScreenArgs(
              itemId: item.id,
              title: item.title,
              description: item.description,
            ),
          ),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.article_rounded, color: Colors.white),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          item.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: Colors.white70,
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.description,
                    maxLines: isWide ? 3 : 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.92),
                      height: 1.25,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
