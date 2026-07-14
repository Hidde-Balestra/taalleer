import 'models.dart';

/// Alle UI-teksten van de app, per taal (NL/EN), overgenomen uit het prototype.
class Strings {
  // Navigatie
  final String navHome, navWords, navResults, navSettings;
  // Home
  final String homeWeek, homeWordsLearned, homeStreak, homeWeeks;
  final String homePractice, homePracticeSub, homeQuiz, homeQuizSub;
  final String homeQuizWeekend, homeLastGrade, homeNoResult;
  final String homeGreeting, homeSubGreeting;
  // Woordenlijst
  final String vocabTitle,
      vocabWeek,
      vocabSearch,
      vocabPronunciation,
      vocabExample;
  // Oefenen
  final String practiceTitle, practiceToEs, practiceToNl, practiceToEn;
  final String practicePlaceholder, practiceCheck, practiceNext;
  final String practiceCorrect, practiceIncorrect, practiceCorrectAnswer;
  final String practiceSummary, practiceScore, practiceBackHome;
  // Toets
  final String quizTitle, quizPlaceholder, quizSubmit;
  final String quizDyslexiaActive, quizNoHints, quizProgress;
  // Resultaat
  final String resultTitle, resultGrade, resultCorrect, resultIncorrect;
  final String resultPass,
      resultFail,
      resultWrongWords,
      resultBackHome,
      resultWeek;
  // Historie
  final String historyTitle, historyWeek, historyNoResults;
  // Instellingen
  final String settingsTitle, settingsLanguage, settingsDarkMode;
  final String settingsLight, settingsDark, settingsSystem;
  final String settingsDyslexia,
      settingsDyslexiaDesc,
      settingsDyslexiaActiveNote;
  final String settingsSourceLang,
      settingsDutch,
      settingsEnglish,
      settingsVersion;

  const Strings({
    required this.navHome,
    required this.navWords,
    required this.navResults,
    required this.navSettings,
    required this.homeWeek,
    required this.homeWordsLearned,
    required this.homeStreak,
    required this.homeWeeks,
    required this.homePractice,
    required this.homePracticeSub,
    required this.homeQuiz,
    required this.homeQuizSub,
    required this.homeQuizWeekend,
    required this.homeLastGrade,
    required this.homeNoResult,
    required this.homeGreeting,
    required this.homeSubGreeting,
    required this.vocabTitle,
    required this.vocabWeek,
    required this.vocabSearch,
    required this.vocabPronunciation,
    required this.vocabExample,
    required this.practiceTitle,
    required this.practiceToEs,
    required this.practiceToNl,
    required this.practiceToEn,
    required this.practicePlaceholder,
    required this.practiceCheck,
    required this.practiceNext,
    required this.practiceCorrect,
    required this.practiceIncorrect,
    required this.practiceCorrectAnswer,
    required this.practiceSummary,
    required this.practiceScore,
    required this.practiceBackHome,
    required this.quizTitle,
    required this.quizPlaceholder,
    required this.quizSubmit,
    required this.quizDyslexiaActive,
    required this.quizNoHints,
    required this.quizProgress,
    required this.resultTitle,
    required this.resultGrade,
    required this.resultCorrect,
    required this.resultIncorrect,
    required this.resultPass,
    required this.resultFail,
    required this.resultWrongWords,
    required this.resultBackHome,
    required this.resultWeek,
    required this.historyTitle,
    required this.historyWeek,
    required this.historyNoResults,
    required this.settingsTitle,
    required this.settingsLanguage,
    required this.settingsDarkMode,
    required this.settingsLight,
    required this.settingsDark,
    required this.settingsSystem,
    required this.settingsDyslexia,
    required this.settingsDyslexiaDesc,
    required this.settingsDyslexiaActiveNote,
    required this.settingsSourceLang,
    required this.settingsDutch,
    required this.settingsEnglish,
    required this.settingsVersion,
  });

