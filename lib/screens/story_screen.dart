import 'package:flutter/material.dart';

import '../i18n.dart';
import '../language_course.dart';
import '../models.dart';
import '../story_content.dart';
import '../theme.dart';
import '../widgets.dart';

const double _minStoryTextScale = 0.8;
const double _maxStoryTextScale = 2.0;
const double _storyTextScaleStep = 0.1;
const double _storyBaseFontSize = 16;

/// Leesscherm voor één verhaal: instelbare tekstgrootte (voor slechtziende
/// gebruikers), per alinea een uitspraakknop, en een uitklapbare Nederlandse
/// vertaling — verborgen totdat je erom vraagt, zodat je eerst zelf probeert
/// te lezen.
class StoryScreen extends StatefulWidget {
  final Strings t;
  final bool nl;
  final LanguageCourse course;
  final Story story;
  final AppSettings settings;
  final ValueChanged<AppSettings> onSettingsChanged;

  const StoryScreen({
    super.key,
    required this.t,
    required this.nl,
    required this.course,
    required this.story,
    required this.settings,
    required this.onSettingsChanged,
  });

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  late double _scale = widget.settings.storyTextScale;
  bool _showTranslation = false;

  void _changeScale(double delta) {
    final next = (_scale + delta).clamp(_minStoryTextScale, _maxStoryTextScale);
    setState(() => _scale = next);
    widget.onSettingsChanged(widget.settings.copyWith(storyTextScale: next));
  }

  String _levelLabel(StoryLevel level) {
    final t = widget.t;
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
    final t = widget.t;
    final story = widget.story;
    final palette = AppPalette.of(context);
    final fontSize = _storyBaseFontSize * _scale;

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
                          story.title(widget.nl),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${_levelLabel(story.level)} · ${story.topic(widget.nl)}',
                          style: TextStyle(fontSize: 12, color: palette.muted),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Row(
                children: [
                  _ScaleButton(
                    icon: Icons.text_decrease,
                    onTap: _scale > _minStoryTextScale
                        ? () => _changeScale(-_storyTextScaleStep)
                        : null,
                  ),
                  const SizedBox(width: 8),
                  _ScaleButton(
                    icon: Icons.text_increase,
                    onTap: _scale < _maxStoryTextScale
                        ? () => _changeScale(_storyTextScaleStep)
                        : null,
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () =>
                        setState(() => _showTranslation = !_showTranslation),
                    icon: Icon(
                      _showTranslation
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 16,
                    ),
                    label: Text(
                      _showTranslation
                          ? t.storyHideTranslation
                          : t.storyShowTranslation,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                itemCount: story.paragraphs.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, i) => _ParagraphCard(
                  t: t,
                  course: widget.course,
                  paragraph: story.paragraphs[i],
                  fontSize: fontSize,
                  showTranslation: _showTranslation,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScaleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _ScaleButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final disabled = onTap == null;
    return Opacity(
      opacity: disabled ? 0.4 : 1,
      child: Material(
        color: palette.card,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: palette.border),
            ),
            child: Icon(icon, size: 18, color: palette.foreground),
          ),
        ),
      ),
    );
  }
}

class _ParagraphCard extends StatelessWidget {
  final Strings t;
  final LanguageCourse course;
  final StoryParagraph paragraph;
  final double fontSize;
  final bool showTranslation;

  const _ParagraphCard({
    required this.t,
    required this.course,
    required this.paragraph,
    required this.fontSize,
    required this.showTranslation,
  });

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  paragraph.target,
                  style: TextStyle(fontSize: fontSize, height: 1.5),
                ),
              ),
              SpeakButton(
                t: t,
                text: paragraph.target,
                locale: course.ttsLocale,
              ),
            ],
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            alignment: Alignment.topLeft,
            child: showTranslation
                ? Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      paragraph.nl,
                      style: TextStyle(
                        fontSize: fontSize * 0.85,
                        color: palette.muted,
                        fontStyle: FontStyle.italic,
                        height: 1.4,
                      ),
                    ),
                  )
                : const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }
}
