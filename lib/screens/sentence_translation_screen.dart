import 'package:flutter/material.dart';

import '../i18n.dart';
import '../language_course.dart';
import '../models.dart';
import '../theme.dart';
import '../utils.dart';
import '../widgets.dart';

/// Ongegradeerde oefening: vertaal een hele Spaanse voorbeeldzin naar het
/// Nederlands (i.p.v. een los woord). Dyslexie-tolerantie schaalt al met de
/// lengte van het antwoord ([isAcceptable]), dus die werkt ook voor hele
/// zinnen.
class SentenceTranslationScreen extends StatefulWidget {
  final Strings t;
  final bool dyslexia;
  final LanguageCourse course;

  const SentenceTranslationScreen({
    super.key,
    required this.t,
    required this.dyslexia,
    required this.course,
  });

  @override
  State<SentenceTranslationScreen> createState() =>
      _SentenceTranslationScreenState();
}

class _SentenceTranslationScreenState extends State<SentenceTranslationScreen> {
  late final List<Word> _words = buildSentenceTranslation(widget.course);
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
    final word = _words[_idx];
    final ok = isAcceptable(
      _controller.text,
      word.exampleNl,
      dyslexia: widget.dyslexia,
    );
    setState(() {
      _correct = ok;
      if (ok) _score++;
      _checked = true;
    });
  }

  void _next() {
    if (_idx + 1 >= _words.length) {
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
                const Text('📝', style: TextStyle(fontSize: 48)),
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
                  '${t.practiceScore}: $_score/${_words.length}',
                  style: TextStyle(fontSize: 14, color: palette.muted),
                ),
                const SizedBox(height: 24),
                GradeCircle(grade: calcGrade(_score, _words.length)),
                const SizedBox(height: 24),
                PrimaryButton(
                  label: t.practiceBackHome,
                  onPressed: () =>
                      Navigator.of(context).popUntil((r) => r.isFirst),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final word = _words[_idx];

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
                          t.sentenceTranslationTitle,
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
                                value: (_idx + 1) / _words.length,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${_idx + 1}/${_words.length}',
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
                            t.sentenceTranslationInstruction,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: palette.muted,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  word.exampleTarget,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SpeakButton(
                                t: t,
                                text: word.exampleTarget,
                                locale: widget.course.ttsLocale,
                              ),
                            ],
                          ),
                          if (_checked) ...[
                            const SizedBox(height: 16),
                            _SentenceFeedback(
                              t: t,
                              correct: _correct,
                              correctAnswer: word.exampleNl,
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

class _SentenceFeedback extends StatelessWidget {
  final Strings t;
  final bool correct;
  final String correctAnswer;

  const _SentenceFeedback({
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(correct ? Icons.check : Icons.close, size: 16, color: color),
              const SizedBox(width: 8),
              Text(
                correct ? t.practiceCorrect : t.practiceIncorrect,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
          if (!correct) ...[
            const SizedBox(height: 4),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: '${t.practiceCorrectAnswer}: '),
                  TextSpan(
                    text: correctAnswer,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: palette.foreground,
                    ),
                  ),
                ],
              ),
              style: TextStyle(fontSize: 12, color: palette.muted),
            ),
          ],
        ],
      ),
    );
  }
}
