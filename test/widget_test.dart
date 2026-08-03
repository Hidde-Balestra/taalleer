import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taalleer/app_state.dart';
import 'package:taalleer/data.dart';
import 'package:taalleer/i18n.dart';
import 'package:taalleer/languages/es/es_course.dart';
import 'package:taalleer/main.dart';
import 'package:taalleer/models.dart';
import 'package:taalleer/screens/home_screen.dart';
import 'package:taalleer/storage.dart';
import 'package:taalleer/update_service.dart';

final _course = SpanishCourse();

/// Versie die overal in deze tests als "huidige versie" gemockt wordt.
const _mockAppVersion = '1.9.0';

/// Instellingen die de meeste tests als vertrekpunt willen: onboarding al
/// doorlopen (anders zou elke test eerst dat scherm moeten doorlopen) en
/// Nederlands (de taal waarin bijna alle bestaande verwachtingen hieronder
/// geschreven zijn).
const _defaultTestSettings = AppSettings(
  language: Lang.nl,
  onboardingComplete: true,
);

/// Een [UpdateService] die geen echt netwerkverkeer doet: meldt altijd dat
/// de mock-versie hierboven de nieuwste is, zodat bestaande tests (die niets
/// met updates te maken hebben) deterministisch blijven.
UpdateService _stubUpdateService() => UpdateService(
  client: MockClient(
    (request) async => http.Response(
      '{"tag_name":"v$_mockAppVersion","html_url":"https://example.com/release"}',
      200,
    ),
  ),
);

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({
      // Vooraf ingesteld alsof de onboarding al is doorlopen, zodat
      // pumpApp() standaard direct het home-scherm toont i.p.v. onboarding.
      // Losstaande onboarding-tests zetten hun eigen (lege) staat op.
      AppStorage.settingsKey: jsonEncode(_defaultTestSettings.toJson()),
    });
    PackageInfo.setMockInitialValues(
      appName: 'TaalLeer',
      packageName: 'com.example.taalleer',
      version: _mockAppVersion,
      buildNumber: '9',
      buildSignature: '',
    );
  });

  Future<AppState> pumpApp(WidgetTester tester, {AppState? state}) async {
    final appState = state ?? await AppState.load();
    await tester.pumpWidget(
      TaalLeerApp(appState: appState, updateService: _stubUpdateService()),
    );
    await tester.pumpAndSettle();
    return appState;
  }

  /// Tikt op het tandwiel-icoon (Instellingen zit niet meer in de onderbalk,
  /// maar wordt als aparte pagina gepusht).
  Future<void> openSettings(WidgetTester tester) async {
    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
  }

  /// Gaat terug van het (gepushte) instellingenscherm naar het onderliggende
  /// tabblad.
  Future<void> closeSettings(WidgetTester tester) async {
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
  }

  /// Scrollt het home-scherm tot [target] in beeld is (de lijst is langer dan
  /// het testvenster).
  Future<void> scrollHome(WidgetTester tester, Finder target) async {
    await tester.scrollUntilVisible(
      target,
      150,
      scrollable: find.descendant(
        of: find.byType(HomeScreen),
        matching: find.byType(Scrollable),
      ),
    );
  }

  /// Scrollt het instellingen-scherm tot [target] in beeld is. `ensureVisible`
  /// (i.p.v. `scrollUntilVisible`) berekent de precieze scrollpositie: de
  /// instellingenlijst is een niet-lazy `ListView`, dus elk kind staat sowieso
  /// al in de widgetboom — `scrollUntilVisible` zou daardoor meteen "klaar"
  /// zijn zonder het element ook echt binnen het testvenster te krijgen.
  Future<void> scrollSettings(WidgetTester tester, Finder target) async {
    await tester.ensureVisible(target);
    await tester.pumpAndSettle();
  }

  group('Navigatie', () {
    testWidgets('home-scherm toont begroeting en actieknoppen', (tester) async {
      await pumpApp(tester);
      expect(find.text('Welkom terug! 👋'), findsOneWidget);
      expect(find.text('Oefenen'), findsOneWidget);
      expect(find.text('Woordentoets'), findsOneWidget);
      expect(find.text('Vervoegingstoets'), findsOneWidget);

      await scrollHome(tester, find.text('Laatste cijfer'));
      expect(find.text('Laatste cijfer'), findsOneWidget);
    });

    testWidgets('zonder opgeslagen data is er geen dummyhistorie', (
      tester,
    ) async {
      await pumpApp(tester);
      await scrollHome(tester, find.text('Nog geen toets gemaakt'));
      expect(find.text('Nog geen toets gemaakt'), findsOneWidget);

      await tester.tap(find.text('Resultaten'));
      await tester.pumpAndSettle();
      expect(find.text('Nog geen resultaten beschikbaar.'), findsOneWidget);
      expect(find.text('0 weken'), findsOneWidget);
    });

    testWidgets('tabbladen wisselen tussen de schermen', (tester) async {
      await pumpApp(tester);

      await tester.tap(find.text('Woorden'));
      await tester.pumpAndSettle();
      expect(find.text('Woordenlijst'), findsOneWidget);

      await openSettings(tester);
      expect(find.text('App-taal'), findsOneWidget);
      await closeSettings(tester);

      await tester.tap(find.text('Huis'));
      await tester.pumpAndSettle();
      expect(find.text('Welkom terug! 👋'), findsOneWidget);
    });
  });

  group('Woordenlijst', () {
    final weekWords = wordsForWeek(_course, currentWeekSeed());

    testWidgets('toont de woorden van deze week', (tester) async {
      await pumpApp(tester);
      await tester.tap(find.text('Woorden'));
      await tester.pumpAndSettle();

      // De eerste woorden van deze week staan bovenaan de lijst. De kop kan
      // een lidwoord bevatten ("la casa"), dus zoeken we op deeltekst.
      expect(find.textContaining(weekWords[0].target), findsWidgets);
      expect(find.textContaining(weekWords[1].target), findsWidgets);
    });

    testWidgets('zoeken filtert de lijst', (tester) async {
      final target = weekWords.first;
      // Een ander woord (zichtbaar bovenaan) dat niet op de zoekterm matcht.
      final other = weekWords
          .skip(1)
          .take(4)
          .firstWhere(
            (w) =>
                !w.target.contains(target.target) &&
                !w.nl.contains(target.target) &&
                !w.en.contains(target.target),
          );

      await pumpApp(tester);
      await tester.tap(find.text('Woorden'));
      await tester.pumpAndSettle();

      expect(find.textContaining(other.target), findsWidgets);

      await tester.enterText(find.byType(TextField), target.target);
      await tester.pumpAndSettle();

      expect(find.textContaining(target.target), findsWidgets);
      expect(find.textContaining(other.target), findsNothing);
    });

    testWidgets('woord uitklappen toont de uitspraak', (tester) async {
      // Kies een woord waarvan de uitspraak afwijkt van het woord zelf
      // (bij éénlettergrepige woorden zijn die gelijk).
      final target = weekWords
          .take(5)
          .firstWhere((w) => w.pronunciation != w.target);

      await pumpApp(tester);
      await tester.tap(find.text('Woorden'));
      await tester.pumpAndSettle();

      await tester.tap(find.textContaining(target.target).first);
      await tester.pumpAndSettle();

      expect(find.text(target.pronunciation), findsOneWidget);
    });
  });

  group('Instellingen', () {
    testWidgets('taal wisselen naar Engels vertaalt de UI', (tester) async {
      await pumpApp(tester);
      await openSettings(tester);

      await scrollSettings(tester, find.text('🇬🇧 Engels'));
      await tester.tap(find.text('🇬🇧 Engels'));
      await tester.pumpAndSettle();

      expect(find.text('App Language'), findsOneWidget);
      await closeSettings(tester);
      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();
      expect(find.text('Welcome back! 👋'), findsOneWidget);
    });

    testWidgets('gewijzigde instellingen worden op het apparaat opgeslagen', (
      tester,
    ) async {
      await pumpApp(tester);
      await openSettings(tester);

      await scrollSettings(tester, find.text('Donker'));
      await tester.tap(find.text('Donker'));
      await tester.pumpAndSettle();
      // Scroll op basis van een unieke tekst i.p.v. `find.byType(Switch).first`:
      // die laatste gooit een StateError zodra er nog geen enkele Switch
      // gebouwd is (bv. vóór scrollen), in plaats van gewoon door te scrollen.
      await scrollSettings(tester, find.text('Dyslexie Modus'));
      await tester.tap(find.byType(Switch).first);
      await tester.pumpAndSettle();

      // Een verse AppState leest dezelfde lokale opslag: de keuzes zijn er nog.
      final reloaded = await AppState.load();
      expect(reloaded.settings.darkMode, DarkModeSetting.dark);
      expect(reloaded.settings.dyslexiaMode, isTrue);
    });

    testWidgets('dyslexie-schakelaar toont uitlegtekst', (tester) async {
      await pumpApp(tester);
      await openSettings(tester);

      // Scroll op basis van een unieke tekst i.p.v. `find.byType(Switch).first`:
      // die laatste gooit een StateError zodra er nog geen enkele Switch
      // gebouwd is (bv. vóór scrollen), in plaats van gewoon door te scrollen.
      await scrollSettings(tester, find.text('Dyslexie Modus'));
      await tester.tap(find.byType(Switch).first);
      await tester.pumpAndSettle();

      expect(
        find.text(
          'Actief: kleine spelfouten worden geaccepteerd op basis van woordlengte.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('donkere modus kiezen past het thema aan', (tester) async {
      await pumpApp(tester);
      await openSettings(tester);

      await scrollSettings(tester, find.text('Donker'));
      await tester.tap(find.text('Donker'));
      await tester.pumpAndSettle();

      final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(app.themeMode, ThemeMode.dark);
    });
  });

  group('Oefenen', () {
    testWidgets(
      'fout antwoord toont het juiste antwoord, daarna volgende vraag',
      (tester) async {
        await pumpApp(tester);
        await tester.tap(find.text('Oefenen'));
        await tester.pumpAndSettle();

        expect(find.text('1/10'), findsOneWidget);

        await tester.enterText(find.byType(TextField), 'zeker-fout-antwoord');
        await tester.pumpAndSettle();
        await tester.tap(find.text('Controleren'));
        await tester.pumpAndSettle();

        expect(find.text('Helaas!'), findsOneWidget);
        expect(find.textContaining('Correct antwoord'), findsOneWidget);

        await tester.tap(find.text('Volgende →'));
        await tester.pumpAndSettle();
        expect(find.text('2/10'), findsOneWidget);
      },
    );
  });

  group('Weektoets', () {
    testWidgets(
      'volledige toets met alle antwoorden fout geeft cijfer 0 en wordt lokaal opgeslagen',
      (tester) async {
        final state = await pumpApp(tester);

        await tester.tap(find.text('Woordentoets'));
        await tester.pumpAndSettle();
        expect(find.text('Weektoets'), findsOneWidget);
        expect(find.text('Geen hints beschikbaar'), findsOneWidget);

        for (var i = 0; i < 10; i++) {
          await tester.enterText(find.byType(TextField), 'zeker-fout-antwoord');
          await tester.pumpAndSettle();
          await tester.tap(find.text('Bevestigen →'));
          await tester.pumpAndSettle();
        }

        // Resultaatscherm
        expect(find.text('0.0'), findsOneWidget);
        expect(find.text('Onvoldoende'), findsOneWidget);
        expect(find.text('Foute woorden'), findsOneWidget);
        expect(state.history, hasLength(1));
        expect(state.history.first.grade, 0.0);
        expect(state.history.first.wrongWordIds, hasLength(10));

        // Alleen woorden van deze week zaten in de toets.
        final weekIds = wordsForWeek(
          _course,
          currentWeekSeed(),
        ).map((w) => w.id).toSet();
        for (final id in state.history.first.wrongWordIds) {
          expect(weekIds, contains(id));
        }

        // Het resultaat staat op het apparaat: een verse AppState ziet het ook.
        final reloaded = await AppState.load();
        expect(reloaded.history, hasLength(1));
        expect(reloaded.history.first.grade, 0.0);

        // Terug naar huis (knop staat onderaan de scrollbare lijst)
        await tester.dragUntilVisible(
          find.text('Terug naar huis'),
          find.byType(ListView),
          const Offset(0, -200),
        );
        await tester.tap(find.text('Terug naar huis'));
        await tester.pumpAndSettle();
        expect(find.text('Welkom terug! 👋'), findsOneWidget);

        // Deze week is nu een toets afgerond: de knoppen zijn op slot tot
        // de wekelijkse reset (één toets per week).
        expect(find.text('Toets van deze week afgerond ✓'), findsOneWidget);
        expect(find.text('Woordentoets'), findsNothing);
        expect(find.text('Vervoegingstoets'), findsNothing);
      },
    );
  });

  group('Vervoegingstoets', () {
    testWidgets('werkwoord vervoegen en resultaat opslaan', (tester) async {
      final state = await pumpApp(tester);

      await tester.tap(find.text('Vervoegingstoets'));
      await tester.pumpAndSettle();
      expect(find.text('Vervoeg in de tegenwoordige tijd'), findsOneWidget);

      for (var i = 0; i < 10; i++) {
        await tester.enterText(find.byType(TextField), 'fout');
        await tester.pumpAndSettle();
        await tester.tap(find.text('Bevestigen →'));
        await tester.pumpAndSettle();
      }

      expect(find.text('0.0'), findsOneWidget);
      expect(state.history, hasLength(1));
      // De foute woorden zijn werkwoorden.
      for (final id in state.history.first.wrongWordIds) {
        expect(_course.wordById(id)!.isVerb, isTrue);
      }
    });
  });

  group('Weekreset', () {
    testWidgets('home toont wanneer de woorden en toets resetten', (
      tester,
    ) async {
      await pumpApp(tester);
      expect(find.textContaining('Nieuwe woorden en toets'), findsOneWidget);
      // De resetdatum (eerstvolgende maandag) staat eronder.
      expect(
        find.text(formatDateLong(nextWordReset(), Lang.nl)),
        findsOneWidget,
      );
    });
  });

  group('Eerdere woorden', () {
    testWidgets('scherm is bereikbaar vanuit de woordenlijst', (tester) async {
      await pumpApp(tester);
      await tester.tap(find.text('Woorden'));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.history));
      await tester.pumpAndSettle();

      expect(find.text('Eerdere woorden'), findsOneWidget);
      // Een verse gebruiker begint deze week en heeft nog geen eerdere weken.
      expect(find.textContaining('geen eerdere weken'), findsOneWidget);
    });

    testWidgets('toont eerdere weken met hun woorden', (tester) async {
      // Een gebruiker die drie weken geleden begon.
      final startWeek = currentWeekSeed();
      final later = AppState(
        settings: _defaultTestSettings,
        nowWeek: () => startWeek + 3,
        streakState: StreakState(firstWeek: startWeek),
      );

      await pumpApp(tester, state: later);
      await tester.tap(find.text('Woorden'));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.history));
      await tester.pumpAndSettle();

      // Drie eerdere weken, elk met 20 woorden.
      expect(find.textContaining('20 woorden'), findsNWidgets(3));

      // Uitklappen toont de woorden van die week.
      final seed = later.pastWeekSeeds.first;
      final firstWord = wordsForWeek(_course, seed).first;
      await tester.tap(find.textContaining('20 woorden').first);
      await tester.pumpAndSettle();
      expect(find.textContaining(firstWord.target), findsWidgets);
    });
  });

  group('Pauze', () {
    testWidgets('pauze verbergt de toetsknoppen op het home-scherm', (
      tester,
    ) async {
      await pumpApp(tester);
      await openSettings(tester);

      // Scroll de pauze-kaart in beeld en zet de pauze aan (de laatste
      // switch; dyslexie is de eerste).
      await scrollSettings(tester, find.text('Streak pauzeren'));
      await tester.tap(find.byType(Switch).last);
      await tester.pumpAndSettle();

      // Bevestigingsnotitie verschijnt op het instellingen-scherm.
      expect(find.textContaining('je kunt geen toetsen maken'), findsOneWidget);

      // Terug naar het (nooit-verlaten) home-tabblad erachter.
      await closeSettings(tester);

      expect(find.text('Streak gepauzeerd'), findsOneWidget);
      expect(find.text('Woordentoets'), findsNothing);
      expect(find.text('Vervoegingstoets'), findsNothing);
    });
  });

  group('Onboarding', () {
    /// Een écht verse start: negeert de vooraf ingestelde (onboarding-
    /// voltooide) staat uit de globale setUp.
    Future<AppState> pumpFreshApp(WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});
      final appState = await AppState.load();
      await tester.pumpWidget(
        TaalLeerApp(appState: appState, updateService: _stubUpdateService()),
      );
      await tester.pumpAndSettle();
      return appState;
    }

    testWidgets('verse gebruiker ziet eerst het onboarding-scherm', (
      tester,
    ) async {
      await pumpFreshApp(tester);

      // Standaard Engels, met Spaans als (enige) cursuskeuze.
      expect(find.text('Welcome to TaalLeer'), findsOneWidget);
      expect(find.text('🇪🇸 Spanish'), findsOneWidget);
      expect(find.text('Home'), findsNothing);
    });

    testWidgets(
      'kiezen en starten opent het home-scherm en onthoudt de keuze',
      (tester) async {
        await pumpFreshApp(tester);

        await tester.tap(find.text('🇳🇱 Nederlands'));
        await tester.pumpAndSettle();
        expect(find.text('Welkom bij TaalLeer'), findsOneWidget);

        await tester.tap(find.text('Beginnen'));
        await tester.pumpAndSettle();

        expect(find.text('Welkom terug! 👋'), findsOneWidget);

        // De keuze staat op het apparaat: een verse AppState ziet 'm ook.
        final reloaded = await AppState.load();
        expect(reloaded.settings.onboardingComplete, isTrue);
        expect(reloaded.settings.language, Lang.nl);
        expect(reloaded.settings.sourceLang, Lang.nl);
        expect(reloaded.settings.courseId, 'es');
      },
    );

    testWidgets('na een herstart wordt de onboarding niet opnieuw getoond', (
      tester,
    ) async {
      await pumpFreshApp(tester);
      await tester.tap(find.text('Get started'));
      await tester.pumpAndSettle();
      expect(find.text('Welcome back! 👋'), findsOneWidget);

      // Nieuwe AppState, alsof de app opnieuw is gestart.
      final restarted = await AppState.load();
      await tester.pumpWidget(
        TaalLeerApp(appState: restarted, updateService: _stubUpdateService()),
      );
      await tester.pumpAndSettle();
      expect(find.text('Welcome back! 👋'), findsOneWidget);
    });
  });
}
