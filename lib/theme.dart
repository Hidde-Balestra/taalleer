import 'package:flutter/material.dart';

/// Kleuren uit het prototype (shadcn-achtig paars thema).
class AppColors {
  static const primary = Color(0xFF7C3AED);
  static const primaryDark = Color(0xFF6D28D9);
  static const indigo = Color(0xFF4F46E5);
  static const orange = Color(0xFFF97316);
  static const orangeDark = Color(0xFFEA580C);
  static const green = Color(0xFF10B981);
  static const amber = Color(0xFFF59E0B);
  static const red = Color(0xFFEF4444);

  // Licht
  static const lightBackground = Color(0xFFF5F3FF);
  static const lightCard = Colors.white;
  static const lightBorder = Color(0xFFE5E0F0);
  static const lightMuted = Color(0xFF6B7280);
  static const lightForeground = Color(0xFF1F1B2E);

  // Donker
  static const darkBackground = Color(0xFF0F0D1A);
  static const darkCard = Color(0xFF1A1725);
  static const darkBorder = Color(0xFF2A2438);
  static const darkMuted = Color(0xFF9CA3AF);
  static const darkForeground = Color(0xFFF3F1F8);
}

/// Semantische kleuren die per helderheidsmodus verschillen.
class AppPalette extends ThemeExtension<AppPalette> {
  final Color card;
  final Color border;
  final Color muted;
  final Color foreground;

  const AppPalette({
    required this.card,
    required this.border,
    required this.muted,
    required this.foreground,
  });

  static const light = AppPalette(
    card: AppColors.lightCard,
    border: AppColors.lightBorder,
    muted: AppColors.lightMuted,
    foreground: AppColors.lightForeground,
  );

  static const dark = AppPalette(
    card: AppColors.darkCard,
    border: AppColors.darkBorder,
    muted: AppColors.darkMuted,
    foreground: AppColors.darkForeground,
  );

  @override
  AppPalette copyWith({
    Color? card,
    Color? border,
    Color? muted,
    Color? foreground,
  }) {
    return AppPalette(
      card: card ?? this.card,
      border: border ?? this.border,
      muted: muted ?? this.muted,
      foreground: foreground ?? this.foreground,
    );
  }

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) return this;
    return AppPalette(
      card: Color.lerp(card, other.card, t)!,
      border: Color.lerp(border, other.border, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      foreground: Color.lerp(foreground, other.foreground, t)!,
    );
  }

  static AppPalette of(BuildContext context) =>
      Theme.of(context).extension<AppPalette>()!;
}

ThemeData buildTheme({
  required Brightness brightness,
  required bool dyslexiaMode,
}) {
  final isDark = brightness == Brightness.dark;
  final palette = isDark ? AppPalette.dark : AppPalette.light;

  final base = ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: brightness,
      primary: AppColors.primary,
      surface: isDark ? AppColors.darkBackground : AppColors.lightBackground,
    ),
    scaffoldBackgroundColor: isDark
        ? AppColors.darkBackground
        : AppColors.lightBackground,
    extensions: [palette],
  );

  // In dyslexie-modus: iets ruimere letterafstand voor betere leesbaarheid
  // (het prototype wisselt naar het Lexend-font; we gebruiken hier bewust
  // geen extern font zodat de app volledig offline en zonder externe
  // services werkt).
  var textTheme = base.textTheme.apply(
    bodyColor: palette.foreground,
    displayColor: palette.foreground,
  );
  if (dyslexiaMode) {
    TextStyle? spread(TextStyle? s) =>
        s?.copyWith(letterSpacing: (s.letterSpacing ?? 0) + 0.6);
    textTheme = TextTheme(
      displayLarge: spread(textTheme.displayLarge),
      displayMedium: spread(textTheme.displayMedium),
      displaySmall: spread(textTheme.displaySmall),
      headlineLarge: spread(textTheme.headlineLarge),
      headlineMedium: spread(textTheme.headlineMedium),
      headlineSmall: spread(textTheme.headlineSmall),
      titleLarge: spread(textTheme.titleLarge),
      titleMedium: spread(textTheme.titleMedium),
      titleSmall: spread(textTheme.titleSmall),
      bodyLarge: spread(textTheme.bodyLarge),
      bodyMedium: spread(textTheme.bodyMedium),
      bodySmall: spread(textTheme.bodySmall),
      labelLarge: spread(textTheme.labelLarge),
      labelMedium: spread(textTheme.labelMedium),
      labelSmall: spread(textTheme.labelSmall),
    );
  }

  return base.copyWith(textTheme: textTheme);
}