  static Strings of(Lang lang) => lang == Lang.nl ? nl : en;

  static const nl = Strings(
    navHome: 'Huis',
    navWords: 'Woorden',
    navResults: 'Resultaten',
    navSettings: 'Instellingen',
    homeWeek: 'Week',
    homeWordsLearned: 'Woorden geleerd',
    homeStreak: 'Streak',
    homeWeeks: 'weken',
    homePractice: 'Oefenen',
    homePracticeSub: 'Oefen de 20 woorden van deze week',
    homeQuiz: 'Toets starten',
    homeQuizSub: '10 vragen · weektoets',
    homeQuizWeekend: 'Beschikbaar in het weekend',
    homeLastGrade: 'Laatste cijfer',
    homeNoResult: 'Nog geen toets gemaakt',
    homeGreeting: 'Welkom terug! 👋',
    homeSubGreeting: 'Blijf oefenen, je bent goed bezig.',
    vocabTitle: 'Woordenlijst',
    vocabWeek: 'Week',
    vocabSearch: 'Zoeken…',
    vocabPronunciation: 'Uitspraak',
    vocabExample: 'Voorbeeld',
    practiceTitle: 'Oefenen',
    practiceToEs: 'Vertaal naar het Spaans',
    practiceToNl: 'Vertaal naar het Nederlands',
    practiceToEn: 'Vertaal naar het Engels',
    practicePlaceholder: 'Jouw antwoord…',
    practiceCheck: 'Controleren',
    practiceNext: 'Volgende →',
    practiceCorrect: 'Correct! 🎉',
    practiceIncorrect: 'Helaas!',
    practiceCorrectAnswer: 'Correct antwoord',
    practiceSummary: 'Oefensessie voltooid!',
    practiceScore: 'Score',
    practiceBackHome: 'Terug naar huis',
    quizTitle: 'Weektoets',
    quizPlaceholder: 'Jouw antwoord…',
    quizSubmit: 'Bevestigen →',
    quizDyslexiaActive: 'Dyslexie Modus Actief',
    quizNoHints: 'Geen hints beschikbaar',
    quizProgress: 'Vraag',
    resultTitle: 'Toetsresultaat',
    resultGrade: 'Cijfer',
    resultCorrect: 'Goed',
    resultIncorrect: 'Fout',
    resultPass: 'Geslaagd ✓',
    resultFail: 'Onvoldoende',
    resultWrongWords: 'Foute woorden',
    resultBackHome: 'Terug naar huis',
    resultWeek: 'Week',
    historyTitle: 'Resultaten',
    historyWeek: 'Week',
    historyNoResults: 'Nog geen resultaten beschikbaar.',
    settingsTitle: 'Instellingen',
    settingsLanguage: 'App-taal',
    settingsDarkMode: 'Weergave',
    settingsLight: 'Licht',
    settingsDark: 'Donker',
    settingsSystem: 'Systeem',
    settingsDyslexia: 'Dyslexie Modus',
    settingsDyslexiaDesc: 'Kleine typefouten worden geaccepteerd',
    settingsDyslexiaActiveNote:
        'Actief: kleine spelfouten worden geaccepteerd op basis van woordlengte.',
    settingsSourceLang: 'Brontaal',
    settingsDutch: 'Nederlands',
    settingsEnglish: 'Engels',
    settingsVersion: 'TaalLeer v1.0',
  );

