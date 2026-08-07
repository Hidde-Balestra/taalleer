import 'package:flutter/material.dart';

import '../i18n.dart';
import '../theme.dart';
import '../widgets.dart';

/// Overzicht van alle oefenvormen (Woordentoets/Vervoegingstoets blijven op
/// Home — de "serieuze" wekelijkse activiteiten; dit scherm bundelt de rest,
/// die anders het Home-scherm te druk zouden maken). Zelfde lijst-stijl als
/// de grammaticacategorieën in `grammar_screen.dart`.
class PracticeHubScreen extends StatelessWidget {
  final Strings t;
  final int weakWordCount;
  final VoidCallback onPractice;
  final VoidCallback onListeningPractice;
  final VoidCallback onSentenceBuilder;
  final VoidCallback onSentenceTranslation;
  final VoidCallback onMultipleChoice;
  final VoidCallback onListeningChoice;
  final VoidCallback onMemoryGame;
  final VoidCallback onCloze;
  final VoidCallback onDailyMini;
  final VoidCallback onPracticeWeakWords;

  const PracticeHubScreen({
    super.key,
    required this.t,
    required this.weakWordCount,
    required this.onPractice,
    required this.onListeningPractice,
    required this.onSentenceBuilder,
    required this.onSentenceTranslation,
    required this.onMultipleChoice,
    required this.onListeningChoice,
    required this.onMemoryGame,
    required this.onCloze,
    required this.onDailyMini,
    required this.onPracticeWeakWords,
  });

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);

    final entries = [
      (
        icon: Icons.edit_outlined,
        title: t.homePractice,
        subtitle: t.homePracticeSub,
        onTap: onPractice,
      ),
      (
        icon: Icons.headphones,
        title: t.homeListeningPractice,
        subtitle: t.homeListeningPracticeSub,
        onTap: onListeningPractice,
      ),
      (
        icon: Icons.short_text,
        title: t.sentenceBuilderTitle,
        subtitle: t.sentenceBuilderSub,
        onTap: onSentenceBuilder,
      ),
      (
        icon: Icons.translate,
        title: t.sentenceTranslationTitle,
        subtitle: t.sentenceTranslationSub,
        onTap: onSentenceTranslation,
      ),
      (
        icon: Icons.checklist_rtl,
        title: t.multipleChoiceTitle,
        subtitle: t.multipleChoiceSub,
        onTap: onMultipleChoice,
      ),
      (
        icon: Icons.hearing,
        title: t.listeningChoiceTitle,
        subtitle: t.listeningChoiceSub,
        onTap: onListeningChoice,
      ),
      (
        icon: Icons.grid_view_outlined,
        title: t.memoryGameTitle,
        subtitle: t.memoryGameSub,
        onTap: onMemoryGame,
      ),
      (
        icon: Icons.rule_folder_outlined,
        title: t.clozeTitle,
        subtitle: t.clozeSub,
        onTap: onCloze,
      ),
      (
        icon: Icons.today_outlined,
        title: t.dailyMiniTitle,
        subtitle: t.dailyMiniSub,
        onTap: onDailyMini,
      ),
      if (weakWordCount > 0)
        (
          icon: Icons.refresh,
          title: t.homeWeakWords,
          subtitle: t.homeWeakWordsSub(weakWordCount),
          onTap: onPracticeWeakWords,
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
                          t.practiceHubTitle,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          t.practiceHubSubtitle,
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
                itemCount: entries.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (context, i) {
                  final entry = entries[i];
                  return _HubCard(
                    icon: entry.icon,
                    title: entry.title,
                    subtitle: entry.subtitle,
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

class _HubCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _HubCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return AppCard(
      padding: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
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
              Icon(Icons.chevron_right, size: 16, color: palette.muted),
            ],
          ),
        ),
      ),
    );
  }
}
