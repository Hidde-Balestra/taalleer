import 'package:flutter/material.dart';

import '../grammar.dart';
import '../i18n.dart';
import '../models.dart';
import '../theme.dart';
import '../utils.dart';
import '../widgets.dart';

/// Toets waarin de gebruiker werkwoorden in de tegenwoordige tijd vervoegt.
class ConjugationQuizScreen extends StatefulWidget {
  final Strings t;
  final bool dyslexia;
  final int weekNumber;
  final List<Word> verbs;
  final ValueChanged<QuizResult> onFinish;

  const ConjugationQuizScreen({
    super.key,
    required this.t,
    required this.dyslexia,
    required this.weekNumber,
    required this.verbs,
    required this.onFinish,
  });

  @override
  State<ConjugationQuizScreen> createState() => _ConjugationQuizScreenState();
}

class _ConjugationQuizScreenState extends State<ConjugationQuizScreen> {
  late final List<ConjugationQuestion> _questions = buildConjugationQuiz(
    widget.verbs,
  );
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  int _idx = 0;
  final List<({bool correct, int wordId})> _answers = [];

  static const _gradient = LinearGradient(
    colors: [AppColors.primary, AppColors.indigo],
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
      q.answer,
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
                              t.conjTitle,
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
                          gradient: _gradient,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: palette.card,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: palette.border),
                ),
                child: Row(
                  children: [
                    Icon(Icons.spellcheck, size: 14, color: palette.muted),
                    const SizedBox(width: 8),
                    Text(
                      t.conjInstruction,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: palette.muted,
                      ),
                    ),
                  ],
                ),
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
                        '${q.word.es} · ${q.word.nl}',
                        style: TextStyle(fontSize: 14, color: palette.muted),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        kPronouns[q.person],
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${q.word.es} …',
                        style: TextStyle(fontSize: 14, color: palette.muted),
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
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              PrimaryButton(
                label: t.quizSubmit,
                gradient: _gradient,
                onPressed: _controller.text.trim().isEmpty ? null : _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
