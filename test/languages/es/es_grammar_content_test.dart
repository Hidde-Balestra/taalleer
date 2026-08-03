import 'package:flutter_test/flutter_test.dart';
import 'package:taalleer/languages/es/es_grammar_content.dart';

void main() {
  group('kSpanishGrammarCategories', () {
    test('bevat categorieën', () {
      expect(kSpanishGrammarCategories, isNotEmpty);
    });

    test('elke categorie heeft een titel in beide talen en minstens één regel', () {
      for (final category in kSpanishGrammarCategories) {
        expect(category.titleNl, isNotEmpty);
        expect(category.titleEn, isNotEmpty);
        expect(category.rules, isNotEmpty);
      }
    });

    test(
      'elke regel heeft niet-lege titel/uitleg in beide talen en minstens '
      'één voorbeeld',
      () {
        for (final category in kSpanishGrammarCategories) {
          for (final rule in category.rules) {
            expect(rule.titleNl, isNotEmpty, reason: category.titleNl);
            expect(rule.titleEn, isNotEmpty, reason: category.titleNl);
            expect(rule.bodyNl, isNotEmpty, reason: rule.titleNl);
            expect(rule.bodyEn, isNotEmpty, reason: rule.titleNl);
            expect(rule.examples, isNotEmpty, reason: rule.titleNl);
            for (final (target, nl, en) in rule.examples) {
              expect(target, isNotEmpty, reason: rule.titleNl);
              expect(nl, isNotEmpty, reason: rule.titleNl);
              expect(en, isNotEmpty, reason: rule.titleNl);
            }
          }
        }
      },
    );

    test('categorietitels zijn uniek', () {
      final titles = kSpanishGrammarCategories.map((c) => c.titleNl).toSet();
      expect(titles, hasLength(kSpanishGrammarCategories.length));
    });
  });
}
