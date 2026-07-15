import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'models.dart';

/// Slaat instellingen en toetshistorie lokaal op het apparaat op
/// (via `shared_preferences`; er verlaat geen data het apparaat).
class AppStorage {
  static const settingsKey = 'taalleer.settings';
  static const historyKey = 'taalleer.history';
  static const streakKey = 'taalleer.streak';

  Future<AppSettings> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(settingsKey);
    if (raw == null) return const AppSettings();
    try {
      return AppSettings.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } on FormatException {
      return const AppSettings();
    }
  }

  Future<void> saveSettings(AppSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(settingsKey, jsonEncode(settings.toJson()));
  }

  Future<List<QuizResult>> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(historyKey);
    if (raw == null) return [];
    try {
      return (jsonDecode(raw) as List)
          .map((e) => QuizResult.fromJson(e as Map<String, dynamic>))
          .toList();
    } on FormatException {
      return [];
    }
  }

  Future<void> saveHistory(List<QuizResult> history) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      historyKey,
      jsonEncode(history.map((r) => r.toJson()).toList()),
    );
  }

  Future<StreakState> loadStreak() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(streakKey);
    if (raw == null) return const StreakState();
    try {
      return StreakState.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } on FormatException {
      return const StreakState();
    }
  }

  Future<void> saveStreak(StreakState streak) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(streakKey, jsonEncode(streak.toJson()));
  }
}
