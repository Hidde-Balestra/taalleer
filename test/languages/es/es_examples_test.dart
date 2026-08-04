import 'package:flutter_test/flutter_test.dart';
import 'package:taalleer/languages/es/es_examples.dart';
import 'package:taalleer/languages/es/es_words.dart';

void main() {
  group('kSpanishExamples', () {
    test('elke sleutel bestaat echt als lemma in het woordenboek', () {
      final dictWords = kWordEntries.map((e) => e.$1).toSet();
      for (final key in kSpanishExamples.keys) {
        expect(dictWords, contains(key), reason: key);
      }
    });

    test('elke zin is niet-leeg in beide talen', () {
      for (final entry in kSpanishExamples.entries) {
        final (es, nl) = entry.value;
        expect(es.trim(), isNotEmpty, reason: entry.key);
        expect(nl.trim(), isNotEmpty, reason: entry.key);
      }
    });

    test('bevat een redelijke curated set (geen losse handvol)', () {
      expect(kSpanishExamples.length, greaterThan(80));
    });
  });
}
