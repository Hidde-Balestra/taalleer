/// Extra correcte spellingen voor het Nederlandse of Engelse antwoord van
/// een woord, naast de primaire vertaling in `es_words.dart` — voor
/// woorden met een erkend alternatief (bv. "cadeau"/"kado", allebei in Van
/// Dale). Alleen gebruikt bij het nakijken van een antwoord; getoond wordt
/// altijd de primaire spelling uit `es_words.dart`.
///
/// Bewust géén niet-erkende spellingen (zoals "cado"): daarvoor bestaat al
/// de dyslexie-modus, die kleine typefouten tolereert.
const Map<String, List<String>> kNlAnswerVariants = {
  'regalo': ['kado'],
};

const Map<String, List<String>> kEnAnswerVariants = {};
