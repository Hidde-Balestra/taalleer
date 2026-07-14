import 'package:flutter/material.dart';

import 'theme.dart';
import 'utils.dart';

/// Afgeronde kaart met rand, zoals de `Card` in het prototype.
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: palette.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// Primaire actieknop (paars, volledige breedte).
class PrimaryButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  final Gradient? gradient;

  const PrimaryButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final disabled = onPressed == null;
    return Opacity(
      opacity: disabled ? 0.4 : 1,
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            color: gradient == null ? AppColors.primary : null,
            gradient: gradient,
            borderRadius: BorderRadius.circular(16),
          ),
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              alignment: Alignment.center,
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Cirkel met cijfer (0–10) en voortgangsboog, zoals `GradeCircle`.
class GradeCircle extends StatelessWidget {
  final double grade;

  const GradeCircle({super.key, required this.grade});

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final color = gradeColor(grade);
    return SizedBox(
      width: 128,
      height: 128,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: grade / 10),
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOut,
        builder: (context, pct, _) => CustomPaint(
          painter: _GradeCirclePainter(
            pct: pct,
            color: color,
            trackColor: palette.border,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  grade.toStringAsFixed(1),
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  '/10',
                  style: TextStyle(fontSize: 12, color: palette.muted),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GradeCirclePainter extends CustomPainter {
  final double pct;
  final Color color;
  final Color trackColor;

  _GradeCirclePainter({
    required this.pct,
    required this.color,
    required this.trackColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2 - 6;
    final track = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..color = trackColor;
    final arc = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round
      ..color = color;
    canvas.drawCircle(center, radius, track);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -90 * (3.1415926535 / 180),
      pct * 2 * 3.1415926535,
      false,
      arc,
    );
  }

  @override
  bool shouldRepaint(_GradeCirclePainter old) =>
      old.pct != pct || old.color != color || old.trackColor != trackColor;
}

/// Klein afgerond label, zoals de week-badge.
class PillBadge extends StatelessWidget {
  final String text;
  final Color color;

  const PillBadge({
    super.key,
    required this.text,
    this.color = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }
}

/// Voortgangsbalkje bovenin oefen- en toets-scherm.
class ThinProgressBar extends StatelessWidget {
  final double value;
  final Gradient? gradient;

  const ThinProgressBar({super.key, required this.value, this.gradient});

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: SizedBox(
        height: 6,
        child: Stack(
          children: [
            Container(color: palette.border),
            AnimatedFractionallySizedBox(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              widthFactor: value.clamp(0.0, 1.0),
              heightFactor: 1,
              alignment: Alignment.centerLeft,
              child: Container(
                decoration: BoxDecoration(
                  color: gradient == null ? AppColors.primary : null,
                  gradient: gradient,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Terug-knop in kaartstijl (linksboven op oefen/toets-scherm).
class BackButtonCard extends StatelessWidget {
  final VoidCallback onTap;

  const BackButtonCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return Material(
      color: palette.card,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: palette.border),
          ),
          child: Icon(Icons.arrow_back, size: 18, color: palette.foreground),
        ),
      ),
    );
  }
}
