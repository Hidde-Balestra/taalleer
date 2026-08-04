import 'package:flutter_test/flutter_test.dart';
import 'package:taalleer/languages/es/es_categories.dart';
import 'package:taalleer/languages/es/es_words.dart';

void main() {
  group('kWordCategories', () {
    test('elk thema heeft een niet-lege titel in beide talen', () {
      for (final c in kWordCategories) {
        expect(c.titleNl, isNotEmpty, reason: c.id);
        expect(c.titleEn, isNotEmpty, reason: c.id);
      }
    });

    test('thema-ids zijn uniek', () {
      final ids = kWordCategories.map((c) => c.id).toSet();
      expect(ids, hasLength(kWordCategories.length));
    });
  });

  group('categoryOf', () {
    test('geeft null voor een onbekend woord', () {
      expect(categoryOf('ditbestaatniet'), isNull);
    });

    test('tagt representatieve woorden in het juiste thema', () {
      expect(categoryOf('manzana'), 'food');
      expect(categoryOf('padre'), 'family');
      expect(categoryOf('corazón'), 'body');
      expect(categoryOf('casa'), 'home');
      expect(categoryOf('avión'), 'travel');
      expect(categoryOf('médico'), 'work');
      expect(categoryOf('árbol'), 'nature');
      expect(categoryOf('perro'), 'animals');
      expect(categoryOf('camisa'), 'clothing');
      expect(categoryOf('amor'), 'emotions');
    });

    test('elk getagd woord uit het woordenboek krijgt een geldig thema-id', () {
      final ids = kWordCategories.map((c) => c.id).toSet();
      var taggedCount = 0;
      for (final (target, _, _) in kWordEntries) {
        final category = categoryOf(target);
        if (category != null) {
          expect(ids, contains(category), reason: target);
          taggedCount++;
        }
      }
      // Zorgt dat de test niet stilzwijgend "slaagt" als de hele
      // categorie-map per ongeluk leeg zou zijn.
      expect(taggedCount, greaterThan(500));
    });
  });
}
