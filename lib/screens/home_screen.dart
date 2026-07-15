import 'package:flutter/material.dart';

import '../i18n.dart';
import '../models.dart';
import '../theme.dart';
import '../utils.dart';
import '../widgets.dart';

class HomeScreen extends StatelessWidget {
  final Strings t;
  final Lang lang;
  final int weekNumber;
  final int streak;
  final int wordCount;
  final List<QuizResult> history;
  final bool paused;
  final bool quizDoneThisWeek;
  final VoidCallback onPractice;
  final VoidCallback onQuiz;
  final VoidCallback onConjQuiz;

  const HomeScreen({
    super.key,
    required this.t,
    required this.lang,
    required this.weekNumber,
    required this.streak,
    required this.wordCount,
    required this.history,
    required this.paused,
    required this.quizDoneThisWeek,
    required this.onPractice,
    required this.onQuiz,
    required this.onConjQuiz,
  });

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final last = history.isEmpty ? null : history.first;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      children: [
        _Header(
          t: t,
          lang: lang,
          weekNumber: weekNumber,
          streak: streak,
          wordCount: wordCount,
        ),
        const SizedBox(height: 16),
        _GradientActionButton(
          onTap: onPractice,
          gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.primaryDark],
          ),
          title: t.homePractice,
          subtitle: t.homePracticeSub,
          trailing: const Icon(
            Icons.chevron_right,
            color: Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(height: 12),
        if (paused)
          Opacity(
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
          )
        else ...[
          _GradientActionButton(
            onTap: onQuiz,
            gradient: const LinearGradient(
              colors: [AppColors.orange, AppColors.orangeDark],
            ),
            title: t.homeQuiz,
            subtitle: t.homeQuizSub,
            trailing: const Icon(
              Icons.emoji_events_outlined,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(height: 12),
          _GradientActionButton(
            onTap: onConjQuiz,
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.indigo],
            ),
            title: t.homeConjQuiz,
            subtitle: t.homeConjSub,
            trailing: const Icon(
              Icons.spellcheck,
              color: Colors.white,
              size: 20,
            ),
          ),
          if (quizDoneThisWeek) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.check_circle,
                  size: 16,
                  color: AppColors.green,
                ),
                const SizedBox(width: 6),
                Text(
                  t.homeQuizDone,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.green,
                  ),
                ),
              ],
            ),
          ],
        ],
        const SizedBox(height: 16),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                t.homeLastGrade,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: palette.muted,
                ),
              ),
              const SizedBox(height: 8),
              if (last == null)
                Text(
                  t.homeNoResult,
                  style: TextStyle(fontSize: 14, color: palette.muted),
                )
              else
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                last.grade.toStringAsFixed(1),
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: gradeColor(last.grade),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 4,
                                  bottom: 3,
                                ),
                                child: Text(
                                  '/10',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: palette.muted,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${last.date} · ${last.correct}/${last.total} ${t.resultCorrect.toLowerCase()}',
                            style: TextStyle(
                              fontSize: 12,
                              color: palette.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 48,
                      height: 48,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: gradeColor(last.grade).withValues(alpha: 0.13),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        last.grade >= 5.5 ? '✓' : '✗',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: gradeColor(last.grade),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  final Strings t;
  final Lang lang;
  final int weekNumber;
  final int streak;
  final int wordCount;

  const _Header({
    required this.t,
    required this.lang,
    required this.weekNumber,
    required this.streak,
    required this.wordCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.indigo],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            formatDateLong(DateTime.now(), lang),
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            t.homeGreeting,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            t.homeSubGreeting,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _StatChip(label: t.homeWeek, value: '$weekNumber'),
              const SizedBox(width: 8),
              _StatChip(label: t.homeWordsLearned, value: '$wordCount'),
              const SizedBox(width: 8),
              _StatChip(
                label: '🔥 ${t.homeStreak}',
                value: '$streak',
                background: Colors.orange.shade400,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color? background;

  const _StatChip({required this.label, required this.value, this.background});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: background ?? Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10,
                color: Colors.white.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GradientActionButton extends StatelessWidget {
  final VoidCallback onTap;
  final Gradient gradient;
  final String title;
  final String subtitle;
  final Widget trailing;

  const _GradientActionButton({
    required this.onTap,
    required this.gradient,
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(child: trailing),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
