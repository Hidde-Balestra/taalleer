import 'dart:math';

import 'grammar.dart';
import 'models.dart';
import 'pronounce.dart';
import 'word_book.dart';

/// Aantal woorden dat per week wordt geleerd.
const int kWordsPerWeek = 20;

/// Het volledige Spaanse woordenboek (zie `word_book.dart`), met per woord
/// een automatisch afgeleide uitspraak. Elke week worden hieruit
/// [kWordsPerWeek] woorden willekeurig gekozen (zie [wordsForWeek]).
final List<Word> kWordBook = List.unmodifiable([
  for (var i = 0; i < kWordEntries.length; i++)
    _buildWord(i + 1, kWordEntries[i]),
]);

/// Bouwt een [Word] met automatisch afgeleide uitspraak, en — waar van
/// toepassing — het lidwoord (el/la) of de tegenwoordige tijd.
Word _buildWord(int id, (String, String, String) entry) {
  final (es, nl, en) = entry;
  final verb = isVerbEntry(es, en);
  return Word(
    id: id,
    es: es,
    nl: nl,
    en: en,
    pronunciation: pronounceEs(es),
    present: verb ? (presentTense(es) ?? const []) : const [],
    article: (verb || kNonNouns.contains(es)) ? '' : articleFor(es),
  );
}

/// De woorden van een week: [kWordsPerWeek] willekeurige woorden uit het
/// hele woordenboek.
///
/// De keuze is willekeurig maar *deterministisch* per [seed]: dezelfde seed
/// levert altijd exact dezelfde 20 woorden op. Dat is essentieel — de
/// woordenlijst, de oefening en de toets binnen één week moeten dezelfde
/// woorden tonen, en de in de historie opgeslagen fout-woord-id's moeten
/// bij een later bezoek nog kloppen.
///
/// Gebruik [currentWeekSeed] voor de seed in de app, zodat elke kalenderweek
/// (jaaroverschrijdend) een nieuwe, niet-herhalende trekking krijgt.
List<Word> wordsForWeek(int seed) {
  final order = List<int>.generate(kWordBook.length, (i) => i)
    ..shuffle(Random(seed));
  final picked = order.take(kWordsPerWeek).toList()..sort();
  return [for (final i in picked) kWordBook[i]];
}

/// Een niet-herhalende weekteller sinds een vast beginpunt (maandag), zodat
/// [wordsForWeek] elke kalenderweek een nieuwe willekeurige trekking geeft en
/// niet elk jaar in herhaling valt.
int currentWeekSeed([DateTime? now]) {
  final today = now ?? DateTime.now();
  final date = DateTime(today.year, today.month, today.day);
  final epoch = DateTime(2020, 1, 6); // een maandag
  return date.difference(epoch).inDays ~/ 7;
}

/// Zoekt een woord op id in het hele woordenboek.
Word? wordById(int id) {
  if (id < 1 || id > kWordBook.length) return null;
  return kWordBook[id - 1];
}
