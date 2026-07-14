import 'models.dart';
import 'pronounce.dart';
import 'word_book.dart';

/// Aantal woorden dat per week wordt geleerd.
const int kWordsPerWeek = 20;

/// Het volledige Spaanse woordenboek (zie `word_book.dart`), met per woord
/// een automatisch afgeleide uitspraak. Elke week worden hieruit
/// [kWordsPerWeek] woorden gekozen op basis van het weeknummer; na het einde
/// van het boek begint de rotatie opnieuw.
final List<Word> kWordBook = List.unmodifiable([
  for (var i = 0; i < kWordEntries.length; i++)
    Word(
      id: i + 1,
      es: kWordEntries[i].$1,
      nl: kWordEntries[i].$2,
      en: kWordEntries[i].$3,
      pronunciation: pronounceEs(kWordEntries[i].$1),
    ),
]);

/// De woorden van een bepaalde week: een venster van [kWordsPerWeek] woorden
/// dat elke week een stuk opschuift en aan het einde van het boek weer
/// vooraan begint.
List<Word> wordsForWeek(int weekNumber) {
  final start = ((weekNumber - 1) * kWordsPerWeek) % kWordBook.length;
  return List.generate(
    kWordsPerWeek,
    (i) => kWordBook[(start + i) % kWordBook.length],
  );
}

/// Zoekt een woord op id in het hele woordenboek.
Word? wordById(int id) {
  if (id < 1 || id > kWordBook.length) return null;
  return kWordBook[id - 1];
}
