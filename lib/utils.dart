import 'dart:math';

import 'package:flutter/material.dart';

import 'language_course.dart';
import 'models.dart';

/// Levenshtein-afstand tussen twee strings.
int levenshtein(String a, String b) {
  final m = a.length, n = b.length;
  final dp = List.generate(
    m + 1,
    (i) => List.generate(n + 1, (j) => i == 0 ? j : (j == 0 ? i : 0)),
  );
  for (var i = 1; i <= m; i++) {
    for (var j = 1; j <= n; j++) {
      dp[i][j] = a[i - 1] == b[j - 1]
          ? dp[i - 1][j - 1]
          : 1 + [dp[i - 1][j], dp[i][j - 1], dp[i - 1][j - 1]].reduce(min);
    }
  }
  return dp[m][n];
}

/// De antwoorden die goed gerekend worden voor [correct].
///
/// Verduidelijkingen tussen haakjes staan er alleen om betekenissen uit
/// elkaar te houden ("zijn (toestand)" bij *estar* naast "zijn" bij *ser*).
/// Zowel mét als zónder die toevoeging is goed.
List<String> answerVariants(String correct) {
  final full = correct.trim();
  final withoutBrackets = full
      .replaceAll(RegExp(r'\([^)]*\)'), ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
  return {full, if (withoutBrackets.isNotEmpty) withoutBrackets}.toList();
}

/// Is het antwoord goed? In dyslexie-modus worden kleine typefouten
/// geaccepteerd op basis van woordlengte (1 fout per 5 tekens, minimaal 1).
bool isAcceptable(String input, String correct, {required bool dyslexia}) {
  return answerVariants(
    correct,
  ).any((variant) => _matches(input, variant, dyslexia));
}

bool _matches(String input, String correct, bool dyslexia) {
  final a = input.trim().toLowerCase();
  final b = correct.trim().toLowerCase();
  if (a == b) return true;
  if (!dyslexia) return false;
  final maxDist = max(1, b.length ~/ 5);
  return levenshtein(a, b) <= maxDist;
}

/// Weeknummer van het jaar (zelfde formule als het prototype).
int weekNumberOf(DateTime now) {
  final start = DateTime(now.year, 1, 1);
  final startWeekday = start.weekday % 7; // zondag = 0, zoals JS getDay()
  final days = now.difference(start).inHours / 24;
  return ((days + startWeekday + 1) / 7).ceil();
}

int currentWeekNumber() => weekNumberOf(DateTime.now());

/// Cijfer 0–10 met één decimaal.
double calcGrade(int correct, int total) =>
    double.parse((correct / total * 10).toStringAsFixed(1));

bool isWeekend(DateTime d) =>
    d.weekday == DateTime.saturday || d.weekday == DateTime.sunday;

/// Kleur bij een cijfer: groen ≥ 8, oranje ≥ 6, anders rood.
Color gradeColor(double g) {
  if (g >= 8) return const Color(0xFF10B981);
  if (g >= 6) return const Color(0xFFF59E0B);
  return const Color(0xFFEF4444);
}

String correctAnswerOf(Question q) {
  switch (q.type) {
    case QuestionType.nlEs:
    case QuestionType.enEs:
      return q.word.target;
    case QuestionType.esNl:
      return q.word.nl;
    case QuestionType.esEn:
      return q.word.en;
  }
}

/// Alle correcte antwoorden voor [q]: de primaire vertaling
/// ([correctAnswerOf]) plus eventuele erkende alternatieve spellingen (bv.
/// "kado" naast "cadeau") — die laatste tellen alleen mee bij het nakijken,
/// niet bij het tónen van het woord.
List<String> acceptedAnswersOf(Question q) {
  final variants = switch (q.type) {
    QuestionType.esNl => q.word.nlVariants,
    QuestionType.esEn => q.word.enVariants,
    QuestionType.nlEs || QuestionType.enEs => const [],
  };
  return [correctAnswerOf(q), ...variants];
}

/// Is [input] een goed antwoord op [q]? Controleert tegen alle
/// [acceptedAnswersOf], elk met dezelfde `isAcceptable`-regels (haakjes,
/// dyslexie-tolerantie).
bool isAnswerAcceptable(Question q, String input, {required bool dyslexia}) =>
    acceptedAnswersOf(
      q,
    ).any((correct) => isAcceptable(input, correct, dyslexia: dyslexia));

String shownWordOf(Question q) {
  switch (q.type) {
    case QuestionType.nlEs:
      return q.word.nl;
    case QuestionType.enEs:
      return q.word.en;
    case QuestionType.esNl:
    case QuestionType.esEn:
      return q.word.target;
  }
}

/// Is de doeltaal-vorm van [q] wat er getoond wordt (esNl/esEn) in plaats
/// van pas na controleren zichtbaar (nlEs/enEs)? Gebruikt om te bepalen
/// waar een uitspraakknop zonder hint-risico geplaatst kan worden.
bool isTargetShown(Question q) =>
    q.type == QuestionType.esNl || q.type == QuestionType.esEn;

/// Oefensessie: 10 willekeurige woorden uit [words], willekeurige richting.
List<Question> buildPractice(
  List<Word> words,
  Lang sourceLang, {
  Random? random,
}) {
  final rng = random ?? Random();
  final types = sourceLang == Lang.nl
      ? [QuestionType.nlEs, QuestionType.esNl]
      : [QuestionType.enEs, QuestionType.esEn];
  final shuffled = [...words]..shuffle(rng);
  return shuffled
      .take(10)
      .map((w) => Question(word: w, type: types[rng.nextInt(types.length)]))
      .toList();
}

/// Weektoets: 10 willekeurige woorden uit [words], afwisselende richting.
List<Question> buildQuiz(List<Word> words, Lang sourceLang, {Random? random}) {
  final rng = random ?? Random();
  final types = sourceLang == Lang.nl
      ? [QuestionType.nlEs, QuestionType.esNl]
      : [QuestionType.enEs, QuestionType.esEn];
  final shuffled = [...words]..shuffle(rng);
  return List.generate(
    10,
    (i) => Question(word: shuffled[i], type: types[i % 2]),
  );
}

/// Luisteroefening: 10 willekeurige woorden uit [words], altijd met het
/// doeltaalwoord als audio (esNl/esEn) — de andere richting heeft geen zin
/// zonder tekst te tonen.
List<Question> buildListeningPractice(
  List<Word> words,
  Lang sourceLang, {
  Random? random,
}) {
  final rng = random ?? Random();
  final type = sourceLang == Lang.nl ? QuestionType.esNl : QuestionType.esEn;
  final shuffled = [...words]..shuffle(rng);
  return shuffled.take(10).map((w) => Question(word: w, type: type)).toList();
}

/// Vervoegingstoets: 10 werkwoorden uit [verbs], elk in een willekeurige
/// persoon. Wederkerende werkwoorden (met voornaamwoord in de vorm) worden
/// overgeslagen om het antwoord eenduidig te houden.
List<ConjugationQuestion> buildConjugationQuiz(
  List<Word> verbs, {
  Random? random,
}) {
  final rng = random ?? Random();
  final pool =
      verbs.where((w) => w.isVerb && !w.present.first.contains(' ')).toList()
        ..shuffle(rng);
  return [
    for (final w in pool.take(10))
      ConjugationQuestion(word: w, person: rng.nextInt(6)),
  ];
}

/// De woorden waar de gebruiker historisch het vaakst fout op zat, aflopend
/// gesorteerd op foutfrequentie (op basis van `wrongWordIds` in alle
/// bewaarde toetsresultaten). Geeft een lege lijst als er nog geen historie
/// is. Geen aparte opslag nodig — de data staat al in [history].
List<Word> weakWords(
  List<QuizResult> history,
  LanguageCourse course, {
  int limit = 20,
}) {
  final counts = <int, int>{};
  for (final result in history) {
    for (final id in result.wrongWordIds) {
      counts[id] = (counts[id] ?? 0) + 1;
    }
  }
  final sortedIds = counts.keys.toList()
    ..sort((a, b) => counts[b]!.compareTo(counts[a]!));
  return [for (final id in sortedIds.take(limit)) ?course.wordById(id)];
}

/// Meerkeuzevragen: hergebruikt [buildPractice] (of [buildListeningPractice]
/// bij [listening]) voor de vraag zelf, en trekt per vraag 3 afleiders uit
/// het volledige cursusboek (niet alleen [words] — meer variatie), zodat een
/// afleider nooit toevallig gelijk is aan het juiste antwoord.
List<MultipleChoiceQuestion> buildMultipleChoice(
  List<Word> words,
  LanguageCourse course,
  Lang sourceLang, {
  bool listening = false,
  Random? random,
}) {
  final rng = random ?? Random();
  final questions = listening
      ? buildListeningPractice(words, sourceLang, random: rng)
      : buildPractice(words, sourceLang, random: rng);
  return [for (final q in questions) _withDistractors(q, course, rng)];
}

MultipleChoiceQuestion _withDistractors(
  Question q,
  LanguageCourse course,
  Random rng,
) {
  final correct = correctAnswerOf(q);
  final pool = course.words.where((w) => w.id != q.word.id).toList()
    ..shuffle(rng);
  final distractors = <String>{};
  for (final w in pool) {
    if (distractors.length >= 3) break;
    final candidate = correctAnswerOf(Question(word: w, type: q.type));
    if (candidate != correct) distractors.add(candidate);
  }
  final options = [correct, ...distractors]..shuffle(rng);
  return MultipleChoiceQuestion(question: q, options: options);
}

/// Geheugenspel: [pairs] woorden, elk als twee tegels (doeltaal +
/// vertaling), geschud.
List<MemoryTile> buildMemoryGame(
  List<Word> words,
  Lang sourceLang, {
  int pairs = 8,
  Random? random,
}) {
  final rng = random ?? Random();
  final chosen = ([...words]..shuffle(rng)).take(pairs);
  final tiles = [
    for (final w in chosen) ...[
      MemoryTile(id: w.id, word: w, text: w.target, isTarget: true),
      MemoryTile(
        id: w.id,
        word: w,
        text: sourceLang == Lang.nl ? w.nl : w.en,
        isTarget: false,
      ),
    ],
  ];
  tiles.shuffle(rng);
  return tiles;
}

/// Vormen [a] en [b] samen een paar? Moet hetzelfde woord zijn, maar van
/// verschillende kant (doeltaal + vertaling, niet twee keer dezelfde kant).
bool tilesMatch(MemoryTile a, MemoryTile b) =>
    a.word.id == b.word.id && a.isTarget != b.isTarget;

/// Woorden met een curated voorbeeldzin (`kSpanishExamples`-achtig), de
/// brondata voor "zinnen bouwen" en "zinsvertaling". Cursusbreed, niet
/// beperkt tot de woorden van deze week — anders zou een willekeurige week
/// weinig of geen bruikbare zinnen kunnen hebben.
List<Word> sentenceWordPool(LanguageCourse course) =>
    course.words.where((w) => w.exampleTarget.isNotEmpty).toList();

/// "Zinnen bouwen": tokeniseert `exampleTarget` op spaties (leestekens
/// blijven aan het token vast) en geeft zowel de juiste volgorde als een
/// geschudde volgorde voor de tegels.
List<SentenceBuildQuestion> buildSentenceBuilder(
  LanguageCourse course, {
  int count = 8,
  Random? random,
}) {
  final rng = random ?? Random();
  final pool = sentenceWordPool(course)..shuffle(rng);
  return [
    for (final w in pool.take(count))
      SentenceBuildQuestion(
        word: w,
        correctTokens: w.exampleTarget.split(' '),
        shuffledTokens: w.exampleTarget.split(' ')..shuffle(rng),
      ),
  ];
}

/// "Zinsvertaling": [count] woorden met een voorbeeldzin, om
/// `exampleTarget` te laten vertalen naar `exampleNl`.
List<Word> buildSentenceTranslation(
  LanguageCourse course, {
  int count = 8,
  Random? random,
}) {
  final rng = random ?? Random();
  return (sentenceWordPool(course)..shuffle(rng)).take(count).toList();
}

/// Invuloefening: werkwoorden uit [verbs] met een cloze-zin
/// ([LanguageCourse.clozeFor]), gekoppeld aan hun `ClozeEntry`.
List<(Word, ClozeEntry)> buildClozeExercise(
  List<Word> verbs,
  LanguageCourse course, {
  int count = 8,
  Random? random,
}) {
  final rng = random ?? Random();
  final pool = [
    for (final w in verbs)
      if (course.clozeFor(w.target) case final entry?) (w, entry),
  ]..shuffle(rng);
  return pool.take(count).toList();
}
