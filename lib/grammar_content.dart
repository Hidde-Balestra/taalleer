import 'package:flutter/material.dart';

/// Eén grammaticaregel: een korte uitleg met voorbeelden, in het Nederlands
/// en Engels (zelfde tweetalige aanpak als `i18n.dart`).
class GrammarRule {
  final String titleNl;
  final String titleEn;
  final String bodyNl;
  final String bodyEn;

  /// Voorbeelden: (doeltaal, Nederlands, Engels).
  final List<(String, String, String)> examples;

  const GrammarRule({
    required this.titleNl,
    required this.titleEn,
    required this.bodyNl,
    required this.bodyEn,
    this.examples = const [],
  });

  String title(bool nl) => nl ? titleNl : titleEn;
  String body(bool nl) => nl ? bodyNl : bodyEn;
}

/// Een categorie grammaticaregels, bijv. "Zelfstandige naamwoorden".
class GrammarCategory {
  final String titleNl;
  final String titleEn;
  final IconData icon;
  final List<GrammarRule> rules;

  const GrammarCategory({
    required this.titleNl,
    required this.titleEn,
    required this.icon,
    required this.rules,
  });

  String title(bool nl) => nl ? titleNl : titleEn;
}
