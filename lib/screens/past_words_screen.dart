import 'package:flutter/material.dart';

import '../data.dart';
import '../i18n.dart';
import '../models.dart';
import '../theme.dart';
import '../utils.dart';
import '../widgets.dart';

/// Overzicht van alle woorden die de gebruiker in eerdere weken heeft gehad,
/// gegroepeerd per week (nieuwste week eerst).
class PastWordsScreen extends StatefulWidget {
  final Strings t;
  final Lang lang;

  /// De weken (seeds) die al geweest zijn, nieuwste eerst.
  final List<int> weekSeeds;

  const PastWordsScreen({
    super.key,
    required this.t,
    required this.lang,
    required this.weekSeeds,
  });

  @override
  State<PastWordsScreen> createState() => _PastWordsScreenState();
}

class _PastWordsScreenState extends State<PastWordsScreen> {
  int? _expandedSeed;

  @override
  Widget build(BuildContext context) {
    final t = widget.t;
    final palette = AppPalette.of(context);

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
                          t.pastTitle,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          t.pastSubtitle,
                          style: TextStyle(fontSize: 12, color: palette.muted),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (widget.weekSeeds.isEmpty)
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('📚', style: TextStyle(fontSize: 36)),
                        const SizedBox(height: 12),
                        Text(
                          t.pastEmpty,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14, color: palette.muted),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  itemCount: widget.weekSeeds.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, i) {
                    final seed = widget.weekSeeds[i];
                    return _WeekSection(
                      t: t,
                      lang: widget.lang,
                      seed: seed,
                      expanded: _expandedSeed == seed,
                      onTap: () => setState(
                        () =>
                            _expandedSeed = _expandedSeed == seed ? null : seed,
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _WeekSection extends StatelessWidget {
  final Strings t;
  final Lang lang;
  final int seed;
  final bool expanded;
  final VoidCallback onTap;

  const _WeekSection({
    required this.t,
    required this.lang,
    required this.seed,
    required this.expanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final words = wordsForWeek(seed);
    final start = weekStartDate(seed);

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
                        Text(
                          '${t.vocabWeek} ${weekNumberOf(start)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          formatDateLong(start, lang),
                          style: TextStyle(fontSize: 12, color: palette.muted),
                        ),
                      ],
                    ),
                  ),
                  PillBadge(text: '${words.length} ${t.pastWords}'),
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
                        for (final w in words)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text.rich(
                                    TextSpan(
                                      children: [
                                        if (w.article.isNotEmpty)
                                          TextSpan(
                                            text: '${w.article} ',
                                            style: TextStyle(
                                              color: palette.muted,
                                            ),
                                          ),
                                        TextSpan(
                                          text: w.es,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    w.nl,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: palette.muted,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
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
