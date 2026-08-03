# TaalLeer 🇪🇸

Een Flutter-app om Spaanse woordjes te leren, gebaseerd op het [Figma Make prototype](https://www.figma.com/make/NKrWAK6t5gLsBVsq8Hevht/Language-Learning-App-Design).

## Functies

- **Willekeurige woorden per week** — een Spaans woordenboek van ~1500 woorden (thematisch geordend: getallen, tijd, familie, lichaam, huis, eten, dieren, natuur, stad, reizen, kleding, kleuren, school, beroepen, technologie, gezondheid, sport, kunst, geld, gevoelens, bijvoeglijke naamwoorden, werkwoorden en kleine woorden). Elke week worden hieruit **20 willekeurige woorden** getrokken. De trekking is deterministisch per kalenderweek (jaaroverschrijdend, dus niet-herhalend): binnen één week tonen de woordenlijst, oefening en toets dezelfde woorden. Het boek kan onbeperkt groeien (zie [Woordenboek uitbreiden](#woordenboek-uitbreiden-richting-10000-woorden))
- **Automatische uitspraak** — Spaans is fonetisch regelmatig; de uitspraakhint (bijv. `casa` → `KAH-sah`) wordt uit de spelling afgeleid, inclusief klemtoonregels en accenten
- **Woorden hardop laten uitspreken** — een uitspraakknopje (tekst-naar-spraak) bij woorden in de woordenlijst, oefening, vervoegingstoets en grammaticavoorbeelden
- **Grammatica per woord** — in de woordenlijst toont elk zelfstandig naamwoord zijn lidwoord (**el**/**la**) en elk werkwoord de volledige tegenwoordige tijd (presente de indicativo). Beide worden automatisch afgeleid (`es_grammar.dart`): regelmatige vervoegingen via vaste uitgangen, onregelmatige/stamwisselende werkwoorden via tabellen, en het geslacht via uitgangsregels met een uitzonderingenlijst
- **Grammaticascherm** — de belangrijkste grammaticaregels, gecategoriseerd per onderwerp (zelfstandige naamwoorden, bijvoeglijke naamwoorden, werkwoorden, ser/estar, voornaamwoorden, ontkenning & vraagzinnen), met voorbeelden en uitspraak
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
  - Taal die je leert (op dit moment alleen Spaans — zie [Meertalige architectuur](#meertalige-architectuur))
  - App-taal: Nederlands / Engels
  - Brontaal: Nederlands / Engels (bepaalt de vraagrichting)
  - Weergave: licht / donker / systeem
  - **Dyslexie-modus**: kleine typefouten worden geaccepteerd (Levenshtein-afstand op basis van woordlengte) en de tekst krijgt ruimere letterafstand
  - **Updates**: toont de huidige versie en controleert automatisch (en op verzoek) of er een nieuwere release op GitHub staat, met een link ernaartoe

Alle data (instellingen en toetshistorie) wordt lokaal op het apparaat opgeslagen via `shared_preferences`. De app werkt volledig offline, op twee uitzonderingen na: tekst-naar-spraak gebruikt de spraak-engine van het besturingssysteem, en de update-check haalt de nieuwste release-info op bij de GitHub API (`lib/update_service.dart`).

### Meertalige architectuur

De app leert momenteel Spaans, maar is opgezet rond een `LanguageCourse`-abstractie (`lib/language_course.dart`) zodat een nieuwe taal later zonder aanpassingen aan de rest van de app toegevoegd kan worden. Alles wat taal-specifiek is — het woordenboek, de uitspraakregels, de grammaticale afleidingen (vervoeging/lidwoorden) en de grammatica-content — zit achter die interface, geïmplementeerd voor Spaans in [lib/languages/es/](lib/languages/es/). Een taal toevoegen: een nieuwe map onder `lib/languages/`, een `LanguageCourse`-implementatie, en registreren in `lib/languages/registry.dart`. In Instellingen verschijnt de taal dan automatisch als keuze.

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

Het Spaanse woordenboek staat in [lib/languages/es/es_words.dart](lib/languages/es/es_words.dart) en de willekeurige weektrekking werkt met **elke omvang** — 1000, 10.000 of meer woorden. Hoe groter het boek, hoe meer verschillende woorden je in de loop van de weken tegenkomt. Nieuwe woorden toevoegen gaat met de import-tool:

```bash
# Valideren (duplicaten, lege velden) + statistieken
dart run tool/import_words.dart --check

# Batch importeren uit een CSV (formaat: spaans;nederlands;engels)
dart run tool/import_words.dart nieuwe_woorden.csv
dart format lib/languages/es/es_words.dart
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
├── main.dart               # App-shell, thema-switching, tabnavigatie
├── models.dart             # Word, QuizResult, Question, AppSettings (+ JSON)
├── language_course.dart    # Abstractie voor een leerbare taal (zie hierboven)
├── grammar_content.dart    # Model voor gecategoriseerde grammaticaregels
├── languages/
│   ├── registry.dart       # kCourses / courseById — hier een taal registreren
│   └── es/                 # Spaanse cursus (implementatie van LanguageCourse)
│       ├── es_course.dart          # SpanishCourse: koppelt onderstaande bestanden
│       ├── es_words.dart           # Woordenboek: 1000 lemma's (es, nl, en)
│       ├── es_pronounce.dart       # Automatische uitspraak (lettergrepen + klemtoon)
│       ├── es_grammar.dart         # Vervoeging (o.t.t.) + lidwoord (el/la)
│       └── es_grammar_content.dart # Grammaticaregels voor het grammaticascherm
├── data.dart               # Weekselectie + weekreset-datums
├── tts.dart                # Tekst-naar-spraak (SpeechService)
├── update_service.dart     # Update-check tegen GitHub Releases
├── i18n.dart                # NL/EN vertalingen + datumnotatie
├── utils.dart               # Levenshtein, cijferberekening, vragenbouwers
├── theme.dart                # Licht/donker thema, dyslexie-typografie
├── app_state.dart           # Instellingen + toetshistorie (ChangeNotifier)
├── storage.dart             # Lokale opslag op het apparaat (shared_preferences)
├── widgets.dart              # Herbruikbare UI (kaarten, knoppen, cijfercirkel, uitspraakknop, logo)
└── screens/                  # De schermen (incl. grammatica-scherm)

design/
├── logo.svg                # App-icoon (afgeronde hoeken, gebruikt voor Android/web)
├── logo-square.svg         # Vol-vlakke variant voor iOS (geen transparantie/afronding)
└── logo-maskable.svg       # Veilige-zone-variant voor Android/PWA maskable icons
```

Alle app-iconen (`android/…/mipmap-*`, `ios/…/AppIcon.appiconset`, `web/icons`,
`web/favicon.png`) zijn met `rsvg-convert` uit deze SVG's gegenereerd. Het
beeldmerk zelf (twee overlappende spraakbubbels) staat ook als vectorwidget
in de app (`TaalLeerLogo` in `lib/widgets.dart`, te zien op het home-scherm).
