import 'package:share_plus/share_plus.dart';

import 'i18n.dart';
import 'models.dart';

/// Bouwt de deeltekst voor een toetsresultaat, los van de eigenlijke
/// `Share.share`-aanroep zodat de tekst zelf testbaar is.
String buildShareText(Strings t, QuizResult result) => t.shareResultText
    .replaceFirst('{grade}', result.grade.toStringAsFixed(1))
    .replaceFirst('{correct}', '${result.correct}')
    .replaceFirst('{total}', '${result.total}');

Future<void> shareResult(Strings t, QuizResult result) =>
    Share.share(buildShareText(t, result));
