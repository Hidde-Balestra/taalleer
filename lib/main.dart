import 'package:flutter/material.dart';

import 'app_state.dart';
import 'data.dart';
import 'home_widget_service.dart';
import 'i18n.dart';
import 'language_course.dart';
import 'languages/registry.dart';
import 'models.dart';
import 'notifications.dart';
import 'screens/achievements_screen.dart';
import 'screens/conjugation_quiz_screen.dart';
import 'screens/grammar_screen.dart';
import 'screens/history_screen.dart';
import 'screens/home_screen.dart';
import 'screens/listening_practice_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/past_words_screen.dart';
import 'screens/practice_screen.dart';
import 'screens/quiz_result_screen.dart';
import 'screens/quiz_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/themes_screen.dart';
import 'screens/vocabulary_screen.dart';
import 'theme.dart';
import 'update_service.dart';
import 'utils.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appState = await AppState.load();
  // Herbevestigt de geplande herinnering bij elke app-start (idempotent) —
  // zo overleeft die ook een her-installatie zonder dat de gebruiker de
  // instelling opnieuw hoeft aan te zetten.
  if (appState.settings.dailyReminder) {
    notificationService.scheduleDailyReminder(
      hour: appState.settings.reminderHour,
      title: Strings.of(appState.settings.language).reminderNotificationTitle,
      body: Strings.of(appState.settings.language).reminderNotificationBody,
    );
  }
  // Startscherm-widget: eenmaal bij het opstarten en daarna bij elke
  // wijziging in de streak (bv. na een toets) — een no-op als de gebruiker
  // geen widget aan zijn startscherm heeft toegevoegd.
  updateHomeWidget(appState);
  appState.addListener(() => updateHomeWidget(appState));
  runApp(TaalLeerApp(appState: appState));
}

class TaalLeerApp extends StatelessWidget {
  final AppState appState;

  /// Optioneel injecteerbaar voor tests; standaard een echte [UpdateService].
  final UpdateService? updateService;

  const TaalLeerApp({super.key, required this.appState, this.updateService});

  ThemeMode _themeMode(DarkModeSetting mode) {
    switch (mode) {
      case DarkModeSetting.light:
        return ThemeMode.light;
      case DarkModeSetting.dark:
        return ThemeMode.dark;
      case DarkModeSetting.system:
        return ThemeMode.system;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        final settings = appState.settings;
        return MaterialApp(
          title: 'TaalLeer',
          debugShowCheckedModeBanner: false,
          themeMode: _themeMode(settings.darkMode),
          theme: buildTheme(
            brightness: Brightness.light,
            dyslexiaMode: settings.dyslexiaMode,
          ),
          darkTheme: buildTheme(
            brightness: Brightness.dark,
            dyslexiaMode: settings.dyslexiaMode,
          ),
          home: settings.onboardingComplete
              ? HomeShell(appState: appState, updateService: updateService)
              : OnboardingScreen(
                  onComplete: (language, courseId) => appState.updateSettings(
                    settings.copyWith(
                      language: language,
                      sourceLang: language,
                      courseId: courseId,
                      onboardingComplete: true,
                    ),
                  ),
                ),
        );
      },
    );
  }
}

/// Hoofd-scaffold met de tabbladen en onderste navigatiebalk.
class HomeShell extends StatefulWidget {
  final AppState appState;
  final UpdateService? updateService;

  const HomeShell({super.key, required this.appState, this.updateService});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _tab = 0;

