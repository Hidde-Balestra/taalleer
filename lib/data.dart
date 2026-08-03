import 'dart:math';

import 'language_course.dart';
import 'models.dart';

/// Aantal woorden dat per week wordt geleerd.
const int kWordsPerWeek = 20;

/// De woorden van een week: [kWordsPerWeek] willekeurige woorden uit het
/// hele woordenboek van [course].
///
/// De keuze is willekeurig maar *deterministisch* per [seed]: dezelfde seed
/// levert altijd exact dezelfde 20 woorden op. Dat is essentieel — de
/// woordenlijst, de oefening en de toets binnen één week moeten dezelfde
/// woorden tonen, en de in de historie opgeslagen fout-woord-id's moeten
/// bij een later bezoek nog kloppen.
///
/// Gebruik [currentWeekSeed] voor de seed in de app, zodat elke kalenderweek
/// (jaaroverschrijdend) een nieuwe, niet-herhalende trekking krijgt.
List<Word> wordsForWeek(LanguageCourse course, int seed) {
  final wordBook = course.words;
  final order = List<int>.generate(wordBook.length, (i) => i)
    ..shuffle(Random(seed));
  final picked = order.take(kWordsPerWeek).toList()..sort();
  return [for (final i in picked) wordBook[i]];
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
