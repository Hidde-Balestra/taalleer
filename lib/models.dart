// Datamodellen voor TaalLeer.

enum Lang { nl, en }

enum DarkModeSetting { light, dark, system }

enum QuestionType { nlEs, enEs, esNl, esEn }

class Word {
  final int id;
  final String es;
  final String nl;
  final String en;
  final String pronunciation;
  final String exampleEs;
  final String exampleNl;

  /// Lidwoord van een zelfstandig naamwoord: 'el', 'la' of '' (geen).
  final String article;

  /// Tegenwoordige tijd (presente de indicativo) van een werkwoord: de 6
  /// persoonsvormen, of leeg als het geen werkwoord is.
  final List<String> present;

  const Word({
    required this.id,
    required this.es,
    required this.nl,
    required this.en,
    required this.pronunciation,
    this.exampleEs = '',
    this.exampleNl = '',
    this.article = '',
    this.present = const [],
  });

  bool get isNoun => article.isNotEmpty;
  bool get isVerb => present.isNotEmpty;
}

class AppSettings {
  final Lang language;
  final DarkModeSetting darkMode;
  final bool dyslexiaMode;
  final Lang sourceLang;

  const AppSettings({
    this.language = Lang.nl,
    this.darkMode = DarkModeSetting.system,
    this.dyslexiaMode = false,
    this.sourceLang = Lang.nl,
  });

  AppSettings copyWith({
    Lang? language,
    DarkModeSetting? darkMode,
    bool? dyslexiaMode,
    Lang? sourceLang,
  }) {
    return AppSettings(
      language: language ?? this.language,
      darkMode: darkMode ?? this.darkMode,
      dyslexiaMode: dyslexiaMode ?? this.dyslexiaMode,
      sourceLang: sourceLang ?? this.sourceLang,
    );
  }

  Map<String, dynamic> toJson() => {
    'language': language.name,
    'darkMode': darkMode.name,
    'dyslexiaMode': dyslexiaMode,
    'sourceLang': sourceLang.name,
  };

  factory AppSettings.fromJson(Map<String, dynamic> json) => AppSettings(
    language: Lang.values.asNameMap()[json['language']] ?? Lang.nl,
    darkMode:
        DarkModeSetting.values.asNameMap()[json['darkMode']] ??
        DarkModeSetting.system,
    dyslexiaMode: json['dyslexiaMode'] as bool? ?? false,
    sourceLang: Lang.values.asNameMap()[json['sourceLang']] ?? Lang.nl,
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

  const QuizResult({
    required this.id,
    required this.weekNumber,
    required this.year,
    required this.date,
    required this.grade,
    required this.correct,
    required this.total,
    required this.wrongWordIds,
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
  );
}

class Question {
  final Word word;
  final QuestionType type;

  const Question({required this.word, required this.type});
}