  void _openPractice(
    Strings t,
    AppSettings settings,
    LanguageCourse course,
    List<Word> words,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PracticeScreen(
          t: t,
          dyslexia: settings.dyslexiaMode,
          sourceLang: settings.sourceLang,
          course: course,
          words: words,
        ),
      ),
    );
  }

  void _openListeningPractice(
    Strings t,
    AppSettings settings,
    LanguageCourse course,
    List<Word> words,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ListeningPracticeScreen(
          t: t,
          dyslexia: settings.dyslexiaMode,
          sourceLang: settings.sourceLang,
          course: course,
          words: words,
        ),
      ),
    );
  }

  void _openQuiz(
    Strings t,
    AppSettings settings,
    LanguageCourse course,
    List<Word> words,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => QuizScreen(
          t: t,
          dyslexia: settings.dyslexiaMode,
          sourceLang: settings.sourceLang,
          weekNumber: currentWeekNumber(),
          words: words,
          onFinish: _finishQuiz(t, course),
        ),
      ),
    );
  }

  void _openConjQuiz(Strings t, AppSettings settings, LanguageCourse course) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ConjugationQuizScreen(
          t: t,
          dyslexia: settings.dyslexiaMode,
          weekNumber: currentWeekNumber(),
          course: course,
          verbs: course.words,
          onFinish: _finishQuiz(t, course),
        ),
      ),
    );
  }

  void _openPastWords(Strings t, AppSettings settings, LanguageCourse course) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PastWordsScreen(
          t: t,
          lang: settings.language,
          course: course,
          weekSeeds: widget.appState.pastWeekSeeds,
        ),
      ),
    );
  }

  void _openAchievements() {
    Navigator.of(context).push(
      MaterialPageRoute(
        // Zelfde reden als bij Instellingen: moet meeluisteren met live
        // history/streak, anders bevriest de voortgang op het moment van
        // openen.
        builder: (_) => ListenableBuilder(
          listenable: widget.appState,
          builder: (context, _) {
            final settings = widget.appState.settings;
            return AchievementsScreen(
              t: Strings.of(settings.language),
              nl: settings.language == Lang.nl,
              history: widget.appState.history,
              streak: widget.appState.streak,
            );
          },
        ),
      ),
    );
  }

  void _openThemes(Strings t, AppSettings settings, LanguageCourse course) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            ThemesScreen(t: t, lang: settings.language, course: course),
      ),
    );
  }

  void _openSettings() {
    Navigator.of(context).push(
      MaterialPageRoute(
        // Instellingen blijft, eenmaal gepusht, meeluisteren met appState:
        // zonder deze ListenableBuilder zou het scherm blijven werken met
        // de settings/paused-waarden van het moment van pushen, waardoor
        // opeenvolgende wijzigingen (bv. eerst donkere modus, dan dyslexie)
        // elkaar zouden overschrijven op basis van verouderde data.
        builder: (_) => ListenableBuilder(
          listenable: widget.appState,
          builder: (context, _) {
            final settings = widget.appState.settings;
            return SettingsScreen(
              t: Strings.of(settings.language),
              settings: settings,
              onChanged: widget.appState.updateSettings,
              paused: widget.appState.paused,
              onPausedChanged: widget.appState.setPaused,
              updateService: widget.updateService,
            );
          },
        ),
      ),
    );
  }

  ValueChanged<QuizResult> _finishQuiz(Strings t, LanguageCourse course) =>
      (result) {
        widget.appState.addResult(result);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) =>
                QuizResultScreen(t: t, course: course, result: result),
          ),
        );
      };

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final settings = widget.appState.settings;
    final t = Strings.of(settings.language);
    final course = courseById(settings.courseId);
    final weekNumber = currentWeekNumber();
    // De 20 woorden van deze week worden willekeurig getrokken, maar
    // deterministisch per kalenderweek (niet-herhalend over de jaren heen).
    final weekWords = wordsForWeek(course, currentWeekSeed());
    final weak = weakWords(widget.appState.history, course);

    final tabs = [
      HomeScreen(
        t: t,
        lang: settings.language,
        weekNumber: weekNumber,
        streak: widget.appState.streak,
        wordCount: weekWords.length,
        history: widget.appState.history,
        paused: widget.appState.paused,
        quizDoneThisWeek: widget.appState.quizDoneThisWeek,
        weakWordCount: weak.length,
        onPractice: () => _openPractice(t, settings, course, weekWords),
        onQuiz: () => _openQuiz(t, settings, course, weekWords),
        onConjQuiz: () => _openConjQuiz(t, settings, course),
        onPracticeWeakWords: () => _openPractice(t, settings, course, weak),
        onListeningPractice: () =>
            _openListeningPractice(t, settings, course, weekWords),
      ),
      VocabularyScreen(
        t: t,
        lang: settings.language,
        course: course,
        weekNumber: weekNumber,
        words: weekWords,
        onOpenPast: () => _openPastWords(t, settings, course),
        onOpenThemes: () => _openThemes(t, settings, course),
      ),
      GrammarScreen(t: t, lang: settings.language, course: course),
      HistoryScreen(
        t: t,
        history: widget.appState.history,
        streak: widget.appState.streak,
        course: course,
      ),
    ];

    final navItems = [
      (icon: Icons.home_outlined, activeIcon: Icons.home, label: t.navHome),
      (
        icon: Icons.menu_book_outlined,
        activeIcon: Icons.menu_book,
        label: t.navWords,
      ),
      (
        icon: Icons.school_outlined,
        activeIcon: Icons.school,
        label: t.navGrammar,
      ),
      (
        icon: Icons.bar_chart_outlined,
        activeIcon: Icons.bar_chart,
        label: t.navResults,
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Vast tandwiel-icoon, zichtbaar op elk tabblad — Instellingen
            // zat eerst in de onderbalk, maar die werd daarmee te druk.
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: _openAchievements,
                    icon: const Icon(Icons.emoji_events_outlined),
                    tooltip: t.achievementsTitle,
                    color: palette.muted,
                  ),
                  IconButton(
                    onPressed: _openSettings,
                    icon: const Icon(Icons.settings_outlined),
                    tooltip: t.navSettings,
                    color: palette.muted,
                  ),
                ],
              ),
            ),
            Expanded(
              child: IndexedStack(index: _tab, children: tabs),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: palette.card,
          border: Border(top: BorderSide(color: palette.border)),
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              for (var i = 0; i < navItems.length; i++)
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _tab = i),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 6),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: _tab == i
                                  ? AppColors.primary.withValues(alpha: 0.1)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              _tab == i
                                  ? navItems[i].activeIcon
                                  : navItems[i].icon,
                              size: 20,
                              color: _tab == i
                                  ? AppColors.primary
                                  : palette.muted,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            navItems[i].label,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: _tab == i
                                  ? AppColors.primary
                                  : palette.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
