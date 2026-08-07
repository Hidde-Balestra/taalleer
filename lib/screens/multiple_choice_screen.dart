import 'package:flutter/material.dart';

import '../i18n.dart';
import '../language_course.dart';
import '../models.dart';
import '../theme.dart';
import '../tts.dart';
import '../utils.dart';
import '../widgets.dart';

/// Ongegradeerde meerkeuze-oefening: 4 opties i.p.v. typen. Met [listening]
/// wordt in plaats van de prompttekst een afspeelknop getoond (net als
/// [ListeningPracticeScreen], hier alleen als variant van dit scherm i.p.v.
/// een apart scherm — het mechanisme is verder identiek).
class MultipleChoiceScreen extends StatefulWidget {
  final Strings t;
  final Lang sourceLang;
  final LanguageCourse course;
  final List<Word> words;
  final bool listening;

  const MultipleChoiceScreen({
    super.key,
    required this.t,
    required this.sourceLang,
    required this.course,
    required this.words,
    this.listening = false,
  });

  @override
  State<MultipleChoiceScreen> createState() => _MultipleChoiceScreenState();
}

class _MultipleChoiceScreenState extends State<MultipleChoiceScreen> {
  late final List<MultipleChoiceQuestion> _questions = buildMultipleChoice(
    widget.words,
    widget.course,
    widget.sourceLang,
    listening: widget.listening,
  );

  int _idx = 0;
  String? _picked;
  int _score = 0;
  bool _done = false;

  @override
  void initState() {
    super.initState();
    if (widget.listening) _play();
  }

  void _play() {
    final q = _questions[_idx].question;
    speechService.speak(q.word.target, widget.course.ttsLocale);
  }

  void _pick(String option) {
    if (_picked != null) return;
    final correct = correctAnswerOf(_questions[_idx].question);
    setState(() {
      _picked = option;
      if (option == correct) _score++;
    });
  }

  void _next() {
    if (_idx + 1 >= _questions.length) {
      setState(() => _done = true);
    } else {
      setState(() {
        _idx++;
        _picked = null;
      });
      if (widget.listening) _play();
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
                const Text('🎯', style: TextStyle(fontSize: 48)),
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
                  onPressed: () =>
                      Navigator.of(context).popUntil((r) => r.isFirst),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final mcq = _questions[_idx];
    final q = mcq.question;
    final correct = correctAnswerOf(q);

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
                          widget.listening
                              ? t.listeningChoiceTitle
                              : t.multipleChoiceTitle,
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
                      child: widget.listening
                          ? Column(
                              children: [
                                Text(
                                  t.listeningPracticeInstruction,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: palette.muted,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Material(
                                  color: Colors.transparent,
                                  shape: const CircleBorder(),
                                  child: InkWell(
                                    onTap: _play,
                                    customBorder: const CircleBorder(),
                                    child: Container(
                                      width: 72,
                                      height: 72,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                          colors: [
                                            AppColors.primary,
                                            AppColors.indigo,
                                          ],
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.volume_up,
                                        color: Colors.white,
                                        size: 32,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    shownWordOf(q),
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                if (isTargetShown(q))
                                  SpeakButton(
                                    t: t,
                                    text: shownWordOf(q),
                                    locale: widget.course.ttsLocale,
                                  ),
                              ],
                            ),
                    ),
                    const SizedBox(height: 16),
                    for (final option in mcq.options)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _OptionButton(
                          label: option,
                          state: _picked == null
                              ? _OptionState.idle
                              : option == correct
                              ? _OptionState.correct
                              : option == _picked
                              ? _OptionState.wrong
                              : _OptionState.disabled,
                          onTap: () => _pick(option),
                        ),
                      ),
                    if (_picked != null) ...[
                      const SizedBox(height: 8),
                      PrimaryButton(label: t.practiceNext, onPressed: _next),
                    ],
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

enum _OptionState { idle, correct, wrong, disabled }

class _OptionButton extends StatelessWidget {
  final String label;
  final _OptionState state;
  final VoidCallback onTap;

  const _OptionButton({
    required this.label,
    required this.state,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final Color border;
    final Color? background;
    switch (state) {
      case _OptionState.idle:
        border = palette.border;
        background = palette.card;
      case _OptionState.correct:
        border = AppColors.green;
        background = AppColors.green.withValues(alpha: 0.1);
      case _OptionState.wrong:
        border = AppColors.red;
        background = AppColors.red.withValues(alpha: 0.1);
      case _OptionState.disabled:
        border = palette.border;
        background = palette.card.withValues(alpha: 0.5);
    }
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: state == _OptionState.idle ? onTap : null,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: border),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: state == _OptionState.disabled
                  ? palette.muted
                  : palette.foreground,
            ),
          ),
        ),
      ),
    );
  }
}
