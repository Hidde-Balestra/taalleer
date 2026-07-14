import 'package:flutter/material.dart';

import 'app_state.dart';
import 'i18n.dart';
import 'models.dart';
import 'screens/history_screen.dart';
import 'screens/home_screen.dart';
import 'screens/practice_screen.dart';
import 'screens/quiz_result_screen.dart';
import 'screens/quiz_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/vocabulary_screen.dart';
import 'theme.dart';
import 'utils.dart';

void main() {
  runApp(TaalLeerApp(appState: AppState()));
}

class TaalLeerApp extends StatelessWidget {
  final AppState appState;

  const TaalLeerApp({super.key, required this.appState});

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
          home: HomeShell(appState: appState),
        );
      },
    );
  }
}

/// Hoofd-scaffold met de vier tabbladen en onderste navigatiebalk.
class HomeShell extends StatefulWidget {
  final AppState appState;

  const HomeShell({super.key, required this.appState});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _tab = 0;

  // In het prototype is de toets alleen in het weekend beschikbaar;
  // net als daar staat hij hier voor de demo altijd aan.
  bool get _quizAvailable => true; // isWeekend(DateTime.now())

  void _openPractice(Strings t, AppSettings settings) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PracticeScreen(
          t: t,
          dyslexia: settings.dyslexiaMode,
          sourceLang: settings.sourceLang,
        ),
      ),
    );
  }

  void _openQuiz(Strings t, AppSettings settings) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => QuizScreen(
          t: t,
          dyslexia: settings.dyslexiaMode,
          sourceLang: settings.sourceLang,
          weekNumber: currentWeekNumber(),
          onFinish: (result) {
            widget.appState.addResult(result);
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => QuizResultScreen(t: t, result: result),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final settings = widget.appState.settings;
    final t = Strings.of(settings.language);
    final weekNumber = currentWeekNumber();

    final tabs = [
      HomeScreen(
        t: t,
        lang: settings.language,
        weekNumber: weekNumber,
        streak: widget.appState.streak,
        history: widget.appState.history,
        quizAvailable: _quizAvailable,
        onPractice: () => _openPractice(t, settings),
        onQuiz: () => _openQuiz(t, settings),
      ),
      VocabularyScreen(t: t, weekNumber: weekNumber),
      HistoryScreen(t: t, history: widget.appState.history),
      SettingsScreen(
        t: t,
        settings: settings,
        onChanged: widget.appState.updateSettings,
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
        icon: Icons.bar_chart_outlined,
        activeIcon: Icons.bar_chart,
        label: t.navResults,
      ),
      (
        icon: Icons.settings_outlined,
        activeIcon: Icons.settings,
        label: t.navSettings,
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: IndexedStack(index: _tab, children: tabs),
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
