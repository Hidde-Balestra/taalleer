import 'package:flutter/material.dart';

import '../i18n.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets.dart';

class SettingsScreen extends StatelessWidget {
  final Strings t;
  final AppSettings settings;
  final ValueChanged<AppSettings> onChanged;
  final bool paused;
  final ValueChanged<bool> onPausedChanged;

  const SettingsScreen({
    super.key,
    required this.t,
    required this.settings,
    required this.onChanged,
    required this.paused,
    required this.onPausedChanged,
  });

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      children: [
        Text(
          t.settingsTitle,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),

        // App-taal
        _SettingsCard(
          icon: Icons.translate,
          title: t.settingsLanguage,
          child: _SegmentRow(
            options: [
              _SegmentOption(
                label: '🇳🇱 ${t.settingsDutch}',
                selected: settings.language == Lang.nl,
                onTap: () => onChanged(settings.copyWith(language: Lang.nl)),
              ),
              _SegmentOption(
                label: '🇬🇧 ${t.settingsEnglish}',
                selected: settings.language == Lang.en,
                onTap: () => onChanged(settings.copyWith(language: Lang.en)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Brontaal
        _SettingsCard(
          icon: Icons.menu_book_outlined,
          title: t.settingsSourceLang,
          child: _SegmentRow(
            options: [
              _SegmentOption(
                label: t.settingsDutch,
                selected: settings.sourceLang == Lang.nl,
                onTap: () => onChanged(settings.copyWith(sourceLang: Lang.nl)),
              ),
              _SegmentOption(
                label: t.settingsEnglish,
                selected: settings.sourceLang == Lang.en,
                onTap: () => onChanged(settings.copyWith(sourceLang: Lang.en)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Weergave
        _SettingsCard(
          icon: Icons.dark_mode_outlined,
          title: t.settingsDarkMode,
          child: _SegmentRow(
            options: [
              _SegmentOption(
                label: t.settingsLight,
                icon: Icons.light_mode_outlined,
                selected: settings.darkMode == DarkModeSetting.light,
                onTap: () => onChanged(
                  settings.copyWith(darkMode: DarkModeSetting.light),
                ),
              ),
              _SegmentOption(
                label: t.settingsDark,
                icon: Icons.dark_mode_outlined,
                selected: settings.darkMode == DarkModeSetting.dark,
                onTap: () => onChanged(
                  settings.copyWith(darkMode: DarkModeSetting.dark),
                ),
              ),
              _SegmentOption(
                label: t.settingsSystem,
                icon: Icons.desktop_windows_outlined,
                selected: settings.darkMode == DarkModeSetting.system,
                onTap: () => onChanged(
                  settings.copyWith(darkMode: DarkModeSetting.system),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Dyslexie-modus
        AppCard(
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.text_fields,
                    size: 16,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t.settingsDyslexia,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          t.settingsDyslexiaDesc,
                          style: TextStyle(fontSize: 12, color: palette.muted),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: settings.dyslexiaMode,
                    activeTrackColor: AppColors.primary,
                    onChanged: (v) =>
                        onChanged(settings.copyWith(dyslexiaMode: v)),
                  ),
                ],
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                child: settings.dyslexiaMode
                    ? Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.amber.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          t.settingsDyslexiaActiveNote,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.amber,
                          ),
                        ),
                      )
                    : const SizedBox(width: double.infinity),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Streak pauzeren
        AppCard(
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.pause_circle_outline,
                    size: 16,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t.settingsPause,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          t.settingsPauseDesc,
                          style: TextStyle(fontSize: 12, color: palette.muted),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: paused,
                    activeTrackColor: AppColors.primary,
                    onChanged: onPausedChanged,
                  ),
                ],
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                child: paused
                    ? Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          t.settingsPauseActiveNote,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.primary,
                          ),
                        ),
                      )
                    : const SizedBox(width: double.infinity),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Text(
            t.settingsVersion,
            style: TextStyle(fontSize: 12, color: palette.muted),
          ),
        ),
      ],
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;

  const _SettingsCard({
    required this.icon,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _SegmentOption {
  final String label;
  final IconData? icon;
  final bool selected;
  final VoidCallback onTap;

  const _SegmentOption({
    required this.label,
    this.icon,
    required this.selected,
    required this.onTap,
  });
}

class _SegmentRow extends StatelessWidget {
  final List<_SegmentOption> options;

  const _SegmentRow({required this.options});

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return Row(
      children: [
        for (var i = 0; i < options.length; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          Expanded(
            child: Material(
              color: options[i].selected ? AppColors.primary : palette.card,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: options[i].onTap,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: options[i].selected
                          ? AppColors.primary
                          : palette.border,
                    ),
                  ),
                  child: Column(
                    children: [
                      if (options[i].icon != null) ...[
                        Icon(
                          options[i].icon,
                          size: 14,
                          color: options[i].selected
                              ? Colors.white
                              : palette.foreground,
                        ),
                        const SizedBox(height: 4),
                      ],
                      Text(
                        options[i].label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: options[i].selected
                              ? Colors.white
                              : palette.foreground,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
