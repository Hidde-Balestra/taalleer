import 'package:flutter/material.dart';

import '../i18n.dart';
import '../models.dart';
import '../theme.dart';
import '../utils.dart';
import '../widgets.dart';

/// Geheugenspel: tik twee tegels om. Bij een match (doeltaalwoord +
/// vertaling van hetzelfde woord) blijven ze open, anders klappen ze na
/// even om. Ongegradeerd — het aantal beurten is een lichte score, geen
/// cijfer of `QuizResult`.
class MemoryGameScreen extends StatefulWidget {
  final Strings t;
  final Lang sourceLang;
  final List<Word> words;

  const MemoryGameScreen({
    super.key,
    required this.t,
    required this.sourceLang,
    required this.words,
  });

  @override
  State<MemoryGameScreen> createState() => _MemoryGameScreenState();
}

class _MemoryGameScreenState extends State<MemoryGameScreen> {
  late final List<MemoryTile> _tiles = buildMemoryGame(
    widget.words,
    widget.sourceLang,
  );
  final Set<int> _matched = {};
  int? _first;
  int? _second;
  bool _locked = false;
  int _tries = 0;

  bool get _done => _matched.length == _tiles.length;

  void _tap(int i) {
    if (_locked || _matched.contains(i) || i == _first) return;
    setState(() {
      if (_first == null) {
        _first = i;
        return;
      }
      _second = i;
      _tries++;
      if (tilesMatch(_tiles[_first!], _tiles[i])) {
        _matched.addAll([_first!, i]);
        _first = null;
        _second = null;
        return;
      }
      _locked = true;
      Future.delayed(const Duration(milliseconds: 700), () {
        if (!mounted) return;
        setState(() {
          _first = null;
          _second = null;
          _locked = false;
        });
      });
    });
  }

  bool _isOpen(int i) => _matched.contains(i) || i == _first || i == _second;

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
                const Text('🃏', style: TextStyle(fontSize: 48)),
                const SizedBox(height: 24),
                Text(
                  t.memoryGameWin,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  t.memoryGameTries(_tries),
                  style: TextStyle(fontSize: 14, color: palette.muted),
                ),
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
                    child: Text(
                      t.memoryGameTitle,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    t.memoryGameTries(_tries),
                    style: TextStyle(fontSize: 12, color: palette.muted),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: _tiles.length,
                  itemBuilder: (context, i) => _TileCard(
                    open: _isOpen(i),
                    matched: _matched.contains(i),
                    text: _tiles[i].text,
                    onTap: () => _tap(i),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TileCard extends StatelessWidget {
  final bool open;
  final bool matched;
  final String text;
  final VoidCallback onTap;

  const _TileCard({
    required this.open,
    required this.matched,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final background = matched
        ? AppColors.green.withValues(alpha: 0.12)
        : open
        ? AppColors.primary.withValues(alpha: 0.1)
        : palette.card;
    final border = matched
        ? AppColors.green
        : open
        ? AppColors.primary
        : palette.border;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: matched ? null : onTap,
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: border),
          ),
          alignment: Alignment.center,
          padding: const EdgeInsets.all(6),
          child: open
              ? Text(
                  text,
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: palette.foreground,
                  ),
                )
              : Icon(
                  Icons.help_outline,
                  color: palette.muted.withValues(alpha: 0.5),
                ),
        ),
      ),
    );
  }
}
