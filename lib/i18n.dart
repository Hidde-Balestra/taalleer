import 'models.dart';

/// Alle UI-teksten van de app, per taal (NL/EN), overgenomen uit het prototype.
class Strings {
  // Navigatie
  final String navHome, navWords, navResults, navSettings;
  // Home
  final String homeWeek, homeWordsLearned, homeStreak, homeWeeks;
  final String homePractice, homePracticeSub, homeQuiz, homeQuizSub;
  final String homeConjQuiz, homeConjSub;
  final String homeQuizWeekend, homeLastGrade, homeNoResult;
  final String homeGreeting, homeSubGreeting;
  final String homeQuizDone, homePaused, homePausedSub;
  // Reset van de week
  final String resetTitle, resetTomorrow, resetInDays;
  // Eerdere woorden
  final String pastTitle, pastSubtitle, pastEmpty, pastWords, pastOpen;
  // Vervoegingstoets
  final String conjTitle, conjInstruction;
  // Woordenlijst
  final String vocabTitle,
      vocabWeek,
      vocabSearch,
      vocabPronunciation,
      vocabExample,
      vocabConjugation,
      vocabArticle;
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
  final String settingsPause, settingsPauseDesc, settingsPauseActiveNote;

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
    required this.homeConjQuiz,
    required this.homeConjSub,
    required this.homeQuizWeekend,
    required this.homeLastGrade,
    required this.homeNoResult,
    required this.homeGreeting,
    required this.homeSubGreeting,
    required this.homeQuizDone,
    required this.homePaused,
    required this.homePausedSub,
    required this.resetTitle,
    required this.resetTomorrow,
    required this.resetInDays,
    required this.pastTitle,
    required this.pastSubtitle,
    required this.pastEmpty,
    required this.pastWords,
    required this.pastOpen,
    required this.conjTitle,
    required this.conjInstruction,
    required this.vocabTitle,
    required this.vocabWeek,
    required this.vocabSearch,
    required this.vocabPronunciation,
    required this.vocabExample,
    required this.vocabConjugation,
    required this.vocabArticle,
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
    required this.settingsPause,
    required this.settingsPauseDesc,
    required this.settingsPauseActiveNote,
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
    homeQuiz: 'Woordentoets',
    homeQuizSub: '10 vragen · vertalen',
    homeConjQuiz: 'Vervoegingstoets',
    homeConjSub: '10 werkwoorden vervoegen',
    homeQuizWeekend: 'Beschikbaar in het weekend',
    homeLastGrade: 'Laatste cijfer',
    homeNoResult: 'Nog geen toets gemaakt',
    homeGreeting: 'Welkom terug! 👋',
    homeSubGreeting: 'Blijf oefenen, je bent goed bezig.',
    homeQuizDone: 'Deze week al afgerond ✓',
    homePaused: 'Streak gepauzeerd',
    homePausedSub: 'Schakel de pauze uit om toetsen te maken',
    resetTitle: 'Nieuwe woorden en toets',
    resetTomorrow: 'morgen',
    resetInDays: 'over {d} dagen',
    pastTitle: 'Eerdere woorden',
    pastSubtitle: 'Alle woorden die je eerder hebt gehad, per week',
    pastEmpty: 'Je bent deze week begonnen — er zijn nog geen eerdere weken.',
    pastWords: 'woorden',
    pastOpen: 'Eerdere weken',
    conjTitle: 'Vervoegingstoets',
    conjInstruction: 'Vervoeg in de tegenwoordige tijd',
    vocabTitle: 'Woordenlijst',
    vocabWeek: 'Week',
    vocabSearch: 'Zoeken…',
    vocabPronunciation: 'Uitspraak',
    vocabExample: 'Voorbeeld',
    vocabConjugation: 'Tegenwoordige tijd',
    vocabArticle: 'Lidwoord',
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
    settingsPause: 'Streak pauzeren',
    settingsPauseDesc: 'Geen toetsen; je streak blijft bevroren staan',
    settingsPauseActiveNote:
        'Actief: je kunt geen toetsen maken en je streak staat stil totdat je de pauze uitschakelt.',
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
    homeQuiz: 'Vocabulary Quiz',
    homeQuizSub: '10 questions · translation',
    homeConjQuiz: 'Conjugation Quiz',
    homeConjSub: '10 verbs to conjugate',
    homeQuizWeekend: 'Available on weekends',
    homeLastGrade: 'Last grade',
    homeNoResult: 'No quiz taken yet',
    homeGreeting: 'Welcome back! 👋',
    homeSubGreeting: 'Keep practicing, you are doing great.',
    homeQuizDone: 'Already done this week ✓',
    homePaused: 'Streak paused',
    homePausedSub: 'Turn off pause to take quizzes',
    resetTitle: 'New words and quiz',
    resetTomorrow: 'tomorrow',
    resetInDays: 'in {d} days',
    pastTitle: 'Previous words',
    pastSubtitle: 'All the words you had before, by week',
    pastEmpty: 'You started this week — there are no previous weeks yet.',
    pastWords: 'words',
    pastOpen: 'Previous weeks',
    conjTitle: 'Conjugation Quiz',
    conjInstruction: 'Conjugate in the present tense',
    vocabTitle: 'Word List',
    vocabWeek: 'Week',
    vocabSearch: 'Search…',
    vocabPronunciation: 'Pronunciation',
    vocabExample: 'Example',
    vocabConjugation: 'Present tense',
    vocabArticle: 'Article',
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
    settingsPause: 'Pause streak',
    settingsPauseDesc: 'No quizzes; your streak stays frozen',
    settingsPauseActiveNote:
        'Active: you cannot take quizzes and your streak is frozen until you turn off pause.',
  );

  /// "morgen" of "over N dagen".
  String resetWhen(int days) =>
      days <= 1 ? resetTomorrow : resetInDays.replaceFirst('{d}', '$days');

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
