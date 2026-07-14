import 'package:flutter/material.dart';

import '../i18n.dart';
import '../models.dart';
import '../theme.dart';
import '../utils.dart';
import '../widgets.dart';

class QuizScreen extends StatefulWidget {
  final Strings t;
  final bool dyslexia;
  final Lang sourceLang;
  final int weekNumber;
  final ValueChanged<QuizResult> onFinish;

  const QuizScreen({
    super.key,
    required this.t,
    required this.dyslexia,
    required this.sourceLang,
    required this.weekNumber,
    required this.onFinish,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late final List<Question> _questions = buildQuiz(widget.sourceLang);
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  int _idx = 0;
  final List<({bool correct, int wordId})> _answers = [];

  static const _orangeGradient = LinearGradient(
    colors: [AppColors.orange, AppColors.orangeDark],
  );

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submit() {
    if (_controller.text.trim().isEmpty) return;
    final q = _questions[_idx];
    final ok = isAcceptable(
      _controller.text,
      correctAnswerOf(q),
      dyslexia: widget.dyslexia,
    );
    _answers.add((correct: ok, wordId: q.word.id));

    if (_idx + 1 >= _questions.length) {
      final correctCount = _answers.where((a) => a.correct).length;
      final wrongIds = _answers
          .where((a) => !a.correct)
          .map((a) => a.wordId)
          .toList();
      final today = DateTime.now();
      widget.onFinish(
        QuizResult(
          id: today.millisecondsSinceEpoch,
          weekNumber: widget.weekNumber,
          year: today.year,
          date: formatDateShort(today),
          grade: calcGrade(correctCount, _questions.length),
          correct: correctCount,
          total: _questions.length,
          wrongWordIds: wrongIds,
        ),
      );
    } else {
      setState(() {
        _idx++;
        _controller.clear();
      });
      _focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.t;
    final palette = AppPalette.of(context);
    final q = _questions[_idx];

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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              t.quizTitle,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${t.quizProgress} ${_idx + 1}/${_questions.length}',
                              style: TextStyle(
                                fontSize: 12,
                                color: palette.muted,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ThinProgressBar(
                          value: (_idx + 1) / _questions.length,
                          gradient: _orangeGradient,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (widget.dyslexia) ...[
                _NoticeBar(
                  icon: Icons.text_fields,
                  text: t.quizDyslexiaActive,
                  color: AppColors.amber,
                ),
                const SizedBox(height: 8),
              ],
              _NoticeBar(
                icon: Icons.lock_outline,
                text: t.quizNoHints,
                color: palette.muted,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: AppCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _controller,
                focusNode: _focusNode,
                autofocus: true,
                onSubmitted: (_) => _submit(),
                onChanged: (_) => setState(() {}),
                style: const TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  hintText: t.quizPlaceholder,
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
                    borderSide: const BorderSide(color: AppColors.orange),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              PrimaryButton(
                label: t.quizSubmit,
                gradient: _orangeGradient,
                onPressed: _controller.text.trim().isEmpty ? null : _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NoticeBar extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _NoticeBar({
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final isMuted = color == palette.muted;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isMuted ? palette.card : color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isMuted ? palette.border : color.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
