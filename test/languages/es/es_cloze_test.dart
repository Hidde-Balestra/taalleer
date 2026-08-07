import 'package:flutter_test/flutter_test.dart';
import 'package:taalleer/languages/es/es_cloze.dart';
import 'package:taalleer/languages/es/es_course.dart';

final _course = SpanishCourse();

void main() {
  group('kSpanishCloze', () {
    test('elke sleutel bestaat als werkwoord-lemma in het woordenboek', () {
      for (final infinitive in kSpanishCloze.keys) {
        final word = _course.words.firstWhere(
          (w) => w.target == infinitive,
          orElse: () => throw StateError('$infinitive niet gevonden'),
        );
        expect(word.isVerb, isTrue, reason: '$infinitive is geen werkwoord');
      }
    });

    test('person verwijst naar een echt aanwezige vervoeging', () {
      for (final entry in kSpanishCloze.entries) {
        final word = _course.words.firstWhere((w) => w.target == entry.key);
        expect(entry.value.person, inInclusiveRange(0, 5));
        expect(word.present[entry.value.person], isNotEmpty);
      }
    });

    test('sentenceTemplate bevat de invulplek', () {
      for (final entry in kSpanishCloze.values) {
        expect(entry.sentenceTemplate, contains('___'));
      }
    });

    test('translationNl is niet leeg', () {
      for (final entry in kSpanishCloze.values) {
        expect(entry.translationNl, isNotEmpty);
      }
    });

    test('bevat een redelijke curated set (geen losse handvol)', () {
      expect(kSpanishCloze.length, greaterThanOrEqualTo(40));
    });

    test('gustar en deber zitten er bewust niet in', () {
      expect(kSpanishCloze.containsKey('gustar'), isFalse);
      expect(kSpanishCloze.containsKey('deber'), isFalse);
    });
  });
}
