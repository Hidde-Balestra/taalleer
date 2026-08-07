import 'models.dart';

/// Alle UI-teksten van de app, per taal (NL/EN), overgenomen uit het prototype.
class Strings {
  // Onboarding
  final String onboardingTitle,
      onboardingSubtitle,
      onboardingLanguageQuestion,
      onboardingCourseQuestion,
      onboardingStart;
  // Navigatie
  final String navHome, navWords, navGrammar, navResults, navSettings;
  // Home
  final String homeWeek, homeWordsLearned, homeStreak, homeWeeks;
  final String homePractice, homePracticeSub, homeQuiz, homeQuizSub;
  final String homeConjQuiz, homeConjSub;
  final String homeQuizWeekend, homeLastGrade, homeNoResult;
  final String homeGreeting, homeSubGreeting;
  final String homeQuizDone, homePaused, homePausedSub;
  final String homeQuizNext, homeQuizOnce;
  final String homeWeakWords, homeWeakWordsCount;
  // Reset van de week
  final String resetTitle, resetTomorrow, resetInDays;
  // Eerdere woorden
  final String pastTitle, pastSubtitle, pastEmpty, pastWords, pastOpen;
  // Vervoegingstoets
  final String conjTitle, conjInstruction;
  // Grammatica
  final String grammarTitle,
      grammarSubtitle,
      grammarEmpty,
      grammarRuleSingular,
      grammarRulePlural;
  // Thema's
  final String themesTitle,
      themesSubtitle,
      themesWordSingular,
      themesWordPlural,
      themesQuizButton,
      themesQuizDoneThisWeek;
  // Woordenlijst
  final String vocabTitle,
      vocabWeek,
      vocabSearch,
      vocabPronunciation,
      vocabExample,
      vocabConjugation,
      vocabPastTense,
      vocabFutureTense,
      vocabGerundio,
      vocabArticle;
  // Oefenen
  final String practiceTitle, practiceToEs, practiceToNl, practiceToEn;
  final String practicePlaceholder, practiceCheck, practiceNext;
  final String practiceCorrect, practiceIncorrect, practiceCorrectAnswer;
  final String practiceSummary, practiceScore, practiceBackHome;
  // Luisteroefening
  final String listeningPracticeTitle, listeningPracticeInstruction;
  final String homeListeningPractice, homeListeningPracticeSub;
  // Oefenvormen-overzicht
  final String practiceHubTitle, practiceHubSubtitle;
  // Zinnen bouwen
  final String sentenceBuilderTitle,
      sentenceBuilderSub,
      sentenceBuilderInstruction;
  // Zinsvertaling
  final String sentenceTranslationTitle,
      sentenceTranslationSub,
      sentenceTranslationInstruction;
  // Meerkeuze / luister-en-kies
  final String multipleChoiceTitle, multipleChoiceSub;
  final String listeningChoiceTitle, listeningChoiceSub;
  // Geheugenspel
  final String memoryGameTitle,
      memoryGameSub,
      memoryGameWin,
      memoryGameTriesCount;
  // Invuloefening
  final String clozeTitle, clozeSub, clozeInstructionText;
  // Dagelijkse mini-sessie
  final String dailyMiniTitle, dailyMiniSub;
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
  final String resultShare, shareResultText;
  // Historie
  final String historyTitle, historyWeek, historyNoResults;
  // Prestaties
  final String achievementsTitle, achievementsSubtitle, achievementsProgress;
  final String achievementsLocked;
  // Statistieken
  final String statsTitle, statsEmpty;
  final String statsTotalQuizzes, statsAverageGrade, statsBestGrade;
  final String statsWeakWords, statsWeakWordsEmpty;
  final String statsCategoryGrades;
  // Instellingen
  final String settingsTitle, settingsLanguage, settingsDarkMode;
  final String settingsLight, settingsDark, settingsSystem;
  final String settingsDyslexia,
      settingsDyslexiaDesc,
      settingsDyslexiaActiveNote;
  final String settingsSourceLang, settingsDutch, settingsEnglish;
  final String settingsCourse;
  final String settingsPause, settingsPauseDesc, settingsPauseActiveNote;
  final String settingsReminder, settingsReminderDesc, settingsReminderTime;
  final String reminderNotificationTitle, reminderNotificationBody;
  // Uitspraak
  final String ttsUnavailable;
  // Updates
  final String updatesTitle,
      updatesCurrentVersion,
      updatesChecking,
      updatesUpToDate,
      updatesAvailable,
      updatesFailed,
      updatesCheckNow,
      updatesViewRelease;

