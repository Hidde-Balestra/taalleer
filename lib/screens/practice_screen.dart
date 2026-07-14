import 'package:flutter/material.dart';

import '../i18n.dart';
import '../models.dart';
import '../theme.dart';
import '../utils.dart';
import '../widgets.dart';

class PracticeScreen extends StatefulWidget {
  final Strings t;
  final bool dyslexia;
  final Lang sourceLang;
  final List<Word> words;

  const PracticeScreen({
    super.key,
    required this.t,
    required this.dyslexia,
    required this.sourceLang,
    required this.words,
  });

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  late final List<Question> _questions = buildPractice(
    widget.words,
    widget.sourceLang,
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
    final q = _questions[_idx];
    final ok = isAcceptable(
      _controller.text,
      correctAnswerOf(q),
      dyslexia: widget.dyslexia,
    );
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
                const Text('🎉', style: TextStyle(fontSize: 48)),
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

    final q = _questions[_idx];
    final correctAns = correctAnswerOf(q);

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
                          t.practiceTitle,
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
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            t.questionLabel(q.type),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: palette.muted,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            shownWordOf(q),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (!_checked)
                            Text(
                              q.word.pronunciation,
                              style: TextStyle(
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                                color: palette.muted,
                              ),
                            )
                          else
                            _FeedbackBox(
                              t: t,
                              correct: _correct,
                              correctAnswer: correctAns,
                            ),
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

class _FeedbackBox extends StatelessWidget {
  final Strings t;
  final bool correct;
  final String correctAnswer;

  const _FeedbackBox({
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
