# TaalLeer 🇪🇸

Een Flutter-app om Spaanse woordjes te leren, gebaseerd op het [Figma Make prototype](https://www.figma.com/make/NKrWAK6t5gLsBVsq8Hevht/Language-Learning-App-Design).

## Functies

- **Home** — weekoverzicht met streak, aantal geleerde woorden en het laatste cijfer
- **Woordenlijst** — 20 woorden per week met uitspraak en voorbeeldzinnen, doorzoekbaar
- **Oefenen** — 10 vragen met directe feedback en uitspraakhint
- **Weektoets** — 10 vragen zonder hints, met cijfer (0–10), geslaagd/onvoldoende en foutenoverzicht
- **Resultaten** — historie van alle weektoetsen
- **Instellingen**
  - App-taal: Nederlands / Engels
  - Brontaal: Nederlands / Engels (bepaalt de vraagrichting)
  - Weergave: licht / donker / systeem
  - **Dyslexie-modus**: kleine typefouten worden geaccepteerd (Levenshtein-afstand op basis van woordlengte) en de tekst krijgt ruimere letterafstand

De app werkt volledig offline en gebruikt geen externe services.

## Ontwikkelen

```bash
flutter pub get
flutter run
```

### Tests

```bash
flutter analyze
flutter test
```

## CI/CD

- **CI** ([.github/workflows/ci.yml](.github/workflows/ci.yml)) — draait bij elke push/PR naar `main`: formattering, analyzer, tests en een debug-APK smoke build.
- **Release** ([.github/workflows/release.yml](.github/workflows/release.yml)) — bij het pushen van een tag `v*` worden release-APK's gebouwd (per ABI + universeel) en als GitHub Release gepubliceerd:

```bash
git tag v1.0.0
git push origin v1.0.0
```

## Projectstructuur

```
lib/
├── main.dart            # App-shell, thema-switching, tabnavigatie
├── models.dart          # Word, QuizResult, Question, AppSettings
├── data.dart            # Woordenlijst + voorbeeldhistorie
├── i18n.dart            # NL/EN vertalingen + datumnotatie
├── utils.dart           # Levenshtein, cijferberekening, vragenbouwers
├── theme.dart           # Licht/donker thema, dyslexie-typografie
├── app_state.dart       # Instellingen + toetshistorie (ChangeNotifier)
├── widgets.dart         # Herbruikbare UI (kaarten, knoppen, cijfercirkel)
└── screens/             # De zeven schermen
```
