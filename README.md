# TaalLeer 🇪🇸

Een Flutter-app om Spaanse woordjes te leren, gebaseerd op het [Figma Make prototype](https://www.figma.com/make/NKrWAK6t5gLsBVsq8Hevht/Language-Learning-App-Design).

## Functies

- **Willekeurige woorden per week** — een Spaans woordenboek van ~1500 woorden (thematisch geordend: getallen, tijd, familie, lichaam, huis, eten, dieren, natuur, stad, reizen, kleding, kleuren, school, beroepen, technologie, gezondheid, sport, kunst, geld, gevoelens, bijvoeglijke naamwoorden, werkwoorden en kleine woorden). Elke week worden hieruit **20 willekeurige woorden** getrokken. De trekking is deterministisch per kalenderweek (jaaroverschrijdend, dus niet-herhalend): binnen één week tonen de woordenlijst, oefening en toets dezelfde woorden. Het boek kan onbeperkt groeien (zie [Woordenboek uitbreiden](#woordenboek-uitbreiden-richting-10000-woorden))
- **Automatische uitspraak** — Spaans is fonetisch regelmatig; de uitspraakhint (bijv. `casa` → `KAH-sah`) wordt uit de spelling afgeleid, inclusief klemtoonregels en accenten
- **Home** — weekoverzicht met streak, aantal woorden van deze week en het laatste cijfer
- **Woordenlijst** — de 20 woorden van deze week met uitspraak en voorbeeldzinnen, doorzoekbaar
- **Oefenen** — 10 vragen met directe feedback en uitspraakhint
- **Weektoets** — 10 vragen zonder hints, met cijfer (0–10), geslaagd/onvoldoende en foutenoverzicht
- **Resultaten** — historie van alle weektoetsen
- **Instellingen**
  - App-taal: Nederlands / Engels
  - Brontaal: Nederlands / Engels (bepaalt de vraagrichting)
  - Weergave: licht / donker / systeem
  - **Dyslexie-modus**: kleine typefouten worden geaccepteerd (Levenshtein-afstand op basis van woordlengte) en de tekst krijgt ruimere letterafstand

Alle data (instellingen en toetshistorie) wordt lokaal op het apparaat opgeslagen via `shared_preferences`. De app werkt volledig offline; er verlaat geen data het apparaat.

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

## Woordenboek uitbreiden (richting 10.000+ woorden)

Het woordenboek staat in [lib/word_book.dart](lib/word_book.dart) en de willekeurige weektrekking werkt met **elke omvang** — 1000, 10.000 of meer woorden. Hoe groter het boek, hoe meer verschillende woorden je in de loop van de weken tegenkomt. Nieuwe woorden toevoegen gaat met de import-tool:

```bash
# Valideren (duplicaten, lege velden) + statistieken
dart run tool/import_words.dart --check

# Batch importeren uit een CSV (formaat: spaans;nederlands;engels)
dart run tool/import_words.dart nieuwe_woorden.csv
dart format lib/word_book.dart
flutter test
```

De tool slaat duplicaten automatisch over en breidt het boek uit met de nieuwe woorden. De uitspraak wordt automatisch gegenereerd, dus een nieuw woord heeft alleen de drie vertalingen nodig.

Bronnen om naar 10.000+ te groeien: frequentielijsten en open woordenboekdata (bijv. FreeDict of Wiktionary-exports) omzetten naar het CSV-formaat, of het boek in batches laten aanvullen en reviewen. De tests bewaken automatisch dat er geen duplicaten of lege velden in het boek terechtkomen.

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
├── models.dart          # Word, QuizResult, Question, AppSettings (+ JSON)
├── word_book.dart       # Woordenboek: 1000 lemma's (es, nl, en)
├── data.dart            # Weekrotatie over het woordenboek
├── pronounce.dart       # Automatische uitspraak (lettergrepen + klemtoon)
├── i18n.dart            # NL/EN vertalingen + datumnotatie
├── utils.dart           # Levenshtein, cijferberekening, vragenbouwers
├── theme.dart           # Licht/donker thema, dyslexie-typografie
├── app_state.dart       # Instellingen + toetshistorie (ChangeNotifier)
├── storage.dart         # Lokale opslag op het apparaat (shared_preferences)
├── widgets.dart         # Herbruikbare UI (kaarten, knoppen, cijfercirkel)
└── screens/             # De zeven schermen
```
