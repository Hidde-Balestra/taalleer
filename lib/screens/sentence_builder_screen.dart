import 'package:flutter/material.dart';

import '../i18n.dart';
import '../language_course.dart';
import '../models.dart';
import '../theme.dart';
import '../utils.dart';
import '../widgets.dart';

/// Ongegradeerde oefening: tik de door elkaar gehusselde woorden van een
/// Spaanse voorbeeldzin in de juiste volgorde aan te tikken, op basis van de
/// Nederlandse vertaling als prompt. Bron: `sentenceWordPool` (dezelfde
/// curated voorbeeldzinnen als de woordenlijst).
class SentenceBuilderScreen extends StatefulWidget {
  final Strings t;
  final LanguageCourse course;

  const SentenceBuilderScreen({
    super.key,
    required this.t,
    required this.course,
  });

  @override
  State<SentenceBuilderScreen> createState() => _SentenceBuilderScreenState();
}

class _SentenceBuilderScreenState extends State<SentenceBuilderScreen> {
  late final List<SentenceBuildQuestion> _questions = buildSentenceBuilder(
    widget.course,
  );
  final List<int> _picked = [];

  int _idx = 0;
  bool _checked = false;
  bool _correct = false;
  int _score = 0;
  bool _done = false;

  SentenceBuildQuestion get _q => _questions[_idx];

  bool _sameOrder(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  void _tapAvailable(int tokenIndex) {
    if (_checked) return;
    setState(() => _picked.add(tokenIndex));
  }

  void _tapPicked(int position) {
    if (_checked) return;
    setState(() => _picked.removeAt(position));
  }

  void _check() {
    final built = [for (final i in _picked) _q.shuffledTokens[i]];
    final ok = _sameOrder(built, _q.correctTokens);
    setState(() {
      _correct = ok;
      if (ok) _score++;
      _checked = true;
    });
  }

  void _next() {
    if (_idx + 1 >= _questions.length) {
      setState(() => _done = true);
    } else {
      setState(() {
        _idx++;
        _picked.clear();
        _checked = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.t;
    final palette = AppPalette.of(context);

    if (_done) {
      return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('✍️', style: TextStyle(fontSize: 48)),
                const SizedBox(height: 24),
                Text(
                  t.practiceSummary,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${t.practiceScore}: $_score/${_questions.length}',
                  style: TextStyle(fontSize: 14, color: palette.muted),
                ),
                const SizedBox(height: 24),
                GradeCircle(grade: calcGrade(_score, _questions.length)),
                const SizedBox(height: 24),
                PrimaryButton(
                  label: t.practiceBackHome,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final available = [
      for (var i = 0; i < _q.shuffledTokens.length; i++)
        if (!_picked.contains(i)) i,
    ];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  BackButtonCard(onTap: () => Navigator.of(context).pop()),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t.sentenceBuilderTitle,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: palette.muted,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Expanded(
                              child: ThinProgressBar(
                                value: (_idx + 1) / _questions.length,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${_idx + 1}/${_questions.length}',
                              style: TextStyle(
                                fontSize: 12,
                                color: palette.muted,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            t.sentenceBuilderInstruction,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: palette.muted,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _q.word.exampleNl,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(minHeight: 56),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: palette.card,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: palette.border),
                      ),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (var pos = 0; pos < _picked.length; pos++)
                            _Tile(
                              label: _q.shuffledTokens[_picked[pos]],
                              highlighted: true,
                              onTap: () => _tapPicked(pos),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final i in available)
                          _Tile(
                            label: _q.shuffledTokens[i],
                            highlighted: false,
                            onTap: () => _tapAvailable(i),
                          ),
                      ],
                    ),
                    if (_checked) ...[
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: (_correct ? AppColors.green : AppColors.red)
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: (_correct ? AppColors.green : AppColors.red)
                                .withValues(alpha: 0.2),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  _correct ? Icons.check : Icons.close,
                                  size: 16,
                                  color: _correct
                                      ? AppColors.green
                                      : AppColors.red,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _correct
                                      ? t.practiceCorrect
                                      : t.practiceIncorrect,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: _correct
                                        ? AppColors.green
                                        : AppColors.red,
                                  ),
                                ),
                              ],
                            ),
                            if (!_correct) ...[
                              const SizedBox(height: 4),
                              Text(
                                _q.correctTokens.join(' '),
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: palette.foreground,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    if (!_checked)
                      PrimaryButton(
                        label: t.practiceCheck,
                        onPressed: _picked.isEmpty ? null : _check,
                      )
                    else
                      PrimaryButton(label: t.practiceNext, onPressed: _next),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  final String label;
  final bool highlighted;
  final VoidCallback onTap;

  const _Tile({
    required this.label,
    required this.highlighted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: highlighted
                ? AppColors.primary.withValues(alpha: 0.12)
                : palette.card,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: highlighted ? AppColors.primary : palette.border,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: highlighted ? AppColors.primary : palette.foreground,
            ),
          ),
        ),
      ),
    );
  }
}
