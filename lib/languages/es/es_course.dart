import '../../grammar_content.dart';
import '../../language_course.dart';
import 'es_grammar.dart' as grammar;
import 'es_grammar_content.dart';
import 'es_pronounce.dart';
import 'es_words.dart';

/// De Spaanse cursus: koppelt het woordenboek, de fonetiek en de
/// grammatica-afleidingen uit `es_words.dart`, `es_pronounce.dart` en
/// `es_grammar.dart` aan de generieke `LanguageCourse`-interface.
class SpanishCourse extends LanguageCourse {
  @override
  String get id => 'es';

  @override
  String get nameNl => 'Spaans';

  @override
  String get nameEn => 'Spanish';

  @override
  String get flag => '🇪🇸';

  @override
  String get ttsLocale => 'es-ES';

  @override
  List<(String, String, String)> get wordEntries => kWordEntries;

  @override
  String pronounce(String word) => pronounceEs(word);

  @override
  List<String>? presentTense(String infinitive) =>
      grammar.presentTense(infinitive);

  @override
  List<String>? preteriteTense(String infinitive) =>
      grammar.preteriteTense(infinitive);

  @override
  List<String>? futureTense(String infinitive) =>
      grammar.futureTense(infinitive);

  @override
  String? gerundioForm(String infinitive) => grammar.gerundioForm(infinitive);

  @override
  String? articleFor(String noun) =>
      grammar.kNonNouns.contains(noun) ? null : grammar.articleFor(noun);

  @override
  bool isVerbEntry(String target, String en) => grammar.isVerbEntry(target, en);

  @override
  List<String> get pronouns => grammar.kPronouns;

  @override
  List<GrammarCategory> get grammarCategories => kSpanishGrammarCategories;
}
