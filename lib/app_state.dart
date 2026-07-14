import 'package:flutter/foundation.dart';

import 'data.dart';
import 'models.dart';

/// Centrale app-state: instellingen en toetshistorie.
class AppState extends ChangeNotifier {
  AppSettings _settings = const AppSettings();
  final List<QuizResult> _history = [...kMockHistory];

  AppSettings get settings => _settings;
  List<QuizResult> get history => List.unmodifiable(_history);
  int get streak => _history.length;

  void updateSettings(AppSettings settings) {
    _settings = settings;
    notifyListeners();
  }

  void addResult(QuizResult result) {
    _history.insert(0, result);
    notifyListeners();
  }
}