  static const en = Strings(
    navHome: 'Home',
    navWords: 'Words',
    navResults: 'Results',
    navSettings: 'Settings',
    homeWeek: 'Week',
    homeWordsLearned: 'Words learned',
    homeStreak: 'Streak',
    homeWeeks: 'weeks',
    homePractice: 'Practice',
    homePracticeSub: 'Practice the 20 words of this week',
    homeQuiz: 'Start Quiz',
    homeQuizSub: '10 questions · weekly quiz',
    homeQuizWeekend: 'Available on weekends',
    homeLastGrade: 'Last grade',
    homeNoResult: 'No quiz taken yet',
    homeGreeting: 'Welcome back! 👋',
    homeSubGreeting: 'Keep practicing, you are doing great.',
    vocabTitle: 'Word List',
    vocabWeek: 'Week',
    vocabSearch: 'Search…',
    vocabPronunciation: 'Pronunciation',
    vocabExample: 'Example',
    practiceTitle: 'Practice',
    practiceToEs: 'Translate to Spanish',
    practiceToNl: 'Translate to Dutch',
    practiceToEn: 'Translate to English',
    practicePlaceholder: 'Your answer…',
    practiceCheck: 'Check',
    practiceNext: 'Next →',
    practiceCorrect: 'Correct! 🎉',
    practiceIncorrect: 'Incorrect!',
    practiceCorrectAnswer: 'Correct answer',
    practiceSummary: 'Practice session complete!',
    practiceScore: 'Score',
    practiceBackHome: 'Back to home',
    quizTitle: 'Weekly Quiz',
    quizPlaceholder: 'Your answer…',
    quizSubmit: 'Submit →',
    quizDyslexiaActive: 'Dyslexia Mode Active',
    quizNoHints: 'No hints available',
    quizProgress: 'Question',
    resultTitle: 'Quiz Results',
    resultGrade: 'Grade',
    resultCorrect: 'Correct',
    resultIncorrect: 'Incorrect',
    resultPass: 'Passed ✓',
    resultFail: 'Failed',
    resultWrongWords: 'Wrong words',
    resultBackHome: 'Back to home',
    resultWeek: 'Week',
    historyTitle: 'Results',
    historyWeek: 'Week',
    historyNoResults: 'No results available yet.',
    settingsTitle: 'Settings',
    settingsLanguage: 'App Language',
    settingsDarkMode: 'Appearance',
    settingsLight: 'Light',
    settingsDark: 'Dark',
    settingsSystem: 'System',
    settingsDyslexia: 'Dyslexia Mode',
    settingsDyslexiaDesc: 'Minor typos will be accepted',
    settingsDyslexiaActiveNote:
        'Active: minor typos are accepted based on word length.',
    settingsSourceLang: 'Source language',
    settingsDutch: 'Dutch',
    settingsEnglish: 'English',
    settingsVersion: 'TaalLeer v1.0',
  );

  /// Vraaglabel op basis van vraagtype.
  String questionLabel(QuestionType type) {
    switch (type) {
      case QuestionType.nlEs:
      case QuestionType.enEs:
        return practiceToEs;
      case QuestionType.esNl:
        return practiceToNl;
      case QuestionType.esEn:
        return practiceToEn;
    }
  }
}

const List<String> _weekdaysNl = [
  'maandag',
  'dinsdag',
  'woensdag',
  'donderdag',
  'vrijdag',
  'zaterdag',
  'zondag',
];
const List<String> _weekdaysEn = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];
const List<String> _monthsNl = [
  'januari',
  'februari',
  'maart',
  'april',
  'mei',
  'juni',
  'juli',
  'augustus',
  'september',
  'oktober',
  'november',
  'december',
];
const List<String> _monthsEn = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];
const List<String> monthsShortNl = [
  'jan',
  'feb',
  'mrt',
  'apr',
  'mei',
  'jun',
  'jul',
  'aug',
  'sep',
  'okt',
  'nov',
  'dec',
];

/// Bijv. "maandag 13 juli" / "Monday 13 July".
String formatDateLong(DateTime d, Lang lang) {
  final weekday = (lang == Lang.nl ? _weekdaysNl : _weekdaysEn)[d.weekday - 1];
  final month = (lang == Lang.nl ? _monthsNl : _monthsEn)[d.month - 1];
  return '$weekday ${d.day} $month';
}

/// Bijv. "12 jul 2026" (zoals in de historie van het prototype).
String formatDateShort(DateTime d) =>
    '${d.day} ${monthsShortNl[d.month - 1]} ${d.year}';
