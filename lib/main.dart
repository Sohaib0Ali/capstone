import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_theme.dart';
import 'providers/app_state.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/detail_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/favorites_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final AppState appState = AppState();
  await appState.initialize();

  runApp(
    ChangeNotifierProvider<AppState>(
      create: (_) => appState,
      child: const FinalProjectApp(),
    ),
  );
}

class FinalProjectApp extends StatelessWidget {
  const FinalProjectApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return MaterialApp(
      title: 'Capstone App',
      debugShowCheckedModeBanner: false,
      themeMode: appState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      initialRoute: appState.isAuthenticated
          ? HomeScreen.routeName
          : LoginScreen.routeName,
      routes: {
        LoginScreen.routeName: (_) => const LoginScreen(),
        SignupScreen.routeName: (_) => const SignupScreen(),
        HomeScreen.routeName: (_) => const HomeScreen(),
        FavoritesScreen.routeName: (_) => const FavoritesScreen(),
        SettingsScreen.routeName: (_) => const SettingsScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == DetailScreen.routeName) {
          final args = settings.arguments as DetailScreenArgs;
          return PageRouteBuilder(
            pageBuilder: (_, __, ___) => DetailScreen(args: args),
            transitionsBuilder: (_, animation, __, child) {
              final curved = CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              );
              return FadeTransition(opacity: curved, child: child);
            },
            transitionDuration: const Duration(milliseconds: 300),
          );
        }
        return null;
      },
    );
  }
}
