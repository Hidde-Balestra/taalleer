import 'package:flutter/material.dart';

import '../data.dart';
import '../i18n.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets.dart';

class QuizResultScreen extends StatelessWidget {
  final Strings t;
  final QuizResult result;

  const QuizResultScreen({super.key, required this.t, required this.result});

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final passed = result.grade >= 5.5;
    final wrongWords = kWords
        .where((w) => result.wrongWordIds.contains(w.id))
        .toList();
    final chipColor = passed ? AppColors.green : AppColors.red;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
          children: [
            AppCard(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Text(
                    '${t.resultTitle} · ${t.resultWeek} ${result.weekNumber}'
                        .toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                      color: palette.muted,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GradeCircle(grade: result.grade),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: chipColor.withValues(alpha: 0.13),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      passed ? t.resultPass : t.resultFail,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: chipColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    value: '${result.correct}',
                    label: t.resultCorrect,
                    color: AppColors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    value: '${result.total - result.correct}',
                    label: t.resultIncorrect,
                    color: AppColors.red,
                  ),
                ),
              ],
            ),
            if (wrongWords.isNotEmpty) ...[
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 8),
                child: Text(
                  t.resultWrongWords,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              for (final w in wrongWords) ...[
                AppCard(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              w.es,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '${w.nl} · ${w.en}',
                              style: TextStyle(
                                fontSize: 12,
                                color: palette.muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.close,
                        size: 16,
                        color: AppColors.red.withValues(alpha: 0.7),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ],
            const SizedBox(height: 8),
            PrimaryButton(
              label: t.resultBackHome,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _StatCard({
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
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12, color: palette.muted)),
        ],
      ),
    );
  }
}
