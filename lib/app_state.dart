// lib/app_state.dart
import 'package:flutter/material.dart';
import 'models/user.dart';
import 'services/storage_service.dart';

enum AppLanguage { english, hindi, telugu }

class AppState extends ChangeNotifier {
  final StorageService storage;

  AppState({required this.storage});

  // users and session
  List<AppUser> users = [];
  AppUser? loggedIn;

  // theme & language
  bool isDark = false;
  AppLanguage language = AppLanguage.english;

  // trending searches
  List<String> searches = [];

  // initialize loads persisted data
  Future<void> initialize() async {
    users = await storage.loadUsers();
    isDark = await storage.loadThemeIsDark();
    final langKey = await storage.loadLang();
    language = _langFromKey(langKey);
    searches = await storage.loadSearches();
    notifyListeners();
  }

  AppLanguage _langFromKey(String k) {
    switch (k) {
      case 'hindi':
        return AppLanguage.hindi;
      case 'telugu':
        return AppLanguage.telugu;
      case 'english':
      default:
        return AppLanguage.english;
    }
  }

  String _langKey(AppLanguage l) {
    switch (l) {
      case AppLanguage.hindi:
        return 'hindi';
      case AppLanguage.telugu:
        return 'telugu';
      case AppLanguage.english:
        return 'english';
    }
  }

  // register user
  Future<void> register(AppUser user) async {
    users.add(user);
    await storage.saveUsers(users);
    notifyListeners();
  }

  // login method
  bool login(String uoe, String pass) {
    for (var u in users) {
      if ((u.username == uoe || u.email == uoe) && u.password == pass) {
        loggedIn = u;
        notifyListeners();
        return true;
      }
    }
    return false;
  }

  void logout() {
    loggedIn = null;
    notifyListeners();
  }

  Future<void> updatePassword(String newPass) async {
    if (loggedIn != null) {
      loggedIn!.password = newPass;
      await storage.saveUsers(users);
      notifyListeners();
    }
  }

  Future<void> setTheme(bool dark) async {
    isDark = dark;
    await storage.saveThemeIsDark(dark);
    notifyListeners();
  }

  Future<void> setLanguage(AppLanguage l) async {
    language = l;
    await storage.saveLang(_langKey(l));
    notifyListeners();
  }

  // trending
  Future<void> addSearch(String q) async {
    if (q.trim().isEmpty) return;
    searches.remove(q);
    searches.insert(0, q);
    if (searches.length > 20) searches = searches.sublist(0, 20);
    await storage.saveSearches(searches);
    notifyListeners();
  }
}
