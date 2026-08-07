import 'language_course.dart';
import 'models.dart';
import 'utils.dart';

/// Gemiddeld cijfer voor één categorie, puur data — de weergavenaam wordt
/// door de UI opgezocht (via `LanguageCourse.categoryTitleFor`), net als bij
/// [weakWords]/`Word`.
class CategoryGrade {
  final String categoryId;
  final double averageGrade;
  final int count;

  const CategoryGrade({
    required this.categoryId,
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
  final List<CategoryGrade> categoryGrades;

  const StatsSummary({
    required this.totalQuizzes,
    required this.totalCorrect,
    required this.totalAnswered,
    required this.averageGrade,
    required this.bestGrade,
    required this.weakWords,
    required this.categoryGrades,
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
      categoryGrades: [],
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
    categoryGrades: _categoryGrades(history),
  );
}

/// Groepeert [history] op categorie (niet-lege waarden), gemiddeld cijfer
/// per groep, gesorteerd op aantal toetsen aflopend (meest geoefende
/// categorie eerst); bij gelijke aantallen op categorie-id, voor een
/// deterministische volgorde.
List<CategoryGrade> _categoryGrades(List<QuizResult> history) {
  final byCategory = <String, List<double>>{};
  for (final r in history) {
    if (r.category.isEmpty) continue;
    (byCategory[r.category] ??= []).add(r.grade);
  }
  final grades =
      [
        for (final entry in byCategory.entries)
          CategoryGrade(
            categoryId: entry.key,
            averageGrade: double.parse(
              (entry.value.reduce((a, b) => a + b) / entry.value.length)
                  .toStringAsFixed(1),
            ),
            count: entry.value.length,
          ),
      ]..sort((a, b) {
        final byCount = b.count.compareTo(a.count);
        return byCount != 0 ? byCount : a.categoryId.compareTo(b.categoryId);
      });
  return grades;
}
