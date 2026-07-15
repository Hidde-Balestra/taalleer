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

/// Vast beginpunt van de weekteller: een maandag. In UTC, zodat het
/// overschakelen op zomer-/wintertijd de dagentelling niet verschuift.
final DateTime _weekEpoch = DateTime.utc(2020, 1, 6);

/// De kalenderdatum van [d] als UTC-middernacht (voor dag-rekenwerk zonder
/// zomertijd-effecten).
DateTime _dateOnlyUtc(DateTime d) => DateTime.utc(d.year, d.month, d.day);

/// Een niet-herhalende weekteller sinds een vast beginpunt (maandag), zodat
/// [wordsForWeek] elke kalenderweek een nieuwe willekeurige trekking geeft en
/// niet elk jaar in herhaling valt.
int currentWeekSeed([DateTime? now]) =>
    _dateOnlyUtc(now ?? DateTime.now()).difference(_weekEpoch).inDays ~/ 7;

/// De maandag waarop een bepaalde week (seed) begint, als lokale datum.
DateTime weekStartDate(int seed) {
  final d = _weekEpoch.add(Duration(days: seed * 7));
  return DateTime(d.year, d.month, d.day);
}

/// De datum (maandag) waarop de woorden en de toets van deze week resetten:
/// het begin van de eerstvolgende week.
DateTime nextWordReset([DateTime? now]) =>
    weekStartDate(currentWeekSeed(now) + 1);

/// Aantal hele dagen tot de volgende reset (1..7).
int daysUntilWordReset([DateTime? now]) {
  final today = now ?? DateTime.now();
  return _dateOnlyUtc(
    nextWordReset(today),
  ).difference(_dateOnlyUtc(today)).inDays;
}

/// Zoekt een woord op id in het hele woordenboek.
Word? wordById(int id) {
  if (id < 1 || id > kWordBook.length) return null;
  return kWordBook[id - 1];
}