  const Strings({
    required this.onboardingTitle,
    required this.onboardingSubtitle,
    required this.onboardingLanguageQuestion,
    required this.onboardingCourseQuestion,
    required this.onboardingStart,
    required this.navHome,
    required this.navWords,
    required this.navGrammar,
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
    required this.homeQuizNext,
    required this.homeQuizOnce,
    required this.homeWeakWords,
    required this.homeWeakWordsCount,
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
    required this.grammarTitle,
    required this.grammarSubtitle,
    required this.grammarEmpty,
    required this.grammarRuleSingular,
    required this.grammarRulePlural,
    required this.themesTitle,
    required this.themesSubtitle,
    required this.themesWordSingular,
    required this.themesWordPlural,
    required this.themesQuizButton,
    required this.themesQuizDoneThisWeek,
    required this.vocabTitle,
    required this.vocabWeek,
    required this.vocabSearch,
    required this.vocabPronunciation,
    required this.vocabExample,
    required this.vocabConjugation,
    required this.vocabPastTense,
    required this.vocabFutureTense,
    required this.vocabGerundio,
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
    required this.listeningPracticeTitle,
    required this.listeningPracticeInstruction,
    required this.homeListeningPractice,
    required this.homeListeningPracticeSub,
    required this.practiceHubTitle,
    required this.practiceHubSubtitle,
    required this.sentenceBuilderTitle,
    required this.sentenceBuilderSub,
    required this.sentenceBuilderInstruction,
    required this.sentenceTranslationTitle,
    required this.sentenceTranslationSub,
    required this.sentenceTranslationInstruction,
    required this.multipleChoiceTitle,
    required this.multipleChoiceSub,
    required this.listeningChoiceTitle,
    required this.listeningChoiceSub,
    required this.memoryGameTitle,
    required this.memoryGameSub,
    required this.memoryGameWin,
    required this.memoryGameTriesCount,
    required this.clozeTitle,
    required this.clozeSub,
    required this.clozeInstructionText,
    required this.dailyMiniTitle,
    required this.dailyMiniSub,
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
    required this.resultShare,
    required this.shareResultText,
    required this.historyTitle,
    required this.historyWeek,
    required this.historyNoResults,
    required this.achievementsTitle,
    required this.achievementsSubtitle,
    required this.achievementsProgress,
    required this.achievementsLocked,
    required this.statsTitle,
    required this.statsEmpty,
    required this.statsTotalQuizzes,
    required this.statsAverageGrade,
    required this.statsBestGrade,
    required this.statsWeakWords,
    required this.statsWeakWordsEmpty,
    required this.statsCategoryGrades,
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
    required this.settingsCourse,
    required this.settingsPause,
    required this.settingsPauseDesc,
    required this.settingsPauseActiveNote,
    required this.settingsReminder,
    required this.settingsReminderDesc,
    required this.settingsReminderTime,
    required this.reminderNotificationTitle,
    required this.reminderNotificationBody,
    required this.ttsUnavailable,
    required this.updatesTitle,
    required this.updatesCurrentVersion,
    required this.updatesChecking,
    required this.updatesUpToDate,
    required this.updatesAvailable,
    required this.updatesFailed,
    required this.updatesCheckNow,
    required this.updatesViewRelease,
  });

  static Strings of(Lang lang) => lang == Lang.nl ? nl : en;

