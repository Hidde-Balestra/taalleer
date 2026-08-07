import 'grammar_content.dart';
import 'models.dart';

/// Definieert alles wat nodig is om een taal in TaalLeer te kunnen leren: het
/// woordenboek, de uitspraak, en — optioneel, want niet elke taal heeft ze —
/// grammaticale afleidingen zoals werkwoordvervoeging en lidwoorden.
///
/// Een nieuwe taal toevoegen betekent: deze klasse implementeren (zie
/// `languages/es/es_course.dart` voor het Spaanse voorbeeld) en registreren
/// in `languages/registry.dart`. De rest van de app — schermen, oefening,
/// toetsen, streak — werkt dan automatisch ook voor die taal.
abstract class LanguageCourse {
  String get id;
  String get nameNl;
  String get nameEn;
  String get flag;

  /// Locale-code voor tekst-naar-spraak, bijv. `es-ES`.
  String get ttsLocale;

  /// Het woordenboek: (doeltaal, Nederlands, Engels) per lemma.
  List<(String, String, String)> get wordEntries;

  String pronounce(String word);

  /// Vervoegt een werkwoord in de tegenwoordige tijd, of `null` als deze
  /// taal geen vervoeging kent of [infinitive] geen werkwoord is.
  List<String>? presentTense(String infinitive) => null;

  /// Vervoegt een werkwoord in de verleden tijd, of `null` als deze taal
  /// geen (enkelvoudige) verleden tijd kent of [infinitive] geen werkwoord
  /// is.
  List<String>? preteriteTense(String infinitive) => null;

  /// Vervoegt een werkwoord in de toekomende tijd, of `null` als deze taal
  /// geen (enkelvoudige) toekomende tijd kent of [infinitive] geen werkwoord
  /// is.
  List<String>? futureTense(String infinitive) => null;

  /// Geeft de gerundio (bv. "hablando"), of `null` als deze taal geen
  /// gerundio kent of [infinitive] geen werkwoord is.
  String? gerundioForm(String infinitive) => null;

  /// Lidwoord van een zelfstandig naamwoord, of `null` als deze taal geen
  /// lidwoorden kent of [noun] geen (telbaar) zelfstandig naamwoord is.
  String? articleFor(String noun) => null;

  bool isVerbEntry(String target, String en) => false;

  /// Thema/categorie van een woord (bv. "eten"), of `null` als het woord
  /// niet in een van de gedefinieerde thema's valt.
  String? categoryFor(String word) => null;

  /// Weergavenaam van een thema-id (bv. "eten" → "Eten & drinken"), of
  /// `null` als deze taal dat thema niet kent.
  String? categoryTitleFor(String categoryId, bool nl) => null;

  /// Voorbeeldzin voor een woord als `(doeltaal, Nederlands)`, of `null` als
  /// er geen voorbeeld beschikbaar is.
  (String, String)? exampleFor(String word) => null;

  /// Extra correcte NL/EN-spellingen naast de primaire vertaling in
  /// [wordEntries] (bv. "kado" naast "cadeau") — alleen gebruikt bij het
  /// nakijken van een antwoord, niet bij het tonen van het woord.
  List<String> nlVariantsFor(String word) => const [];
  List<String> enVariantsFor(String word) => const [];

  /// Invulzin (cloze) voor een werkwoord, voor de invuloefening, of `null`
  /// als daar geen zin voor is. Niet gekoppeld aan [Word] — puur een
  /// oefenvorm-lookup, geen algemeen woordveld.
  ClozeEntry? clozeFor(String word) => null;

  /// Persoonsvormen voor de vervoegingstabel (bijv. yo/tú/él/…), leeg als
  /// deze taal geen vervoeging kent.
  List<String> get pronouns => const [];

  List<GrammarCategory> get grammarCategories => const [];

  List<Word>? _words;

  /// Het volledige woordenboek van deze cursus, opgebouwd uit [wordEntries]
  /// met behulp van [pronounce], [presentTense] en [articleFor]. Wordt één
  /// keer berekend en daarna hergebruikt.
  List<Word> get words => _words ??= [
    for (var i = 0; i < wordEntries.length; i++)
      _buildWord(i + 1, wordEntries[i]),
  ];

  Word _buildWord(int id, (String, String, String) entry) {
    final (target, nl, en) = entry;
    final verb = isVerbEntry(target, en);
    final example = exampleFor(target);
    return Word(
      id: id,
      target: target,
      nl: nl,
      en: en,
      pronunciation: pronounce(target),
      exampleTarget: example?.$1 ?? '',
      exampleNl: example?.$2 ?? '',
      present: verb ? (presentTense(target) ?? const []) : const [],
      past: verb ? (preteriteTense(target) ?? const []) : const [],
      future: verb ? (futureTense(target) ?? const []) : const [],
      gerundio: verb ? (gerundioForm(target) ?? '') : '',
      article: verb ? '' : (articleFor(target) ?? ''),
      category: categoryFor(target) ?? '',
      nlVariants: nlVariantsFor(target),
      enVariants: enVariantsFor(target),
    );
  }

  /// Zoekt een woord op id in [words].
  Word? wordById(int id) {
    if (id < 1 || id > words.length) return null;
    return words[id - 1];
  }
}
