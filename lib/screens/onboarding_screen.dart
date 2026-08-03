import 'package:flutter/material.dart';

import '../i18n.dart';
import '../languages/registry.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets.dart';

/// Eerste-keer-scherm: laat de gebruiker de app-taal en de taal die hij wil
/// leren kiezen, vóór het home-scherm. De getoonde tekst volgt meteen de
/// gekozen app-taal (zelfde principe als de live-preview in Instellingen).
class OnboardingScreen extends StatefulWidget {
  final void Function(Lang language, String courseId) onComplete;

  const OnboardingScreen({super.key, required this.onComplete});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  Lang _language = Lang.en;
  String _courseId = kCourses.first.id;

  @override
  Widget build(BuildContext context) {
    final t = Strings.of(_language);
    final palette = AppPalette.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TaalLeerLogo(size: 56),
              const SizedBox(height: 20),
              Text(
                t.onboardingTitle,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                t.onboardingSubtitle,
                style: TextStyle(fontSize: 14, color: palette.muted),
              ),
              const SizedBox(height: 32),
              Text(
                t.onboardingLanguageQuestion,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              SegmentRow(
                options: [
                  SegmentOption(
                    label: '🇳🇱 ${t.settingsDutch}',
                    selected: _language == Lang.nl,
                    onTap: () => setState(() => _language = Lang.nl),
                  ),
                  SegmentOption(
                    label: '🇬🇧 ${t.settingsEnglish}',
                    selected: _language == Lang.en,
                    onTap: () => setState(() => _language = Lang.en),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Text(
                t.onboardingCourseQuestion,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              SegmentRow(
                options: [
                  for (final course in kCourses)
                    SegmentOption(
                      label:
                          '${course.flag} '
                          '${_language == Lang.nl ? course.nameNl : course.nameEn}',
                      selected: _courseId == course.id,
                      onTap: () => setState(() => _courseId = course.id),
                    ),
                ],
              ),
              const Spacer(),
              PrimaryButton(
                label: t.onboardingStart,
                onPressed: () => widget.onComplete(_language, _courseId),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
