// Datamodellen voor TaalLeer.

/// Vaste id's voor de twee algemene toetsen (naast de per-thema
/// categorietoetsen, waarvan het thema-id zelf als quiz-id dient) — elke
/// toets, algemeen of thema, heeft zijn eigen onafhankelijke wekelijkse
/// vergrendeling (zie `AppState.quizAllowed`).
const String kWordQuizId = 'word';
const String kConjugationQuizId = 'conjugation';

enum Lang { nl, en }

enum DarkModeSetting { light, dark, system }

enum QuestionType { nlEs, enEs, esNl, esEn }

class Word {
  final int id;

  /// Het woord in de taal die geleerd wordt (bijv. Spaans).
  final String target;
  final String nl;
  final String en;
  final String pronunciation;
  final String exampleTarget;
  final String exampleNl;

  /// Lidwoord van een zelfstandig naamwoord: 'el', 'la' of '' (geen).
  final String article;

  /// Tegenwoordige tijd (presente de indicativo) van een werkwoord: de 6
  /// persoonsvormen, of leeg als het geen werkwoord is.
  final List<String> present;

  /// Verleden tijd (pretérito indefinido) van een werkwoord: de 6
  /// persoonsvormen, of leeg als het geen werkwoord is of de taal geen
  /// (enkelvoudige) verleden tijd kent.
  final List<String> past;

  /// Toekomende tijd (futuro simple) van een werkwoord: de 6 persoonsvormen,
  /// of leeg als het geen werkwoord is of de taal geen (enkelvoudige)
  /// toekomende tijd kent.
  final List<String> future;

  /// Gerundio (bv. "hablando"): één vorm, of leeg als het geen werkwoord is
  /// of de taal geen gerundio kent.
  final String gerundio;

  /// Thema/categorie (bv. "eten"), of leeg als het woord niet in een van de
  /// gedefinieerde thema's valt.
  final String category;

  /// Extra correcte spellingen voor [nl]/[en] naast de primaire vertaling
  /// (bv. "kado" naast "cadeau") — worden alleen bij het nakijken van een
  /// antwoord meegeteld, niet getoond (overal waar het woord getoond wordt
  /// blijft [nl]/[en] de enige/primaire spelling).
  final List<String> nlVariants;
  final List<String> enVariants;

  const Word({
    required this.id,
    required this.target,
    required this.nl,
    required this.en,
    required this.pronunciation,
    this.exampleTarget = '',
    this.exampleNl = '',
    this.article = '',
    this.present = const [],
    this.past = const [],
    this.future = const [],
    this.gerundio = '',
    this.category = '',
    this.nlVariants = const [],
    this.enVariants = const [],
  });

  bool get isNoun => article.isNotEmpty;
  bool get isVerb => present.isNotEmpty;
}

class AppSettings {
  final Lang language;
  final DarkModeSetting darkMode;
  final bool dyslexiaMode;
  final Lang sourceLang;

  /// Id van de taal die geleerd wordt (zie `kCourses` in
  /// `languages/registry.dart`), bijv. 'es' voor Spaans.
  final String courseId;

  /// Heeft de gebruiker het onboarding-scherm (app-taal + cursuskeuze)
  /// doorlopen? Zolang dit `false` is, toont de app dat scherm i.p.v. het
  /// home-scherm.
  final bool onboardingComplete;

  /// Dagelijkse oefenherinnering aan/uit (standaard uit — opt-in, want dit
  /// vraagt notificatiepermissie).
  final bool dailyReminder;

  /// Uur van de dag (0-23) waarop de herinnering afgaat.
  final int reminderHour;

  /// Tekstgrootte-schaal voor het lezen van verhalen (1.0 = standaard),
  /// aanpasbaar voor slechtziende gebruikers.
  final double storyTextScale;

  const AppSettings({
    this.language = Lang.en,
    this.darkMode = DarkModeSetting.system,
    this.dyslexiaMode = false,
    this.sourceLang = Lang.nl,
    this.courseId = 'es',
    this.onboardingComplete = false,
    this.dailyReminder = false,
    this.reminderHour = 19,
    this.storyTextScale = 1.0,
  });

  AppSettings copyWith({
    Lang? language,
    DarkModeSetting? darkMode,
    bool? dyslexiaMode,
    Lang? sourceLang,
    String? courseId,
    bool? onboardingComplete,
    bool? dailyReminder,
    int? reminderHour,
    double? storyTextScale,
  }) {
    return AppSettings(
      language: language ?? this.language,
      darkMode: darkMode ?? this.darkMode,
      dyslexiaMode: dyslexiaMode ?? this.dyslexiaMode,
      sourceLang: sourceLang ?? this.sourceLang,
      courseId: courseId ?? this.courseId,
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
      dailyReminder: dailyReminder ?? this.dailyReminder,
      reminderHour: reminderHour ?? this.reminderHour,
      storyTextScale: storyTextScale ?? this.storyTextScale,
    );
  }

