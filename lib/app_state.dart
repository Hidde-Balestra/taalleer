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

  /// Is de toets [quizId] (`kWordQuizId`, `kConjugationQuizId`, of een
  /// thema-id) deze week al afgerond?
  bool quizDoneThisWeek(String quizId) {
    final last = _streakState.quizLastWeek[quizId];
    return last != null && last == _effectiveWeek();
  }

  /// Mag de toets [quizId] nu gemaakt worden? Niet tijdens pauze, en
  /// hoogstens één keer per week: na een afgeronde toets is de volgende pas
  /// bij de wekelijkse reset weer beschikbaar. Elke toets — algemeen of
  /// thema — is onafhankelijk vergrendeld van de andere.
  bool quizAllowed(String quizId) =>
      !_streakState.paused && !quizDoneThisWeek(quizId);

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
  /// bij. Elke toets (`result.quizId`) heeft zijn eigen, onafhankelijke
  /// wekelijkse vergrendeling; niet toegestaan tijdens pauze.
  void addResult(QuizResult result) {
    if (!quizAllowed(result.quizId)) return;
    _history.insert(0, result);
    _updateStreakForCompletion(result.quizId);
    notifyListeners();
    _storage.saveHistory(_history);
    _storage.saveStreak(_streakState);
  }

  void _updateStreakForCompletion(String quizId) {
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
    final quizLastWeek = Map<String, int>.of(_streakState.quizLastWeek);
    quizLastWeek[quizId] = w;
    _streakState = _streakState.copyWith(
      streak: newStreak,
      lastActivityWeek: w,
      quizLastWeek: quizLastWeek,
    );
  }
}