  static const nl = Strings(
    onboardingTitle: 'Welkom bij TaalLeer',
    onboardingSubtitle:
        'Kies je taal om te beginnen — dit kun je later altijd wijzigen.',
    onboardingLanguageQuestion: 'Welke taal spreek je?',
    onboardingCourseQuestion: 'Welke taal wil je leren?',
    onboardingStart: 'Beginnen',
    navHome: 'Huis',
    navWords: 'Woorden',
    navGrammar: 'Grammatica',
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
    homeQuizDone: 'Toets van deze week afgerond ✓',
    homePaused: 'Streak gepauzeerd',
    homePausedSub: 'Schakel de pauze uit om toetsen te maken',
    homeQuizNext: 'Volgende toets',
    homeQuizOnce: 'Je maakt één toets per week — kies er één.',
    homeWeakWords: 'Zwakke woorden oefenen',
    homeWeakWordsCount: '{n} woorden waar je vaker fout op zat',
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
    grammarTitle: 'Grammatica',
    grammarSubtitle: 'De belangrijkste regels, per onderwerp',
    grammarEmpty: 'Nog geen grammaticaregels beschikbaar voor deze taal.',
    grammarRuleSingular: 'regel',
    grammarRulePlural: 'regels',
    themesTitle: "Thema's",
    themesSubtitle: 'Woorden per onderwerp doorbladeren',
    themesWordSingular: 'woord',
    themesWordPlural: 'woorden',
    themesQuizButton: 'Toets maken',
    themesQuizDoneThisWeek: 'Deze week al gedaan',
    vocabTitle: 'Woordenlijst',
    vocabWeek: 'Week',
    vocabSearch: 'Zoeken…',
    vocabPronunciation: 'Uitspraak',
    vocabExample: 'Voorbeeld',
    vocabConjugation: 'Tegenwoordige tijd',
    vocabPastTense: 'Verleden tijd',
    vocabFutureTense: 'Toekomende tijd',
    vocabGerundio: 'Gerundio',
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
    listeningPracticeTitle: 'Luisteroefening',
    listeningPracticeInstruction: 'Luister en typ de vertaling',
    homeListeningPractice: 'Luisteroefening',
    homeListeningPracticeSub: 'Hoor het woord, typ de vertaling',
    practiceHubTitle: 'Oefenvormen',
    practiceHubSubtitle: 'Kies hoe je wilt oefenen',
    sentenceBuilderTitle: 'Zinnen bouwen',
    sentenceBuilderSub: 'Leg de woorden in de juiste volgorde',
    sentenceBuilderInstruction: 'Bouw de zin die hoort bij:',
    sentenceTranslationTitle: 'Zinsvertaling',
    sentenceTranslationSub: 'Vertaal een hele zin naar het Nederlands',
    sentenceTranslationInstruction: 'Vertaal deze zin naar het Nederlands',
    multipleChoiceTitle: 'Meerkeuze',
    multipleChoiceSub: 'Kies het juiste antwoord uit 4 opties',
    listeningChoiceTitle: 'Luister-en-kies',
    listeningChoiceSub: 'Hoor het woord, kies de juiste vertaling',
    memoryGameTitle: 'Geheugenspel',
    memoryGameSub: 'Zoek de bijpassende paren',
    memoryGameWin: 'Alle paren gevonden! 🎉',
    memoryGameTriesCount: '{n} beurten',
    clozeTitle: 'Invuloefening',
    clozeSub: 'Vul het werkwoord in de juiste vorm in',
    clozeInstructionText: 'Vervoeg "{verb}" in de juiste vorm',
    dailyMiniTitle: 'Dagelijkse mini-sessie',
    dailyMiniSub: '5 nieuwe woorden uit het hele boek',
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
    resultShare: 'Delen',
    shareResultText:
        'Ik haalde een {grade} op mijn TaalLeer-toets — {correct}/{total} goed! 🎉',
    historyTitle: 'Resultaten',
    historyWeek: 'Week',
    historyNoResults: 'Nog geen resultaten beschikbaar.',
    achievementsTitle: 'Prestaties',
    achievementsSubtitle: 'Badges die je onderweg verdient',
    achievementsProgress: '{n} van {total} behaald',
    achievementsLocked: 'Nog niet behaald',
    statsTitle: 'Statistieken',
    statsEmpty: 'Nog geen statistieken — maak eerst een toets.',
    statsTotalQuizzes: 'Toetsen gemaakt',
    statsAverageGrade: 'Gemiddeld cijfer',
    statsBestGrade: 'Beste cijfer',
    statsWeakWords: 'Vaakst foute woorden',
    statsWeakWordsEmpty: 'Nog geen woorden om te herhalen — goed bezig!',
    statsCategoryGrades: 'Cijfer per categorie',
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
    settingsCourse: 'Taal die je leert',
    settingsPause: 'Streak pauzeren',
    settingsPauseDesc: 'Geen toetsen; je streak blijft bevroren staan',
    settingsPauseActiveNote:
        'Actief: je kunt geen toetsen maken en je streak staat stil totdat je de pauze uitschakelt.',
    settingsReminder: 'Dagelijkse herinnering',
    settingsReminderDesc: 'Een melding om te oefenen',
    settingsReminderTime: 'Tijdstip',
    reminderNotificationTitle: 'Tijd om te oefenen! 📚',
    reminderNotificationBody: 'Neem vandaag even de tijd voor je Spaans.',
    ttsUnavailable:
        'Geen tekst-naar-spraak beschikbaar op dit toestel. Installeer een '
        'open-source spraak-engine zoals eSpeak NG (via F-Droid, zonder '
        'Google Play) en kies die bij Instellingen > Toegankelijkheid > '
        'Tekst-naar-spraak.',
    updatesTitle: 'Updates',
    updatesCurrentVersion: 'Versie {v}',
    updatesChecking: 'Bezig met controleren…',
    updatesUpToDate: 'Je gebruikt de nieuwste versie',
    updatesAvailable: 'Update beschikbaar: v{v}',
    updatesFailed: 'Controleren op updates mislukt',
    updatesCheckNow: 'Nu controleren',
    updatesViewRelease: 'Bekijk release',
  );

