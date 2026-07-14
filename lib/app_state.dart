import 'package:flutter/foundation.dart';

import 'models.dart';
import 'storage.dart';

/// Centrale app-state: instellingen en toetshistorie.
/// Alle wijzigingen worden direct lokaal op het apparaat opgeslagen.
class AppState extends ChangeNotifier {
  final AppStorage _storage;
  AppSettings _settings;
  final List<QuizResult> _history;

  AppState({
    AppStorage? storage,
    AppSettings settings = const AppSettings(),
    List<QuizResult> history = const [],
  }) : _storage = storage ?? AppStorage(),
       _settings = settings,
       _history = [...history];

  /// Laadt de opgeslagen instellingen en historie van het apparaat.
  static Future<AppState> load({AppStorage? storage}) async {
    final s = storage ?? AppStorage();
    return AppState(
      storage: s,
      settings: await s.loadSettings(),
      history: await s.loadHistory(),
    );
  }

  AppSettings get settings => _settings;
  List<QuizResult> get history => List.unmodifiable(_history);
  int get streak => _history.length;

  void updateSettings(AppSettings settings) {
    _settings = settings;
    notifyListeners();
    _storage.saveSettings(settings);
  }

  void addResult(QuizResult result) {
    _history.insert(0, result);
    notifyListeners();
    _storage.saveHistory(_history);
  }
}
