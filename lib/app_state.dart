import 'package:flutter/foundation.dart';

import 'data.dart';
import 'models.dart';
import 'storage.dart';

/// Centrale app-state: instellingen, toetshistorie en de wekelijkse streak.
/// Alle wijzigingen worden direct lokaal op het apparaat opgeslagen.
class AppState extends ChangeNotifier {
  final AppStorage _storage;
  final int Function() _nowWeek;
  AppSettings _settings;
  final List<QuizResult> _history;
  StreakState _streakState;

  AppState({
    AppStorage? storage,
    int Function()? nowWeek,
    AppSettings settings = const AppSettings(),
    List<QuizResult> history = const [],
    StreakState streakState = const StreakState(),
  }) : _storage = storage ?? AppStorage(),
       _nowWeek = nowWeek ?? currentWeekSeed,
       _settings = settings,
       _history = [...history],
       _streakState = streakState;

  /// Laadt de opgeslagen staat van het apparaat.
  static Future<AppState> load({
    AppStorage? storage,
    int Function()? nowWeek,
  }) async {
    final s = storage ?? AppStorage();
    final state = AppState(
      storage: s,
      nowWeek: nowWeek,
      settings: await s.loadSettings(),
      history: await s.loadHistory(),
      streakState: await s.loadStreak(),
    );
    state._ensureFirstWeek();
    return state;
  }

  /// Legt bij het eerste gebruik vast in welke week de gebruiker begon.
  void _ensureFirstWeek() {
    if (_streakState.firstWeek != null) return;
    _streakState = _streakState.copyWith(firstWeek: _nowWeek());
    _storage.saveStreak(_streakState);
  }

  /// De weken die de gebruiker al heeft gehad (nieuwste eerst), zonder de
  /// huidige week. Leeg voor een gebruiker die pas deze week begonnen is.
  List<int> get pastWeekSeeds {
    final first = _streakState.firstWeek;
    if (first == null) return const [];
    final current = _nowWeek();
    return [for (var s = current - 1; s >= first; s--) s];
  }

  AppSettings get settings => _settings;
  List<QuizResult> get history => List.unmodifiable(_history);

  /// De "effectieve" week: de echte weekteller minus de tijd die in pauze is
  /// doorgebracht, zodat pauzes de streak niet breken.
  int _effectiveWeek() {
    final real = _nowWeek();
    var offset = _streakState.pauseOffset;
    final since = _streakState.pauseSince;
    if (_streakState.paused && since != null) offset += real - since;
    return real - offset;
  }

  /// De huidige streak in weken. Als er een hele week is gemist (zonder
  /// pauze), is de streak verlopen en is dit 0. Telt elke afgeronde toets
  /// mee — algemeen of een categorietoets, welke dan ook.
  int get streak {
    final last = _streakState.lastActivityWeek;
    if (last == null) return 0;
    return _effectiveWeek() <= last + 1 ? _streakState.streak : 0;
  }

  bool get paused => _streakState.paused;

  /// Is deze week de **algemene** toets (Woordentoets/Vervoegingstoets) al
  /// afgerond?
  bool get quizDoneThisWeek {
    final last = _streakState.lastQuizWeek;
    return last != null && last == _effectiveWeek();
  }

  /// Mag de algemene toets nu gemaakt worden? Niet tijdens pauze, en
  /// hoogstens één keer per week: na een afgeronde toets is de volgende pas
  /// bij de wekelijkse reset weer beschikbaar. Onafhankelijk van
  /// categorietoetsen — die hebben hun eigen vergrendeling.
  bool get quizAllowed => !_streakState.paused && !quizDoneThisWeek;

  /// Is de toets voor [category] deze week al afgerond?
  bool categoryQuizDoneThisWeek(String category) {
    final last = _streakState.categoryLastQuizWeek[category];
    return last != null && last == _effectiveWeek();
  }

  /// Mag de toets voor [category] nu gemaakt worden? Zelfde regel als de
  /// algemene toets (niet tijdens pauze, hoogstens één keer per week), maar
  /// volledig onafhankelijk vergrendeld van de algemene toets en van andere
  /// categorieën.
  bool categoryQuizAllowed(String category) =>
      !_streakState.paused && !categoryQuizDoneThisWeek(category);

  void updateSettings(AppSettings settings) {
    _settings = settings;
    notifyListeners();
    _storage.saveSettings(settings);
  }

  /// Zet de streak-pauze aan of uit. Tijdens pauze staat de streak stil.
  void setPaused(bool value) {
    if (value == _streakState.paused) return;
    if (value) {
      _streakState = _streakState.copyWith(
        paused: true,
        pauseSince: _nowWeek(),
      );
    } else {
      final since = _streakState.pauseSince ?? _nowWeek();
      _streakState = _streakState.copyWith(
        paused: false,
        pauseOffset: _streakState.pauseOffset + (_nowWeek() - since),
        clearPauseSince: true,
      );
    }
    notifyListeners();
    _storage.saveStreak(_streakState);
  }

  /// Verwerkt een afgeronde toets: bewaart het resultaat en werkt de streak
  /// bij. Bij een lege `result.category` geldt de vergrendeling van de
  /// algemene toets (max. één per week); bij een categorietoets geldt de
  /// eigen, onafhankelijke vergrendeling van die categorie. In beide
  /// gevallen niet toegestaan tijdens pauze.
  void addResult(QuizResult result) {
    final category = result.category;
    final allowed = category.isEmpty
        ? quizAllowed
        : categoryQuizAllowed(category);
    if (!allowed) return;
    _history.insert(0, result);
    _updateStreakForCompletion(category: category.isEmpty ? null : category);
    notifyListeners();
    _storage.saveHistory(_history);
    _storage.saveStreak(_streakState);
  }

  void _updateStreakForCompletion({String? category}) {
    final w = _effectiveWeek();
    final last = _streakState.lastActivityWeek;
    final int newStreak;
    if (last == null) {
      newStreak = 1;
    } else if (w == last) {
      newStreak = _streakState.streak; // deze week al activiteit gehad
    } else if (w == last + 1) {
      newStreak = _streakState.streak + 1; // opvolgende week
    } else {
      newStreak = 1; // een week gemist
    }
    final categoryLastQuizWeek = Map<String, int>.of(
      _streakState.categoryLastQuizWeek,
    );
    if (category != null) categoryLastQuizWeek[category] = w;
    _streakState = _streakState.copyWith(
      streak: newStreak,
      lastActivityWeek: w,
      // Alleen de algemene toets (category == null) werkt lastQuizWeek bij —
      // die vergrendelt uitsluitend de algemene toets, niet de categorieën.
      lastQuizWeek: category == null ? w : _streakState.lastQuizWeek,
      categoryLastQuizWeek: categoryLastQuizWeek,
    );
  }
}