  Map<String, dynamic> toJson() => {
    'language': language.name,
    'darkMode': darkMode.name,
    'dyslexiaMode': dyslexiaMode,
    'sourceLang': sourceLang.name,
    'courseId': courseId,
    'onboardingComplete': onboardingComplete,
    'dailyReminder': dailyReminder,
    'reminderHour': reminderHour,
    'storyTextScale': storyTextScale,
  };

  factory AppSettings.fromJson(Map<String, dynamic> json) => AppSettings(
    language: Lang.values.asNameMap()[json['language']] ?? Lang.en,
    darkMode:
        DarkModeSetting.values.asNameMap()[json['darkMode']] ??
        DarkModeSetting.system,
    dyslexiaMode: json['dyslexiaMode'] as bool? ?? false,
    sourceLang: Lang.values.asNameMap()[json['sourceLang']] ?? Lang.nl,
    courseId: json['courseId'] as String? ?? 'es',
    onboardingComplete: json['onboardingComplete'] as bool? ?? false,
    dailyReminder: json['dailyReminder'] as bool? ?? false,
    reminderHour: json['reminderHour'] as int? ?? 19,
    storyTextScale: (json['storyTextScale'] as num?)?.toDouble() ?? 1.0,
  );
}

class QuizResult {
  final int id;
  final int weekNumber;
  final int year;
  final String date;
  final double grade;
  final int correct;
  final int total;
  final List<int> wrongWordIds;

  /// Welke toets dit is: `kWordQuizId`, `kConjugationQuizId`, of een
  /// thema-id (zie `kWordCategories`) voor een categorietoets. `''` komt
  /// alleen nog voor bij historische data van vóór losse toets-id's — die
  /// kon toen niet worden onderscheiden.
  final String quizId;

  const QuizResult({
    required this.id,
    required this.weekNumber,
    required this.year,
    required this.date,
    required this.grade,
    required this.correct,
    required this.total,
    required this.wrongWordIds,
    this.quizId = '',
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'weekNumber': weekNumber,
    'year': year,
    'date': date,
    'grade': grade,
    'correct': correct,
    'total': total,
    'wrongWordIds': wrongWordIds,
    // JSON-sleutel bewust 'category' gehouden (i.p.v. 'quizId') zodat al
    // opgeslagen historie op het apparaat leesbaar blijft.
    'category': quizId,
  };

  factory QuizResult.fromJson(Map<String, dynamic> json) => QuizResult(
    id: json['id'] as int,
    weekNumber: json['weekNumber'] as int,
    year: json['year'] as int,
    date: json['date'] as String,
    grade: (json['grade'] as num).toDouble(),
    correct: json['correct'] as int,
    total: json['total'] as int,
    wrongWordIds: (json['wrongWordIds'] as List).cast<int>(),
    quizId: json['category'] as String? ?? '',
  );
}

class Question {
  final Word word;
  final QuestionType type;

  const Question({required this.word, required this.type});
}

/// Een meerkeuzevraag: [question] plus 4 opties (het juiste antwoord en 3
/// afleiders), al geschud.
class MultipleChoiceQuestion {
  final Question question;
  final List<String> options;

  const MultipleChoiceQuestion({required this.question, required this.options});
}

/// Eén tegel in het geheugenspel: [isTarget] onderscheidt de doeltaal-kant
/// (bv. Spaans) van de vertaal-kant van hetzelfde woord, zodat een paar
/// altijd uit precies één van elk bestaat.
class MemoryTile {
  final int id;
  final Word word;
  final String text;
  final bool isTarget;

  const MemoryTile({
    required this.id,
    required this.word,
    required this.text,
    required this.isTarget,
  });
}

/// Eén vraag in de "zinnen bouwen"-oefening: de tegels van [word.exampleTarget]
/// door elkaar ([shuffledTokens]), plus de juiste volgorde om tegen te
/// controleren ([correctTokens]).
class SentenceBuildQuestion {
  final Word word;
  final List<String> correctTokens;
  final List<String> shuffledTokens;

  const SentenceBuildQuestion({
    required this.word,
    required this.correctTokens,
    required this.shuffledTokens,
  });
}

/// Eén zin voor de invuloefening: een sjabloon met een weggelaten vervoegde
/// vorm van een werkwoord. Het verwachte antwoord wordt niet apart
/// opgeslagen — dat is `word.present[person]`, al aanwezig via de bestaande
/// vervoeging.
class ClozeEntry {
  final String sentenceTemplate;
  final String translationNl;
  final int person;

  const ClozeEntry({
    required this.sentenceTemplate,
    required this.translationNl,
    required this.person,
  });
}

/// Een vraag in de vervoegingstoets: vervoeg [word] voor persoon [person]
/// (0..5, zie `kPronouns`).
class ConjugationQuestion {
  final Word word;
  final int person;

  const ConjugationQuestion({required this.word, required this.person});

