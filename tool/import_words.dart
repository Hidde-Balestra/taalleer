// Hulpprogramma om het woordenboek (lib/word_book.dart) te laten groeien
// richting 10.000+ woorden, en om het te valideren.
//
// Gebruik:
//   dart run tool/import_words.dart --check
//       Valideert het huidige woordenboek (duplicaten, lege velden) en
//       toont statistieken.
//
//   dart run tool/import_words.dart nieuwe_woorden.csv
//       Leest regels in het formaat `spaans;nederlands;engels` (of met
//       komma's/tabs als scheidingsteken), slaat duplicaten over en voegt
//       de rest achteraan toe — zo blijven bestaande weeknummers dezelfde
//       woorden houden. Daarna wordt lib/word_book.dart opnieuw
//       gegenereerd.
//
// ignore_for_file: avoid_print

import 'dart:io';

const wordBookPath = 'lib/word_book.dart';

final entryPattern = RegExp(
  r"\('((?:[^'\\]|\\.)*)', '((?:[^'\\]|\\.)*)', '((?:[^'\\]|\\.)*)'\)",
);

String unescape(String s) => s.replaceAll(r"\'", "'").replaceAll(r'\\', r'\');
String escape(String s) => s.replaceAll(r'\', r'\\').replaceAll("'", r"\'");

List<(String, String, String)> readCurrentEntries() {
  final source = File(wordBookPath).readAsStringSync();
  return entryPattern
      .allMatches(source)
      .map(
        (m) => (
          unescape(m.group(1)!),
          unescape(m.group(2)!),
          unescape(m.group(3)!),
        ),
      )
      .toList();
}

void writeWordBook(List<(String, String, String)> entries) {
  final buffer = StringBuffer('''
/// Het Spaanse woordenboek: (Spaans, Nederlands, Engels).
///
/// De uitspraak wordt automatisch afgeleid (zie `pronounce.dart`), omdat
/// Spaans fonetisch regelmatig is — net als in een fysiek woordenboek staat
/// hier per woord alleen het lemma met de vertalingen.
///
/// Uitbreiden kan met: `dart run tool/import_words.dart bestand.csv`
library;

const List<(String, String, String)> kWordEntries = [
''');
  for (final (es, nl, en) in entries) {
    buffer.writeln("  ('${escape(es)}', '${escape(nl)}', '${escape(en)}'),");
  }
  buffer.writeln('];');
  File(wordBookPath).writeAsStringSync(buffer.toString());
}

bool validate(List<(String, String, String)> entries) {
  var ok = true;
  final seen = <String>{};
  for (final (es, nl, en) in entries) {
    if (es.trim().isEmpty || nl.trim().isEmpty || en.trim().isEmpty) {
      print('FOUT: leeg veld bij ($es, $nl, $en)');
      ok = false;
    }
    if (!seen.add(es.toLowerCase())) {
      print('FOUT: duplicaat lemma "$es"');
      ok = false;
    }
  }
  return ok;
}

void printStats(List<(String, String, String)> entries) {
  print('Woorden in het boek : ${entries.length}');
  print('Per week worden hier 20 willekeurige woorden uit getrokken.');
}

void main(List<String> args) {
  if (args.isEmpty ||
      (args.first != '--check' && !File(args.first).existsSync())) {
    print('Gebruik: dart run tool/import_words.dart --check');
    print('         dart run tool/import_words.dart <bestand.csv>');
    exitCode = 64;
    return;
  }

  final current = readCurrentEntries();

  if (args.first == '--check') {
    final ok = validate(current);
    printStats(current);
    if (!ok) exitCode = 1;
    return;
  }

  // Importeren: regels splitsen op ; , of tab.
  final lines = File(args.first).readAsLinesSync();
  final existing = current.map((e) => e.$1.toLowerCase()).toSet();
  final added = <(String, String, String)>[];
  var skipped = 0;

  for (final raw in lines) {
    final line = raw.trim();
    if (line.isEmpty || line.startsWith('#')) continue;
    final sep = line.contains(';')
        ? ';'
        : line.contains('\t')
        ? '\t'
        : ',';
    final parts = line.split(sep).map((p) => p.trim()).toList();
    if (parts.length < 3 || parts.take(3).any((p) => p.isEmpty)) {
      print('Overgeslagen (ongeldig): $line');
      skipped++;
      continue;
    }
    final es = parts[0];
    if (!existing.add(es.toLowerCase())) {
      skipped++;
      continue;
    }
    added.add((es, parts[1], parts[2]));
  }

  final merged = [...current, ...added];
  if (!validate(merged)) {
    print('Import afgebroken: validatie mislukt.');
    exitCode = 1;
    return;
  }

  writeWordBook(merged);
  print('Toegevoegd: ${added.length}, overgeslagen: $skipped');
  printStats(merged);
  print('Klaar. Draai nu: dart format lib/word_book.dart && flutter test');
}
