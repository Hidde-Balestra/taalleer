import 'package:flutter/material.dart';

import 'models.dart';

/// Een prestatie/badge. Puur afgeleid van bestaande data (toetsresultaten +
/// streak) — geen aparte opslag, "behaald" betekent gewoon dat het predicaat
/// nu klopt. Dat voorkomt migratierisico en een aparte "unlocked"-status om
/// gesynchroniseerd te houden.
class Achievement {
  final String id;
  final String titleNl;
  final String titleEn;
  final String descNl;
  final String descEn;
  final IconData icon;
  final bool Function(List<QuizResult> history, int streak) isUnlocked;

  const Achievement({
    required this.id,
    required this.titleNl,
    required this.titleEn,
    required this.descNl,
    required this.descEn,
    required this.icon,
    required this.isUnlocked,
  });

  String title(bool nl) => nl ? titleNl : titleEn;
  String description(bool nl) => nl ? descNl : descEn;
}

/// Alle prestaties, in de volgorde waarin ze getoond worden.
const List<Achievement> kAchievements = [
  Achievement(
    id: 'first_steps',
    titleNl: 'Eerste stappen',
    titleEn: 'First steps',
    descNl: 'Rond je eerste toets af.',
    descEn: 'Complete your first quiz.',
    icon: Icons.flag_outlined,
    isUnlocked: _hasHistory,
  ),
  Achievement(
    id: 'month_streak',
    titleNl: 'Een maand vol',
    titleEn: 'A month strong',
    descNl: 'Haal een streak van 4 weken.',
    descEn: 'Reach a 4-week streak.',
    icon: Icons.local_fire_department_outlined,
    isUnlocked: _streakAtLeast4,
  ),
  Achievement(
    id: 'half_year_streak',
    titleNl: 'Half jaar vol',
    titleEn: 'Half a year strong',
    descNl: 'Haal een streak van 26 weken.',
    descEn: 'Reach a 26-week streak.',
    icon: Icons.local_fire_department,
    isUnlocked: _streakAtLeast26,
  ),
  Achievement(
    id: 'year_streak',
    titleNl: 'Een jaar vol',
    titleEn: 'A year strong',
    descNl: 'Haal een streak van 52 weken.',
    descEn: 'Reach a 52-week streak.',
    icon: Icons.emoji_events_outlined,
    isUnlocked: _streakAtLeast52,
  ),
  Achievement(
    id: 'perfect_score',
    titleNl: 'Perfecte score',
    titleEn: 'Perfect score',
    descNl: 'Haal een 10 op een toets.',
    descEn: 'Score a perfect 10 on a quiz.',
    icon: Icons.star_outline,
    isUnlocked: _hasPerfectScore,
  ),
  Achievement(
    id: 'ten_quizzes',
    titleNl: 'Tien toetsen',
    titleEn: 'Ten quizzes',
    descNl: 'Maak in totaal 10 toetsen.',
    descEn: 'Take 10 quizzes in total.',
    icon: Icons.checklist,
    isUnlocked: _quizCountAtLeast10,
  ),
  Achievement(
    id: 'fifty_quizzes',
    titleNl: 'Vijftig toetsen',
    titleEn: 'Fifty quizzes',
    descNl: 'Maak in totaal 50 toetsen.',
    descEn: 'Take 50 quizzes in total.',
    icon: Icons.workspace_premium_outlined,
    isUnlocked: _quizCountAtLeast50,
  ),
  Achievement(
    id: 'no_mistakes',
    titleNl: 'Alles goed',
    titleEn: 'Flawless',
    descNl: 'Rond een toets af zonder één fout woord.',
    descEn: 'Complete a quiz with zero wrong words.',
    icon: Icons.verified_outlined,
    isUnlocked: _hasFlawlessQuiz,
  ),
];

bool _hasHistory(List<QuizResult> history, int streak) => history.isNotEmpty;

bool _streakAtLeast4(List<QuizResult> history, int streak) => streak >= 4;

bool _streakAtLeast26(List<QuizResult> history, int streak) => streak >= 26;

bool _streakAtLeast52(List<QuizResult> history, int streak) => streak >= 52;

bool _hasPerfectScore(List<QuizResult> history, int streak) =>
    history.any((r) => r.grade == 10.0);

bool _quizCountAtLeast10(List<QuizResult> history, int streak) =>
    history.length >= 10;

bool _quizCountAtLeast50(List<QuizResult> history, int streak) =>
    history.length >= 50;

bool _hasFlawlessQuiz(List<QuizResult> history, int streak) =>
    history.any((r) => r.total > 0 && r.wrongWordIds.isEmpty);
