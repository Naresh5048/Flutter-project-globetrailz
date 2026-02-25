// lib/services/storage_service.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class StorageService {
  static const _usersKey = 'gt_users';
  static const _themeKey = 'gt_theme'; // 'light' or 'dark'
  static const _langKey = 'gt_lang';
  static const _lastSearchesKey = 'gt_trending';

  Future<void> saveUsers(List<AppUser> users) async {
    final prefs = await SharedPreferences.getInstance();
    final list = users.map((u) => jsonEncode(u.toMap())).toList();
    await prefs.setStringList(_usersKey, list);
  }

  Future<List<AppUser>> loadUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_usersKey) ?? [];
    return list.map((s) => AppUser.fromMap(jsonDecode(s))).toList();
  }

  Future<void> saveThemeIsDark(bool dark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, dark);
  }

  Future<bool> loadThemeIsDark() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_themeKey) ?? false;
  }

  Future<void> saveLang(String langKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_langKey, langKey);
  }

  Future<String> loadLang() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_langKey) ?? 'english';
  }

  Future<void> saveSearches(List<String> searches) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_lastSearchesKey, searches);
  }

  Future<List<String>> loadSearches() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_lastSearchesKey) ?? [];
  }
}
