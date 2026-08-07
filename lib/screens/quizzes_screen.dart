import 'package:flutter/material.dart';

import '../i18n.dart';
import '../language_course.dart';
import '../languages/es/es_categories.dart';
import '../models.dart';
import '../theme.dart';
import '../utils.dart';
import '../widgets.dart';

/// Overzicht van alle toetsen op één scherm: de algemene Woordentoets en
/// Vervoegingstoets, plus per thema een categorietoets. Elke toets heeft
/// zijn eigen, onafhankelijke wekelijkse vergrendeling (zie
/// `AppState.quizAllowed`) — dit scherm toont per toets of hij deze week al
/// gedaan is (met het cijfer) of nog beschikbaar is. Nieuwe toetsen komen
/// gewoon als extra kaart in dezelfde lijst.
class QuizzesScreen extends StatelessWidget {
  final Strings t;
  final Lang lang;
  final LanguageCourse course;
  final List<QuizResult> history;
  final bool paused;
  final bool Function(String quizId) quizAllowed;
  final VoidCallback onWordQuiz;
  final VoidCallback onConjugationQuiz;
  final void Function(String categoryId) onCategoryQuiz;

  const QuizzesScreen({
    super.key,
    required this.t,
    required this.lang,
    required this.course,
    required this.history,
    required this.paused,
    required this.quizAllowed,
    required this.onWordQuiz,
    required this.onConjugationQuiz,
    required this.onCategoryQuiz,
  });

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final nl = lang == Lang.nl;
    final words = course.words;

    final entries = [
      (
        quizId: kWordQuizId,
        icon: Icons.emoji_events_outlined,
        title: t.homeQuiz,
        subtitle: t.homeQuizSub,
        onTap: onWordQuiz,
      ),
      (
        quizId: kConjugationQuizId,
        icon: Icons.spellcheck,
        title: t.homeConjQuiz,
        subtitle: t.homeConjSub,
        onTap: onConjugationQuiz,
      ),
      for (final category in kWordCategories)
        if (words.any((w) => w.category == category.id))
          (
            quizId: category.id,
            icon: category.icon,
            title: category.title(nl),
            subtitle: t.themesWordCount(
              words.where((w) => w.category == category.id).length,
            ),
            onTap: () => onCategoryQuiz(category.id),
          ),
    ];

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
                          t.quizzesTitle,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          t.quizzesSubtitle,
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
                itemCount: entries.length + (paused ? 1 : 0),
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (context, i) {
                  if (paused) {
                    if (i == 0) return _PausedBanner(t: t);
                    i -= 1;
                  }
                  final entry = entries[i];
                  return _QuizCard(
                    icon: entry.icon,
                    title: entry.title,
                    subtitle: entry.subtitle,
                    allowed: !paused && quizAllowed(entry.quizId),
                    lastResult: lastResultForQuiz(history, entry.quizId),
                    onTap: entry.onTap,
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

class _PausedBanner extends StatelessWidget {
  final Strings t;

  const _PausedBanner({required this.t});

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return Opacity(
      opacity: 0.7,
      child: AppCard(
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: palette.border,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.pause_circle_outline,
                size: 20,
                color: palette.muted,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t.homePaused,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    t.homePausedSub,
                    style: TextStyle(fontSize: 12, color: palette.muted),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuizCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool allowed;
  final QuizResult? lastResult;
  final VoidCallback onTap;

  const _QuizCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.allowed,
    required this.lastResult,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return AppCard(
      padding: EdgeInsets.zero,
      child: InkWell(
        onTap: allowed ? onTap : null,
        borderRadius: BorderRadius.circular(16),
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
                      subtitle,
                      style: TextStyle(fontSize: 12, color: palette.muted),
                    ),
                  ],
                ),
              ),
              if (allowed)
                Icon(Icons.chevron_right, size: 16, color: palette.muted)
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      size: 16,
                      color: AppColors.green,
                    ),
                    if (lastResult != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        lastResult!.grade.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: gradeColor(lastResult!.grade),
                        ),
                      ),
                    ],
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
