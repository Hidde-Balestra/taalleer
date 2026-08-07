import 'package:flutter/material.dart';

import '../i18n.dart';
import '../language_course.dart';
import '../models.dart';
import '../story_content.dart';
import '../theme.dart';
import '../widgets.dart';
import 'story_screen.dart';

/// Overzicht van de leesverhalen van de huidige cursus, gegroepeerd per
/// niveau — zelfde lijst-stijl als de grammaticacategorieën.
class StoriesScreen extends StatelessWidget {
  final Strings t;
  final bool nl;
  final LanguageCourse course;
  final AppSettings settings;
  final ValueChanged<AppSettings> onSettingsChanged;

  const StoriesScreen({
    super.key,
    required this.t,
    required this.nl,
    required this.course,
    required this.settings,
    required this.onSettingsChanged,
  });

  String _levelLabel(StoryLevel level) {
    switch (level) {
      case StoryLevel.beginner:
        return t.storyLevelBeginner;
      case StoryLevel.intermediate:
        return t.storyLevelIntermediate;
      case StoryLevel.advanced:
        return t.storyLevelAdvanced;
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final stories = course.stories;

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
                          t.storiesTitle,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          t.storiesSubtitle,
                          style: TextStyle(fontSize: 12, color: palette.muted),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: stories.isEmpty
                  ? Center(
                      child: Text(
                        t.storiesEmpty,
                        style: TextStyle(fontSize: 14, color: palette.muted),
                      ),
                    )
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      children: [
                        for (final level in StoryLevel.values)
                          if (stories.any((s) => s.level == level)) ...[
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                _levelLabel(level),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: palette.muted,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            for (final story in stories.where(
                              (s) => s.level == level,
                            )) ...[
                              _StoryCard(
                                story: story,
                                nl: nl,
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => StoryScreen(
                                      t: t,
                                      nl: nl,
                                      course: course,
                                      story: story,
                                      settings: settings,
                                      onSettingsChanged: onSettingsChanged,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                            ],
                          ],
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StoryCard extends StatelessWidget {
  final Story story;
  final bool nl;
  final VoidCallback onTap;

  const _StoryCard({
    required this.story,
    required this.nl,
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
                  color: AppColors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.auto_stories_outlined,
                  size: 18,
                  color: AppColors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      story.title(nl),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      story.topic(nl),
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
