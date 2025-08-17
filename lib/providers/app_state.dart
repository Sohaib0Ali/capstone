import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/item.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';
import '../utils/notifications_service.dart';

class AppState extends ChangeNotifier {
  bool _initialized = false;
  bool _isDarkMode = false;
  bool _notificationsEnabled = true;
  bool _isAuthenticated = false;
  String? _currentUserName;
  String? _currentUserEmail;

  final StorageService _storageService = StorageService();
  final ApiService _apiService = ApiService();
  final AuthService _authService = AuthService();
  final NotificationsService _notificationsService = NotificationsService();

  List<Item> _items = <Item>[];
  final Set<int> _favoriteItemIds = <int>{};

  bool get initialized => _initialized;
  bool get isDarkMode => _isDarkMode;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get isAuthenticated => _isAuthenticated;
  String? get currentUserName => _currentUserName;
  String? get currentUserEmail => _currentUserEmail;
  List<Item> get items => List.unmodifiable(_items);
  Set<int> get favoriteItemIds => Set.unmodifiable(_favoriteItemIds);

  Future<void> initialize() async {
    if (_initialized) return;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
    _isAuthenticated = prefs.getBool('isAuthenticated') ?? false;
    _currentUserName = prefs.getString('user.name');
    _currentUserEmail = prefs.getString('user.email');

    final String? favoritesJson = prefs.getString('favoriteItemIds');
    if (favoritesJson != null) {
      final List<dynamic> decoded = jsonDecode(favoritesJson);
      _favoriteItemIds
        ..clear()
        ..addAll(decoded.map((e) => e as int));
    }

    await _notificationsService.initialize(
      notificationsEnabled: _notificationsEnabled,
    );
    await _loadItems();
    _initialized = true;
    notifyListeners();
  }

  Future<void> _loadItems() async {
    try {
      _items = await _apiService.fetchItems();
    } catch (_) {
      _items = <Item>[];
    }
  }

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    final String? error = await _authService.login(
      email: email,
      password: password,
    );
    if (error == null) {
      _isAuthenticated = true;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isAuthenticated', true);
      _currentUserEmail = email;
      await prefs.setString('user.email', email);
      notifyListeners();
    }
    return error;
  }

  Future<String?> signup({
    required String username,
    required String email,
    required String password,
  }) async {
    final String? error = await _authService.signup(
      username: username,
      email: email,
      password: password,
    );
    if (error == null) {
      _isAuthenticated = true;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isAuthenticated', true);
      _currentUserName = username;
      _currentUserEmail = email;
      await prefs.setString('user.name', username);
      await prefs.setString('user.email', email);
      notifyListeners();
    }
    return error;
  }

  Future<void> logout() async {
    _isAuthenticated = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAuthenticated', false);
    await prefs.remove('user.name');
    await prefs.remove('user.email');
    _currentUserName = null;
    _currentUserEmail = null;
    notifyListeners();
  }

  void toggleTheme(bool value) async {
    _isDarkMode = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
    notifyListeners();
  }

  Future<void> toggleNotifications(bool value) async {
    _notificationsEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationsEnabled', _notificationsEnabled);
    await _notificationsService.initialize(
      notificationsEnabled: _notificationsEnabled,
    );
    notifyListeners();
  }

  void toggleFavorite(int itemId) async {
    if (_favoriteItemIds.contains(itemId)) {
      _favoriteItemIds.remove(itemId);
    } else {
      _favoriteItemIds.add(itemId);
    }
    await _persistFavorites();
    notifyListeners();
  }

  Future<void> _persistFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'favoriteItemIds',
      jsonEncode(_favoriteItemIds.toList()),
    );
  }

  Future<void> sendTestNotification() async {
    if (!_notificationsEnabled) return;
    await _notificationsService.showInstantNotification(
      title: 'Test Notification',
      body: 'This is a test notification from the Capstone app.',
    );
  }
}