  /// Het verwachte antwoord (de vervoegde vorm).
  String get answer => word.present[person];
}

/// De wekelijkse streak-staat. De streak blijft in stand zolang er per week
/// minstens één toets is afgerond — welke dan ook: de algemene toets of een
/// categorietoets. Met [paused] wordt de streak bevroren: er kunnen dan geen
/// toetsen worden gemaakt en de streak kan niet omhoog of gereset worden.
///
/// [lastQuizWeek], [lastActivityWeek], [pauseSince] en [pauseOffset] worden
/// uitgedrukt in "effectieve" weken (zie `AppState`): de echte weekteller
/// minus de tijd die in pauze is doorgebracht.
class StreakState {
  final int streak;

  /// Verouderd: vroegere gedeelde vergrendeling van de algemene toets, vóór
  /// elke toets zijn eigen id kreeg. Alleen nog gelezen als migratiebron in
  /// [fromJson] (zie [quizLastWeek]); de app schrijft er niet meer naar.
  final int? lastQuizWeek;

  /// Laatste effectieve week waarin *welke toets dan ook* is afgerond —
  /// welke dan ook. Drijft de streak.
  final int? lastActivityWeek;

  /// Per toets-id (`kWordQuizId`, `kConjugationQuizId`, of een thema-id) de
  /// laatste effectieve week waarin die toets is afgerond — elke toets
  /// heeft zijn eigen, onafhankelijke wekelijkse vergrendeling.
  final Map<String, int> quizLastWeek;

  final bool paused;
  final int pauseOffset;
  final int? pauseSince;

  /// De echte weekteller waarin de app voor het eerst is gebruikt; bepaalt
  /// vanaf welke week er "eerdere woorden" te tonen zijn.
  final int? firstWeek;

  const StreakState({
    this.streak = 0,
    this.lastQuizWeek,
    this.lastActivityWeek,
    this.quizLastWeek = const {},
    this.paused = false,
    this.pauseOffset = 0,
    this.pauseSince,
    this.firstWeek,
  });

  StreakState copyWith({
    int? streak,
    int? lastQuizWeek,
    bool clearLastQuizWeek = false,
    int? lastActivityWeek,
    Map<String, int>? quizLastWeek,
    bool? paused,
    int? pauseOffset,
    int? pauseSince,
    bool clearPauseSince = false,
    int? firstWeek,
  }) {
    return StreakState(
      streak: streak ?? this.streak,
      lastQuizWeek: clearLastQuizWeek
          ? null
          : (lastQuizWeek ?? this.lastQuizWeek),
      lastActivityWeek: lastActivityWeek ?? this.lastActivityWeek,
      quizLastWeek: quizLastWeek ?? this.quizLastWeek,
      paused: paused ?? this.paused,
      pauseOffset: pauseOffset ?? this.pauseOffset,
      pauseSince: clearPauseSince ? null : (pauseSince ?? this.pauseSince),
      firstWeek: firstWeek ?? this.firstWeek,
    );
  }

  Map<String, dynamic> toJson() => {
    'streak': streak,
    'lastQuizWeek': lastQuizWeek,
    'lastActivityWeek': lastActivityWeek,
    // JSON-sleutel bewust 'categoryLastQuizWeek' gehouden (i.p.v.
    // 'quizLastWeek') zodat al opgeslagen data leesbaar blijft.
    'categoryLastQuizWeek': quizLastWeek,
    'paused': paused,
    'pauseOffset': pauseOffset,
    'pauseSince': pauseSince,
    'firstWeek': firstWeek,
  };

  factory StreakState.fromJson(Map<String, dynamic> json) {
    final storedQuizLastWeek =
        (json['categoryLastQuizWeek'] as Map?)?.map(
          (k, v) => MapEntry(k as String, v as int),
        ) ??
        const <String, int>{};
    final legacyLastQuizWeek = json['lastQuizWeek'] as int?;
    return StreakState(
      streak: json['streak'] as int? ?? 0,
      lastQuizWeek: legacyLastQuizWeek,
      // Bestaande, al opgeslagen streaks hebben geen lastActivityWeek —
      // zonder deze fallback op de oude lastQuizWeek zou hun lopende streak
      // bij het inladen ineens verloren lijken.
      lastActivityWeek: json['lastActivityWeek'] as int? ?? legacyLastQuizWeek,
      // Draagt de oude gedeelde vergrendeling eenmalig over naar de twee
      // algemene toetsen, zodat iemand die deze week al de gedeelde toets
      // deed niet ineens allebei opnieuw mag maken in de overgangsweek.
      quizLastWeek: {
        ...storedQuizLastWeek,
        if (legacyLastQuizWeek != null &&
            !storedQuizLastWeek.containsKey(kWordQuizId))
          kWordQuizId: legacyLastQuizWeek,
        if (legacyLastQuizWeek != null &&
            !storedQuizLastWeek.containsKey(kConjugationQuizId))
          kConjugationQuizId: legacyLastQuizWeek,
      },
      paused: json['paused'] as bool? ?? false,
      pauseOffset: json['pauseOffset'] as int? ?? 0,
      pauseSince: json['pauseSince'] as int?,
      firstWeek: json['firstWeek'] as int?,
    );
  }
}