  static const en = Strings(
    onboardingTitle: 'Welcome to TaalLeer',
    onboardingSubtitle:
        'Choose your language to get started — you can always change this later.',
    onboardingLanguageQuestion: 'Which language do you speak?',
    onboardingCourseQuestion: 'Which language do you want to learn?',
    onboardingStart: 'Get started',
    navHome: 'Home',
    navWords: 'Words',
    navGrammar: 'Grammar',
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
    homeQuizDone: 'This week\'s quiz completed ✓',
    homePaused: 'Streak paused',
    homePausedSub: 'Turn off pause to take quizzes',
    homeQuizNext: 'Next quiz',
    homeQuizOnce: 'You take one quiz per week — pick one.',
    homeWeakWords: 'Practice weak words',
    homeWeakWordsCount: '{n} words you often got wrong',
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
    grammarTitle: 'Grammar',
    grammarSubtitle: 'The key rules, by topic',
    grammarEmpty: 'No grammar rules available yet for this language.',
    grammarRuleSingular: 'rule',
    grammarRulePlural: 'rules',
    themesTitle: 'Themes',
    themesSubtitle: 'Browse words by topic',
    themesWordSingular: 'word',
    themesWordPlural: 'words',
    themesQuizButton: 'Take quiz',
    themesQuizDoneThisWeek: 'Already done this week',
    vocabTitle: 'Word List',
    vocabWeek: 'Week',
    vocabSearch: 'Search…',
    vocabPronunciation: 'Pronunciation',
    vocabExample: 'Example',
    vocabConjugation: 'Present tense',
    vocabPastTense: 'Past tense',
    vocabFutureTense: 'Future tense',
    vocabGerundio: 'Gerund',
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
    listeningPracticeTitle: 'Listening practice',
    listeningPracticeInstruction: 'Listen and type the translation',
    homeListeningPractice: 'Listening practice',
    homeListeningPracticeSub: 'Hear the word, type the translation',
    practiceHubTitle: 'Practice modes',
    practiceHubSubtitle: 'Choose how you want to practice',
    sentenceBuilderTitle: 'Sentence builder',
    sentenceBuilderSub: 'Put the words in the right order',
    sentenceBuilderInstruction: 'Build the sentence for:',
    sentenceTranslationTitle: 'Sentence translation',
    sentenceTranslationSub: 'Translate a whole sentence into Dutch',
    sentenceTranslationInstruction: 'Translate this sentence into Dutch',
    multipleChoiceTitle: 'Multiple choice',
    multipleChoiceSub: 'Pick the right answer from 4 options',
    listeningChoiceTitle: 'Listen and choose',
    listeningChoiceSub: 'Hear the word, choose the right translation',
    memoryGameTitle: 'Memory game',
    memoryGameSub: 'Find the matching pairs',
    memoryGameWin: 'All pairs found! 🎉',
    memoryGameTriesCount: '{n} tries',
    clozeTitle: 'Fill in the blank',
    clozeSub: 'Fill in the verb in the right form',
    clozeInstructionText: 'Conjugate "{verb}" in the right form',
    dailyMiniTitle: 'Daily mini session',
    dailyMiniSub: '5 new words from the whole book',
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
    resultShare: 'Share',
    shareResultText:
        'I scored a {grade} on my TaalLeer quiz — {correct}/{total} correct! 🎉',
    historyTitle: 'Results',
    historyWeek: 'Week',
    historyNoResults: 'No results available yet.',
    achievementsTitle: 'Achievements',
    achievementsSubtitle: 'Badges you earn along the way',
    achievementsProgress: '{n} of {total} unlocked',
    achievementsLocked: 'Not unlocked yet',
    statsTitle: 'Statistics',
    statsEmpty: 'No statistics yet — take a quiz first.',
    statsTotalQuizzes: 'Quizzes taken',
    statsAverageGrade: 'Average grade',
    statsBestGrade: 'Best grade',
    statsWeakWords: 'Most often wrong',
    statsWeakWordsEmpty: 'No words to review yet — nice work!',
    statsCategoryGrades: 'Grade per category',
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
    settingsCourse: 'Language you are learning',
    settingsPause: 'Pause streak',
    settingsPauseDesc: 'No quizzes; your streak stays frozen',
    settingsPauseActiveNote:
        'Active: you cannot take quizzes and your streak is frozen until you turn off pause.',
    settingsReminder: 'Daily reminder',
    settingsReminderDesc: 'A notification to practise',
    settingsReminderTime: 'Time',
    reminderNotificationTitle: 'Time to practise! 📚',
    reminderNotificationBody: 'Take a moment for your Spanish today.',
    ttsUnavailable:
        'Text-to-speech isn\'t available on this device. Install an '
        'open-source speech engine such as eSpeak NG (via F-Droid, no '
        'Google Play needed) and select it under Settings > Accessibility > '
        'Text-to-speech output.',
    updatesTitle: 'Updates',
    updatesCurrentVersion: 'Version {v}',
    updatesChecking: 'Checking for updates…',
    updatesUpToDate: 'You are on the latest version',
    updatesAvailable: 'Update available: v{v}',
    updatesFailed: 'Could not check for updates',
    updatesCheckNow: 'Check now',
    updatesViewRelease: 'View release',
  );

