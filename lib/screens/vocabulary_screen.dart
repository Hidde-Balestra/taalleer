import 'package:flutter/material.dart';

import '../i18n.dart';
import '../language_course.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets.dart';

class VocabularyScreen extends StatefulWidget {
  final Strings t;
  final Lang lang;
  final LanguageCourse course;
  final int weekNumber;
  final List<Word> words;
  final VoidCallback onOpenPast;
  final VoidCallback onOpenThemes;

  const VocabularyScreen({
    super.key,
    required this.t,
    required this.lang,
    required this.course,
    required this.weekNumber,
    required this.words,
    required this.onOpenPast,
    required this.onOpenThemes,
  });

  @override
  State<VocabularyScreen> createState() => _VocabularyScreenState();
}

class _VocabularyScreenState extends State<VocabularyScreen> {
  String _search = '';
  int? _expandedId;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final t = widget.t;
    final query = _search.toLowerCase();
    final filtered = widget.words
        .where(
          (w) =>
              w.target.toLowerCase().contains(query) ||
              w.nl.toLowerCase().contains(query) ||
              w.en.toLowerCase().contains(query),
        )
        .toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    t.vocabTitle,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      PillBadge(text: '${t.vocabWeek} ${widget.weekNumber}'),
                      const SizedBox(width: 8),
                      // Naar het overzicht van eerdere weken.
                      Material(
                        color: palette.card,
                        borderRadius: BorderRadius.circular(12),
                        child: InkWell(
                          onTap: widget.onOpenPast,
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: palette.border),
                            ),
                            child: Icon(
                              Icons.history,
                              size: 16,
                              color: palette.foreground,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              WeekResetBanner(t: t, lang: widget.lang),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: palette.card,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: palette.border),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.search, size: 16, color: palette.muted),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              onChanged: (v) => setState(() => _search = v),
                              decoration: InputDecoration(
                                hintText: t.vocabSearch,
                                hintStyle: TextStyle(
                                  color: palette.muted,
                                  fontSize: 14,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Naar het thema-scherm: woorden per onderwerp doorbladeren.
                  Material(
                    color: palette.card,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      onTap: widget.onOpenThemes,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: palette.border),
                        ),
                        child: Icon(
                          Icons.category_outlined,
                          size: 16,
                          color: palette.foreground,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            itemCount: filtered.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, i) => WordCard(
              t: t,
              word: filtered[i],
              course: widget.course,
              index: widget.words.indexOf(filtered[i]) + 1,
              expanded: _expandedId == filtered[i].id,
              onTap: () => setState(
                () => _expandedId = _expandedId == filtered[i].id
                    ? null
                    : filtered[i].id,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class WordCard extends StatelessWidget {
  final Strings t;
  final Word word;
  final LanguageCourse course;
  final int index;
  final bool expanded;
  final VoidCallback onTap;

  const WordCard({
    super.key,
    required this.t,
    required this.word,
    required this.course,
    required this.index,
    required this.expanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    if (word.article.isNotEmpty)
                                      TextSpan(
                                        text: '${word.article} ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: palette.muted,
                                        ),
                                      ),
                                    TextSpan(text: word.target),
                                  ],
                                ),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            SpeakButton(
                              t: t,
                              text: word.target,
                              locale: course.ttsLocale,
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(text: '${word.nl} · '),
                              TextSpan(
                                text: word.en,
                                style: const TextStyle(
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                          style: TextStyle(fontSize: 14, color: palette.muted),
                        ),
                      ],
                    ),
                  ),
                  PillBadge(text: '$index'),
                  const SizedBox(width: 8),
                  AnimatedRotation(
                    turns: expanded ? 0.25 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.chevron_right,
                      size: 16,
                      color: palette.muted,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            alignment: Alignment.topCenter,
            child: expanded
                ? Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                    decoration: BoxDecoration(
                      border: Border(top: BorderSide(color: palette.border)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _DetailRow(
                          label: t.vocabPronunciation.toUpperCase(),
                          child: Text(
                            word.pronunciation,
                            style: const TextStyle(
                              fontSize: 14,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                        if (word.isVerb) ...[
                          const SizedBox(height: 8),
                          _DetailRow(
                            label: t.vocabConjugation.toUpperCase(),
                            child: _ConjugationTable(
                              forms: word.present,
                              pronouns: course.pronouns,
                            ),
                          ),
                        ],
                        if (word.past.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          _DetailRow(
                            label: t.vocabPastTense.toUpperCase(),
                            child: _ConjugationTable(
                              forms: word.past,
                              pronouns: course.pronouns,
                            ),
                          ),
                        ],
                        if (word.future.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          _DetailRow(
                            label: t.vocabFutureTense.toUpperCase(),
                            child: _ConjugationTable(
                              forms: word.future,
                              pronouns: course.pronouns,
                            ),
                          ),
                        ],
                        if (word.gerundio.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          _DetailRow(
                            label: t.vocabGerundio.toUpperCase(),
                            child: Row(
                              children: [
                                Text(
                                  word.gerundio,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SpeakButton(
                                  t: t,
                                  text: word.gerundio,
                                  locale: course.ttsLocale,
                                  size: 14,
                                ),
                              ],
                            ),
                          ),
                        ],
                        if (word.exampleTarget.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          _DetailRow(
                            label: t.vocabExample.toUpperCase(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  word.exampleTarget,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  word.exampleNl,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: palette.muted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  )
                : const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final Widget child;

  const _DetailRow({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 76,
          child: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
                color: palette.muted,
              ),
            ),
          ),
        ),
        Expanded(child: child),
      ],
    );
  }
}

/// Toont de zes persoonsvormen van de tegenwoordige tijd naast hun voornaamwoord.
class _ConjugationTable extends StatelessWidget {
  final List<String> forms;
  final List<String> pronouns;

  const _ConjugationTable({required this.forms, required this.pronouns});

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < forms.length && i < pronouns.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                SizedBox(
                  width: 84,
                  child: Text(
                    pronouns[i],
                    style: TextStyle(fontSize: 12, color: palette.muted),
                  ),
                ),
                Expanded(
                  child: Text(
                    forms[i],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
