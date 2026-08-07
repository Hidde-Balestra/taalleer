import 'package:flutter/material.dart';

import '../i18n.dart';
import '../language_course.dart';
import '../models.dart';
import '../stats.dart';
import '../theme.dart';
import '../utils.dart';
import '../widgets.dart';

/// Geaggregeerde blik op dezelfde data die het Resultaten-tabblad al toont.
class StatisticsScreen extends StatelessWidget {
  final Strings t;
  final Lang lang;
  final List<QuizResult> history;
  final LanguageCourse course;

  const StatisticsScreen({
    super.key,
    required this.t,
    required this.lang,
    required this.history,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final nl = lang == Lang.nl;
    final stats = computeStats(history, course);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                BackButtonCard(onTap: () => Navigator.of(context).pop()),
                const SizedBox(width: 12),
                Text(
                  t.statsTitle,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (history.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 64),
                child: Column(
                  children: [
                    const Text('📈', style: TextStyle(fontSize: 36)),
                    const SizedBox(height: 12),
                    Text(
                      t.statsEmpty,
                      style: TextStyle(fontSize: 14, color: palette.muted),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            else ...[
              Row(
                children: [
                  Expanded(
                    child: _StatTile(
                      value: '${stats.totalQuizzes}',
                      label: t.statsTotalQuizzes,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatTile(
                      value: stats.averageGrade.toStringAsFixed(1),
                      label: t.statsAverageGrade,
                      color: gradeColor(stats.averageGrade),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatTile(
                      value: stats.bestGrade.toStringAsFixed(1),
                      label: t.statsBestGrade,
                      color: gradeColor(stats.bestGrade),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.statsWeakWords,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (stats.weakWords.isEmpty)
                      Text(
                        t.statsWeakWordsEmpty,
                        style: TextStyle(fontSize: 13, color: palette.muted),
                      )
                    else
                      for (final w in stats.weakWords)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: w.target,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: palette.foreground,
                                  ),
                                ),
                                TextSpan(text: ' — ${w.nl}'),
                              ],
                            ),
                            style: TextStyle(
                              fontSize: 13,
                              color: palette.muted,
                            ),
                          ),
                        ),
                  ],
                ),
              ),
              if (stats.quizGrades.isNotEmpty) ...[
                const SizedBox(height: 16),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t.statsQuizGrades,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      for (final qg in stats.quizGrades)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  quizLabel(t, course, qg.quizId, nl),
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: palette.foreground,
                                  ),
                                ),
                              ),
                              Text(
                                qg.averageGrade.toStringAsFixed(1),
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: gradeColor(qg.averageGrade),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _StatTile({
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return AppCard(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: palette.muted),
          ),
        ],
      ),
    );
  }
}
