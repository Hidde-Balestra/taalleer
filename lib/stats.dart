import 'language_course.dart';
import 'models.dart';
import 'utils.dart';

/// Geaggregeerde statistieken over de bewaarde toetsresultaten. Puur
/// afgeleid van [AppState.history] — geen aparte opslag.
class StatsSummary {
  final int totalQuizzes;
  final int totalCorrect;
  final int totalAnswered;
  final double averageGrade;
  final double bestGrade;
  final List<Word> weakWords;

  const StatsSummary({
    required this.totalQuizzes,
    required this.totalCorrect,
    required this.totalAnswered,
    required this.averageGrade,
    required this.bestGrade,
    required this.weakWords,
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
  );
}
