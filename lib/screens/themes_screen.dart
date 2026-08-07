import 'package:flutter/material.dart';

import '../i18n.dart';
import '../language_course.dart';
import '../languages/es/es_categories.dart';
import '../models.dart';
import '../theme.dart';
import '../utils.dart';
import '../widgets.dart';
import 'vocabulary_screen.dart';

/// Top-level lijst van thema's — zelfde `_CategoryCard`-patroon als het
/// grammaticascherm — waarmee je woorden per onderwerp kan doorbladeren
/// i.p.v. per weeknummer, en per thema een eigen toets kan maken (los
/// vergrendeld van de algemene toets en van andere thema's).
class ThemesScreen extends StatelessWidget {
  final Strings t;
  final Lang lang;
  final LanguageCourse course;
  final List<QuizResult> history;
  final bool Function(String categoryId) categoryQuizAllowed;
  final void Function(String categoryId) onStartQuiz;

  const ThemesScreen({
    super.key,
    required this.t,
    required this.lang,
    required this.course,
    required this.history,
    required this.categoryQuizAllowed,
    required this.onStartQuiz,
  });

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final nl = lang == Lang.nl;
    final words = course.words;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Row(
                children: [
                  BackButtonCard(onTap: () => Navigator.of(context).pop()),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t.themesTitle,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          t.themesSubtitle,
                          style: TextStyle(fontSize: 12, color: palette.muted),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                itemCount: kWordCategories.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (context, i) {
                  final category = kWordCategories[i];
                  final categoryWords = words
                      .where((w) => w.category == category.id)
                      .toList();
                  return _ThemeCard(
                    t: t,
                    nl: nl,
                    title: category.title(nl),
                    icon: category.icon,
                    count: categoryWords.length,
                    quizAllowed:
                        categoryWords.isNotEmpty &&
                        categoryQuizAllowed(category.id),
                    lastResult: lastResultForCategory(history, category.id),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ThemeWordsScreen(
                          t: t,
                          course: course,
                          title: category.title(nl),
                          words: categoryWords,
                        ),
                      ),
                    ),
                    onStartQuiz: () => onStartQuiz(category.id),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeCard extends StatelessWidget {
  final Strings t;
  final bool nl;
  final String title;
  final IconData icon;
  final int count;
  final bool quizAllowed;
  final QuizResult? lastResult;
  final VoidCallback onTap;
  final VoidCallback onStartQuiz;

  const _ThemeCard({
    required this.t,
    required this.nl,
    required this.title,
    required this.icon,
    required this.count,
    required this.quizAllowed,
    required this.lastResult,
    required this.onTap,
    required this.onStartQuiz,
  });

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, size: 18, color: AppColors.primary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          t.themesWordCount(count),
                          style: TextStyle(fontSize: 12, color: palette.muted),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right, size: 16, color: palette.muted),
                ],
              ),
            ),
          ),
          if (count > 0) ...[
            Divider(height: 1, color: palette.border),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
              child: quizAllowed
                  ? Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: onStartQuiz,
                        borderRadius: BorderRadius.circular(10),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.quiz_outlined,
                              size: 16,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              t.themesQuizButton,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 16,
                          color: gradeColor(lastResult?.grade ?? 0),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            t.themesQuizDoneThisWeek,
                            style: TextStyle(
                              fontSize: 12,
                              color: palette.muted,
                            ),
                          ),
                        ),
                        if (lastResult != null)
                          Text(
                            lastResult!.grade.toStringAsFixed(1),
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: gradeColor(lastResult!.grade),
                            ),
                          ),
                      ],
                    ),
            ),
          ],
        ],
      ),
    );
  }
}

/// De woorden binnen één thema, met dezelfde uitklapbare kaarten als de
/// gewone woordenlijst.
class ThemeWordsScreen extends StatefulWidget {
  final Strings t;
  final LanguageCourse course;
  final String title;
  final List<Word> words;

  const ThemeWordsScreen({
    super.key,
    required this.t,
    required this.course,
    required this.title,
    required this.words,
  });

  @override
  State<ThemeWordsScreen> createState() => _ThemeWordsScreenState();
}

class _ThemeWordsScreenState extends State<ThemeWordsScreen> {
  int? _expandedId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Row(
                children: [
                  BackButtonCard(onTap: () => Navigator.of(context).pop()),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                itemCount: widget.words.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (context, i) {
                  final word = widget.words[i];
                  return WordCard(
                    t: widget.t,
                    word: word,
                    course: widget.course,
                    index: i + 1,
                    expanded: _expandedId == word.id,
                    onTap: () => setState(
                      () =>
                          _expandedId = _expandedId == word.id ? null : word.id,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
