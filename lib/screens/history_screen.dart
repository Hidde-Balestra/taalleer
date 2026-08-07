import 'package:flutter/material.dart';

import '../i18n.dart';
import '../language_course.dart';
import '../models.dart';
import '../theme.dart';
import '../utils.dart';
import '../widgets.dart';
import 'statistics_screen.dart';

class HistoryScreen extends StatelessWidget {
  final Strings t;
  final Lang lang;
  final List<QuizResult> history;
  final int streak;
  final LanguageCourse course;

  const HistoryScreen({
    super.key,
    required this.t,
    required this.lang,
    required this.history,
    required this.streak,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final nl = lang == Lang.nl;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              t.historyTitle,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.orange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.local_fire_department,
                        size: 14,
                        color: AppColors.orange,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$streak ${streak == 1 ? "week" : t.homeWeeks}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => StatisticsScreen(
                          t: t,
                          lang: lang,
                          history: history,
                          course: course,
                        ),
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: palette.border),
                      ),
                      child: Icon(
                        Icons.bar_chart,
                        size: 16,
                        color: palette.foreground,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (history.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 64),
            child: Column(
              children: [
                const Text('📊', style: TextStyle(fontSize: 36)),
                const SizedBox(height: 12),
                Text(
                  t.historyNoResults,
                  style: TextStyle(fontSize: 14, color: palette.muted),
                ),
              ],
            ),
          )
        else
          for (final r in history) ...[
            AppCard(
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: gradeColor(r.grade).withValues(alpha: 0.13),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      r.grade.toStringAsFixed(0),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: gradeColor(r.grade),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          r.category.isEmpty
                              ? '${t.historyWeek} ${r.weekNumber}'
                              : '${t.historyWeek} ${r.weekNumber} · '
                                    '${course.categoryTitleFor(r.category, nl) ?? r.category}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          r.date,
                          style: TextStyle(fontSize: 12, color: palette.muted),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        r.grade.toStringAsFixed(1),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: gradeColor(r.grade),
                        ),
                      ),
                      Text(
                        '${r.correct}/${r.total}',
                        style: TextStyle(fontSize: 12, color: palette.muted),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
      ],
    );
  }
}
