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

  const Word({
    required this.id,
    required this.es,
    required this.nl,
    required this.en,
    required this.pronunciation,
    required this.exampleEs,
    required this.exampleNl,
  });
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
}

class Question {
  final Word word;
  final QuestionType type;

  const Question({required this.word, required this.type});
}
