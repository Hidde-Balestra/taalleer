/// Niveau van een leesverhaal, van makkelijk naar lastig.
enum StoryLevel { beginner, intermediate, advanced }

/// Eén alinea van een verhaal: de doeltaal-tekst met Nederlandse vertaling
/// (zelfde eentalige-vertaling-aanpak als de voorbeeldzinnen in
/// `es_examples.dart` — de vertaling is er om te checken of je het begrepen
/// hebt, niet om zonder te lezen).
class StoryParagraph {
  final String target;
  final String nl;

  const StoryParagraph({required this.target, required this.nl});
}

/// Eén leesverhaal: een titel, niveau, onderwerp (vrij — verhalen kunnen
/// overal over gaan) en een reeks alinea's.
class Story {
  final String id;
  final String titleTarget;
  final String titleNl;
  final String titleEn;
  final StoryLevel level;
  final String topicNl;
  final String topicEn;
  final List<StoryParagraph> paragraphs;

  const Story({
    required this.id,
    required this.titleTarget,
    required this.titleNl,
    required this.titleEn,
    required this.level,
    required this.topicNl,
    required this.topicEn,
    required this.paragraphs,
  });

  String title(bool nl) => nl ? titleNl : titleEn;
  String topic(bool nl) => nl ? topicNl : topicEn;
}
