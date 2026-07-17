# TaalLeer 🇪🇸

Een Flutter-app om Spaanse woordjes te leren, gebaseerd op het [Figma Make prototype](https://www.figma.com/make/NKrWAK6t5gLsBVsq8Hevht/Language-Learning-App-Design).

## Functies

- **Willekeurige woorden per week** — een Spaans woordenboek van ~1500 woorden (thematisch geordend: getallen, tijd, familie, lichaam, huis, eten, dieren, natuur, stad, reizen, kleding, kleuren, school, beroepen, technologie, gezondheid, sport, kunst, geld, gevoelens, bijvoeglijke naamwoorden, werkwoorden en kleine woorden). Elke week worden hieruit **20 willekeurige woorden** getrokken. De trekking is deterministisch per kalenderweek (jaaroverschrijdend, dus niet-herhalend): binnen één week tonen de woordenlijst, oefening en toets dezelfde woorden. Het boek kan onbeperkt groeien (zie [Woordenboek uitbreiden](#woordenboek-uitbreiden-richting-10000-woorden))
- **Automatische uitspraak** — Spaans is fonetisch regelmatig; de uitspraakhint (bijv. `casa` → `KAH-sah`) wordt uit de spelling afgeleid, inclusief klemtoonregels en accenten
- **Grammatica per woord** — in de woordenlijst toont elk zelfstandig naamwoord zijn lidwoord (**el**/**la**) en elk werkwoord de volledige tegenwoordige tijd (presente de indicativo). Beide worden automatisch afgeleid (`grammar.dart`): regelmatige vervoegingen via vaste uitgangen, onregelmatige/stamwisselende werkwoorden via tabellen, en het geslacht via uitgangsregels met een uitzonderingenlijst
- **Home** — weekoverzicht met streak, aantal woorden van deze week en het laatste cijfer
- **Woordenlijst** — de 20 woorden van deze week met uitspraak en voorbeeldzinnen, doorzoekbaar
- **Oefenen** — 10 vragen met directe feedback en uitspraakhint
- **Woordentoets** — 10 vertaalvragen zonder hints, met cijfer (0–10), geslaagd/onvoldoende en foutenoverzicht
- **Vervoegingstoets** — 10 werkwoorden in een willekeurige persoon vervoegen (tegenwoordige tijd)
- **Wekelijkse streak** — één afgeronde toets (woorden óf vervoegingen) per week houdt de streak in stand; mis je een week, dan vervalt hij
- **Streak pauzeren** — via een toggle in de instellingen; tijdens de pauze kun je geen toetsen maken en staat de streak stil (kan niet omhoog en niet gereset worden) tot je de pauze weer uitschakelt
- **Duidelijke weekreset** — op het home- en woordenscherm staat wanneer de woorden en de toets resetten (elke maandag), met het aantal dagen en de datum
- **Eerdere woorden** — een apart scherm (via het klok-icoon in de woordenlijst) met alle woorden die je eerder hebt gehad, gegroepeerd per week
- **Resultaten** — historie van alle afgeronde toetsen
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
- **Release** ([.github/workflows/release.yml](.github/workflows/release.yml)) — bij het pushen van een tag `v*` wordt de universele release-APK gebouwd, ondertekend en als GitHub Release gepubliceerd:

```bash
git tag v1.0.0
git push origin v1.0.0
```

### Ondertekening

Release-APK's worden ondertekend met een vaste release-keystore. Dat is nodig omdat Android een update weigert (*"App niet geïnstalleerd"*) zodra de handtekening verschilt van de geïnstalleerde versie — en de debug-sleutel wordt op elke CI-runner opnieuw aangemaakt.

De sleutelgegevens staan in `android/key.properties` (staat in `.gitignore`, dus nooit in git):

```properties
storePassword=…
keyPassword=…
keyAlias=taalleer
storeFile=/pad/naar/taalleer-release.jks
```

Ontbreekt dat bestand, dan valt de release-build terug op de debug-sleutel — prima om lokaal te testen, maar zo'n APK kan een echte release niet updaten.

In CI komt de keystore uit repo-secrets: `ANDROID_KEYSTORE_BASE64`, `ANDROID_KEYSTORE_PASSWORD`, `ANDROID_KEY_ALIAS` en `ANDROID_KEY_PASSWORD`. De workflow controleert na het bouwen dat de APK **niet** met een debug-sleutel is ondertekend.

> **Bewaar de keystore en het wachtwoord goed.** Raak je ze kwijt, dan kun je bestaande installaties nooit meer updaten — gebruikers moeten de app dan verwijderen en opnieuw installeren.

## Projectstructuur

```
lib/
├── main.dart            # App-shell, thema-switching, tabnavigatie
├── models.dart          # Word, QuizResult, Question, AppSettings (+ JSON)
├── word_book.dart       # Woordenboek: 1000 lemma's (es, nl, en)
├── data.dart            # Weekselectie + weekreset-datums
├── pronounce.dart       # Automatische uitspraak (lettergrepen + klemtoon)
├── grammar.dart         # Vervoeging (o.t.t.) + lidwoord (el/la)
├── i18n.dart            # NL/EN vertalingen + datumnotatie
├── utils.dart           # Levenshtein, cijferberekening, vragenbouwers
├── theme.dart           # Licht/donker thema, dyslexie-typografie
├── app_state.dart       # Instellingen + toetshistorie (ChangeNotifier)
├── storage.dart         # Lokale opslag op het apparaat (shared_preferences)
├── widgets.dart         # Herbruikbare UI (kaarten, knoppen, cijfercirkel)
└── screens/             # De zeven schermen
```
