import 'package:flutter/material.dart';

import '../achievements.dart';
import '../i18n.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets.dart';

/// Vlakke lijst van alle prestaties: behaalde badges gekleurd/geaccentueerd,
/// niet-behaalde grijs met een slot-icoon. Geen aparte opslag — "behaald"
/// wordt live berekend uit [history]/[streak].
class AchievementsScreen extends StatelessWidget {
  final Strings t;
  final bool nl;
  final List<QuizResult> history;
  final int streak;

  const AchievementsScreen({
    super.key,
    required this.t,
    required this.nl,
    required this.history,
    required this.streak,
  });

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final unlockedCount = kAchievements
        .where((a) => a.isUnlocked(history, streak))
        .length;

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
                          t.achievementsTitle,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          t.achievementsProgressLabel(
                            unlockedCount,
                            kAchievements.length,
                          ),
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
                itemCount: kAchievements.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (context, i) {
                  final achievement = kAchievements[i];
                  final unlocked = achievement.isUnlocked(history, streak);
                  return _AchievementCard(
                    t: t,
                    nl: nl,
                    achievement: achievement,
                    unlocked: unlocked,
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

class _AchievementCard extends StatelessWidget {
  final Strings t;
  final bool nl;
  final Achievement achievement;
  final bool unlocked;

  const _AchievementCard({
    required this.t,
    required this.nl,
    required this.achievement,
    required this.unlocked,
  });

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return Opacity(
      opacity: unlocked ? 1 : 0.6,
      child: AppCard(
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: unlocked
                    ? AppColors.amber.withValues(alpha: 0.15)
                    : palette.border,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                achievement.icon,
                size: 20,
                color: unlocked ? AppColors.amber : palette.muted,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    achievement.title(nl),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    unlocked
                        ? achievement.description(nl)
                        : t.achievementsLocked,
                    style: TextStyle(fontSize: 12, color: palette.muted),
                  ),
                ],
              ),
            ),
            if (!unlocked)
              Icon(Icons.lock_outline, size: 16, color: palette.muted),
          ],
        ),
      ),
    );
  }
}
