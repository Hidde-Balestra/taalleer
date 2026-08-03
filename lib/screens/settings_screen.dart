import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../i18n.dart';
import '../languages/registry.dart';
import '../models.dart';
import '../theme.dart';
import '../update_service.dart';
import '../widgets.dart';

class SettingsScreen extends StatelessWidget {
  final Strings t;
  final AppSettings settings;
  final ValueChanged<AppSettings> onChanged;
  final bool paused;
  final ValueChanged<bool> onPausedChanged;

  /// Optioneel injecteerbaar voor tests; standaard een echte [UpdateService].
  final UpdateService? updateService;

  const SettingsScreen({
    super.key,
    required this.t,
    required this.settings,
    required this.onChanged,
    required this.paused,
    required this.onPausedChanged,
    this.updateService,
  });

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);

    // Instellingen is geen tabblad meer (zat eerst in de onderbalk, samen
    // met de andere tabbladen in een IndexedStack), maar wordt nu als aparte
    // pagina gepusht — dus hier wél een eigen Scaffold en terugknop nodig.
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          children: [
            Row(
              children: [
                BackButtonCard(onTap: () => Navigator.of(context).pop()),
                const SizedBox(width: 12),
                Text(
                  t.settingsTitle,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Taal die je leert
            _SettingsCard(
              icon: Icons.public,
              title: t.settingsCourse,
              child: SegmentRow(
                options: [
                  for (final course in kCourses)
                    SegmentOption(
                      label:
                          '${course.flag} '
                          '${settings.language == Lang.nl ? course.nameNl : course.nameEn}',
                      selected: settings.courseId == course.id,
                      onTap: () =>
                          onChanged(settings.copyWith(courseId: course.id)),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // App-taal
            _SettingsCard(
              icon: Icons.translate,
              title: t.settingsLanguage,
              child: SegmentRow(
                options: [
                  SegmentOption(
                    label: '🇳🇱 ${t.settingsDutch}',
                    selected: settings.language == Lang.nl,
                    onTap: () =>
                        onChanged(settings.copyWith(language: Lang.nl)),
                  ),
                  SegmentOption(
                    label: '🇬🇧 ${t.settingsEnglish}',
                    selected: settings.language == Lang.en,
                    onTap: () =>
                        onChanged(settings.copyWith(language: Lang.en)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Brontaal
            _SettingsCard(
              icon: Icons.menu_book_outlined,
              title: t.settingsSourceLang,
              child: SegmentRow(
                options: [
                  SegmentOption(
                    label: t.settingsDutch,
                    selected: settings.sourceLang == Lang.nl,
                    onTap: () =>
                        onChanged(settings.copyWith(sourceLang: Lang.nl)),
                  ),
                  SegmentOption(
                    label: t.settingsEnglish,
                    selected: settings.sourceLang == Lang.en,
                    onTap: () =>
                        onChanged(settings.copyWith(sourceLang: Lang.en)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Weergave
            _SettingsCard(
              icon: Icons.dark_mode_outlined,
              title: t.settingsDarkMode,
              child: SegmentRow(
                options: [
                  SegmentOption(
                    label: t.settingsLight,
                    icon: Icons.light_mode_outlined,
                    selected: settings.darkMode == DarkModeSetting.light,
                    onTap: () => onChanged(
                      settings.copyWith(darkMode: DarkModeSetting.light),
                    ),
                  ),
                  SegmentOption(
                    label: t.settingsDark,
                    icon: Icons.dark_mode_outlined,
                    selected: settings.darkMode == DarkModeSetting.dark,
                    onTap: () => onChanged(
                      settings.copyWith(darkMode: DarkModeSetting.dark),
                    ),
                  ),
                  SegmentOption(
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
                              style: TextStyle(
                                fontSize: 12,
                                color: palette.muted,
                              ),
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
                              style: TextStyle(
                                fontSize: 12,
                                color: palette.muted,
                              ),
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
            _UpdatesCard(t: t, updateService: updateService ?? UpdateService()),
          ],
        ),
      ),
    );
  }
}

/// Toont de huidige versie en controleert automatisch (en op verzoek) of er
/// een nieuwere release op GitHub staat.
class _UpdatesCard extends StatefulWidget {
  final Strings t;
  final UpdateService updateService;

  const _UpdatesCard({required this.t, required this.updateService});

  @override
  State<_UpdatesCard> createState() => _UpdatesCardState();
}

class _UpdateInfo {
  final String version;
  final UpdateCheckResult result;

  const _UpdateInfo({required this.version, required this.result});
}

class _UpdatesCardState extends State<_UpdatesCard> {
  // `late final` + FutureBuilder (i.p.v. handmatig setState/mounted-gedoe):
  // de Future wordt precies één keer aangemaakt bij het aanmaken van deze
  // State, en FutureBuilder handelt de widgetlevenscyclus er zelf veilig
  // omheen af — geen risico op setState tijdens de build-fase of op een
  // vergeten mounted-check.
  late Future<_UpdateInfo> _future = _check();

  Future<_UpdateInfo> _check() async {
    final info = await PackageInfo.fromPlatform();
    final result = await widget.updateService.checkForUpdate(info.version);
    return _UpdateInfo(version: info.version, result: result);
  }

  void _retry() => setState(() => _future = _check());

  @override
  Widget build(BuildContext context) {
    final t = widget.t;
    final palette = AppPalette.of(context);
    return AppCard(
      child: FutureBuilder<_UpdateInfo>(
        future: _future,
        builder: (context, snapshot) {
          final info = snapshot.data;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.system_update_alt,
                    size: 16,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    t.updatesTitle,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  if (info != null)
                    Text(
                      t.currentVersionLabel(info.version),
                      style: TextStyle(fontSize: 12, color: palette.muted),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              _buildStatus(palette, info),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatus(AppPalette palette, _UpdateInfo? info) {
    final t = widget.t;

    if (info == null) {
      // Bewust een statisch icoon i.p.v. een ronddraaiende spinner: de check
      // duurt doorgaans maar een fractie van een seconde, en een
      // oneindig-lopende animatie zou `pumpAndSettle()` in tests blokkeren.
      return Row(
        children: [
          Icon(Icons.sync, size: 14, color: palette.muted),
          const SizedBox(width: 8),
          Text(
            t.updatesChecking,
            style: TextStyle(fontSize: 12, color: palette.muted),
          ),
        ],
      );
    }

    final result = info.result;
    switch (result.status) {
      case UpdateStatus.upToDate:
        return Row(
          children: [
            const Icon(
              Icons.check_circle_outline,
              size: 14,
              color: AppColors.green,
            ),
            const SizedBox(width: 6),
            Text(
              t.updatesUpToDate,
              style: const TextStyle(fontSize: 12, color: AppColors.green),
            ),
          ],
        );
      case UpdateStatus.updateAvailable:
        final url = result.releaseUrl;
        return Row(
          children: [
            Expanded(
              child: Text(
                t.updateAvailableLabel(result.latestVersion ?? ''),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.amber,
                ),
              ),
            ),
            TextButton(
              onPressed: url == null
                  ? null
                  : () => widget.updateService.openReleasePage(url),
              child: Text(t.updatesViewRelease),
            ),
          ],
        );
      case UpdateStatus.checkFailed:
        return Row(
          children: [
            Expanded(
              child: Text(
                t.updatesFailed,
                style: TextStyle(fontSize: 12, color: palette.muted),
              ),
            ),
            TextButton(onPressed: _retry, child: Text(t.updatesCheckNow)),
          ],
        );
    }
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
