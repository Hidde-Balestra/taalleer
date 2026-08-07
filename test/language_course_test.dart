import 'package:flutter_test/flutter_test.dart';
import 'package:taalleer/languages/es/es_categories.dart';
import 'package:taalleer/languages/es/es_course.dart';
import 'package:taalleer/languages/registry.dart';

void main() {
  group('kCourses / courseById', () {
    test('bevat minstens de Spaanse cursus', () {
      expect(kCourses, isNotEmpty);
      expect(kCourses.map((c) => c.id), contains('es'));
    });

    test('vindt een cursus op id', () {
      expect(courseById('es').id, 'es');
    });

    test('valt terug op de eerste cursus bij een onbekend id', () {
      expect(courseById('does-not-exist').id, kCourses.first.id);
    });
  });

  group('SpanishCourse', () {
    final course = SpanishCourse();

    test('heeft basisgegevens', () {
      expect(course.id, 'es');
      expect(course.nameNl, isNotEmpty);
      expect(course.nameEn, isNotEmpty);
      expect(course.flag, isNotEmpty);
      expect(course.ttsLocale, 'es-ES');
      expect(course.pronouns, hasLength(6));
    });

    test('bouwt woorden met unieke, aaneengesloten ids', () {
      final words = course.words;
      expect(words, isNotEmpty);
      expect(words.map((w) => w.id).toSet(), hasLength(words.length));
      expect(words.first.id, 1);
      expect(words.last.id, words.length);
    });

    test('wordById spiegelt words en geeft null buiten bereik', () {
      expect(course.wordById(1)!.target, course.words.first.target);
      expect(course.wordById(0), isNull);
      expect(course.wordById(course.words.length + 1), isNull);
    });

    test('words wordt maar één keer opgebouwd (memoisatie)', () {
      expect(identical(course.words, course.words), isTrue);
    });

    test('heeft grammaticacategorieën met regels', () {
      expect(course.grammarCategories, isNotEmpty);
      for (final category in course.grammarCategories) {
        expect(category.rules, isNotEmpty);
      }
    });

    test('elk gezet category-veld is een geldig thema-id', () {
      final ids = kWordCategories.map((c) => c.id).toSet();
      for (final w in course.words) {
        if (w.category.isNotEmpty) {
          expect(ids, contains(w.category), reason: w.target);
        }
      }
    });

    test('categoryTitleFor geeft de titel van een bekende categorie', () {
      final food = kWordCategories.firstWhere((c) => c.id == 'food');
      expect(course.categoryTitleFor('food', true), food.titleNl);
      expect(course.categoryTitleFor('food', false), food.titleEn);
    });

    test('categoryTitleFor geeft null voor een onbekende categorie', () {
      expect(course.categoryTitleFor('does-not-exist', true), isNull);
    });
  });
}
