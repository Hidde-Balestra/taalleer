import 'dart:math';

import 'package:flutter/material.dart';

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

/// Is het antwoord goed? In dyslexie-modus worden kleine typefouten
/// geaccepteerd op basis van woordlengte (1 fout per 5 tekens, minimaal 1).
bool isAcceptable(String input, String correct, {required bool dyslexia}) {
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
      return q.word.es;
    case QuestionType.esNl:
      return q.word.nl;
    case QuestionType.esEn:
      return q.word.en;
  }
}

String shownWordOf(Question q) {
  switch (q.type) {
    case QuestionType.nlEs:
      return q.word.nl;
    case QuestionType.enEs:
      return q.word.en;
    case QuestionType.esNl:
    case QuestionType.esEn:
      return q.word.es;
  }
}

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