  /// "morgen" of "over N dagen".
  String resetWhen(int days) =>
      days <= 1 ? resetTomorrow : resetInDays.replaceFirst('{d}', '$days');

  /// "1 regel" of "N regels".
  String grammarRuleCount(int n) =>
      '$n ${n == 1 ? grammarRuleSingular : grammarRulePlural}';

  /// "1 woord" of "N woorden".
  String themesWordCount(int n) =>
      '$n ${n == 1 ? themesWordSingular : themesWordPlural}';

  /// "12 woorden waar je vaker fout op zat".
  String homeWeakWordsSub(int n) =>
      homeWeakWordsCount.replaceFirst('{n}', '$n');

  /// "7 beurten".
  String memoryGameTries(int n) =>
      memoryGameTriesCount.replaceFirst('{n}', '$n');

  /// 'Vervoeg "comer" in de juiste vorm'.
  String clozeInstruction(String verb) =>
      clozeInstructionText.replaceFirst('{verb}', verb);

  /// "3 van 8 behaald".
  String achievementsProgressLabel(int unlocked, int total) =>
      achievementsProgress
          .replaceFirst('{n}', '$unlocked')
          .replaceFirst('{total}', '$total');

  /// "Versie 1.9.0".
  String currentVersionLabel(String v) =>
      updatesCurrentVersion.replaceFirst('{v}', v);

  /// "Update beschikbaar: v1.9.0".
  String updateAvailableLabel(String v) =>
      updatesAvailable.replaceFirst('{v}', v);

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
