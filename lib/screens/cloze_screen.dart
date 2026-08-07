import 'package:flutter/material.dart';

import '../i18n.dart';
import '../language_course.dart';
import '../models.dart';
import '../theme.dart';
import '../utils.dart';
import '../widgets.dart';

/// Ongegradeerde invuloefening: een zin met een weggelaten vervoegde
/// werkwoordsvorm ([ClozeEntry.sentenceTemplate]); de gebruiker typt alleen
/// die vorm. Het verwachte antwoord is `word.present[entry.person]` — al
/// aanwezig via de bestaande vervoeging, niet apart opgeslagen.
class ClozeScreen extends StatefulWidget {
  final Strings t;
  final bool dyslexia;
  final LanguageCourse course;
  final List<Word> verbs;

  const ClozeScreen({
    super.key,
    required this.t,
    required this.dyslexia,
    required this.course,
    required this.verbs,
  });

  @override
  State<ClozeScreen> createState() => _ClozeScreenState();
}

class _ClozeScreenState extends State<ClozeScreen> {
  late final List<(Word, ClozeEntry)> _items = buildClozeExercise(
    widget.verbs,
    widget.course,
  );
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  int _idx = 0;
  bool _checked = false;
  bool _correct = false;
  int _score = 0;
  bool _done = false;

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _check() {
    if (_controller.text.trim().isEmpty) return;
    final (word, entry) = _items[_idx];
    final ok = isAcceptable(
      _controller.text,
      word.present[entry.person],
      dyslexia: widget.dyslexia,
    );
    setState(() {
      _correct = ok;
      if (ok) _score++;
      _checked = true;
    });
  }

  void _next() {
    if (_idx + 1 >= _items.length) {
      setState(() => _done = true);
    } else {
      setState(() {
        _idx++;
        _checked = false;
        _controller.clear();
      });
      _focusNode.requestFocus();
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
                const Text('🧩', style: TextStyle(fontSize: 48)),
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
                  '${t.practiceScore}: $_score/${_items.length}',
                  style: TextStyle(fontSize: 14, color: palette.muted),
                ),
                const SizedBox(height: 24),
                GradeCircle(grade: calcGrade(_score, _items.length)),
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

    final (word, entry) = _items[_idx];
    final correctAnswer = word.present[entry.person];

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
                          t.clozeTitle,
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
                                value: (_idx + 1) / _items.length,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${_idx + 1}/${_items.length}',
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
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            t.clozeInstruction(word.target),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: palette.muted,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            entry.sentenceTemplate,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            entry.translationNl,
                            style: TextStyle(
                              fontSize: 13,
                              fontStyle: FontStyle.italic,
                              color: palette.muted,
                            ),
                          ),
                          if (_checked) ...[
                            const SizedBox(height: 16),
                            _ClozeFeedback(
                              t: t,
                              correct: _correct,
                              correctAnswer: correctAnswer,
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      enabled: !_checked,
                      autofocus: true,
                      onSubmitted: (_) => _checked ? _next() : _check(),
                      onChanged: (_) => setState(() {}),
                      style: TextStyle(
                        fontSize: 16,
                        color: _checked
                            ? (_correct ? AppColors.green : AppColors.red)
                            : palette.foreground,
                      ),
                      decoration: InputDecoration(
                        hintText: t.practicePlaceholder,
                        hintStyle: TextStyle(color: palette.muted),
                        filled: true,
                        fillColor: palette.card,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: palette.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                          ),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: (_correct ? AppColors.green : AppColors.red)
                                .withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (!_checked)
                      PrimaryButton(
                        label: t.practiceCheck,
                        onPressed: _controller.text.trim().isEmpty
                            ? null
                            : _check,
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

class _ClozeFeedback extends StatelessWidget {
  final Strings t;
  final bool correct;
  final String correctAnswer;

  const _ClozeFeedback({
    required this.t,
    required this.correct,
    required this.correctAnswer,
  });

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final color = correct ? AppColors.green : AppColors.red;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(correct ? Icons.check : Icons.close, size: 16, color: color),
          const SizedBox(width: 8),
          Flexible(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: correct ? t.practiceCorrect : t.practiceIncorrect,
                    style: TextStyle(fontWeight: FontWeight.w600, color: color),
                  ),
                  if (!correct) ...[
                    const TextSpan(text: '  '),
                    TextSpan(
                      text: correctAnswer,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: palette.foreground,
                      ),
                    ),
                  ],
                ],
              ),
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
