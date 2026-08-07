import 'language_course.dart';
import 'models.dart';
import 'utils.dart';

/// Gemiddeld cijfer voor één toets (algemeen of thema), puur data — de
/// weergavenaam wordt door de UI opgezocht (via [quizLabel]), net als bij
/// [weakWords]/`Word`.
class QuizGrade {
  final String quizId;
  final double averageGrade;
  final int count;

  const QuizGrade({
    required this.quizId,
    required this.averageGrade,
    required this.count,
  });
}

/// Geaggregeerde statistieken over de bewaarde toetsresultaten. Puur
/// afgeleid van [AppState.history] — geen aparte opslag.
class StatsSummary {
  final int totalQuizzes;
  final int totalCorrect;
  final int totalAnswered;
  final double averageGrade;
  final double bestGrade;
  final List<Word> weakWords;
  final List<QuizGrade> quizGrades;

  const StatsSummary({
    required this.totalQuizzes,
    required this.totalCorrect,
    required this.totalAnswered,
    required this.averageGrade,
    required this.bestGrade,
    required this.weakWords,
    required this.quizGrades,
  });
}

StatsSummary computeStats(List<QuizResult> history, LanguageCourse course) {
  if (history.isEmpty) {
    return const StatsSummary(
      totalQuizzes: 0,
      totalCorrect: 0,
      totalAnswered: 0,
      averageGrade: 0,
      bestGrade: 0,
      weakWords: [],
      quizGrades: [],
    );
  }
  final totalCorrect = history.fold<int>(0, (sum, r) => sum + r.correct);
  final totalAnswered = history.fold<int>(0, (sum, r) => sum + r.total);
  final averageGrade =
      history.fold<double>(0, (sum, r) => sum + r.grade) / history.length;
  final bestGrade = history.map((r) => r.grade).reduce((a, b) => a > b ? a : b);
  return StatsSummary(
    totalQuizzes: history.length,
    totalCorrect: totalCorrect,
    totalAnswered: totalAnswered,
    averageGrade: double.parse(averageGrade.toStringAsFixed(1)),
    bestGrade: bestGrade,
    weakWords: weakWords(history, course, limit: 10),
    quizGrades: _quizGrades(history),
  );
}

/// Groepeert [history] per toets (algemeen of thema; niet-lege quiz-id's —
/// alleen historische data van vóór losse toets-id's heeft er geen),
/// gemiddeld cijfer per groep, gesorteerd op aantal toetsen aflopend (meest
/// gemaakte toets eerst); bij gelijke aantallen op quiz-id, voor een
/// deterministische volgorde.
List<QuizGrade> _quizGrades(List<QuizResult> history) {
  final byQuiz = <String, List<double>>{};
  for (final r in history) {
    if (r.quizId.isEmpty) continue;
    (byQuiz[r.quizId] ??= []).add(r.grade);
  }
  final grades =
      [
        for (final entry in byQuiz.entries)
          QuizGrade(
            quizId: entry.key,
            averageGrade: double.parse(
              (entry.value.reduce((a, b) => a + b) / entry.value.length)
                  .toStringAsFixed(1),
            ),
            count: entry.value.length,
          ),
      ]..sort((a, b) {
        final byCount = b.count.compareTo(a.count);
        return byCount != 0 ? byCount : a.quizId.compareTo(b.quizId);
      });
  return grades;
}
