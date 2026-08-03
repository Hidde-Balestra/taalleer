/// Genereert een Nederlands-vriendelijke uitspraakbenadering voor een Spaans
/// woord, bijv. `casa` → `KAH-sah` en `feliz` → `feh-LEES`.
///
/// Spaans is fonetisch zeer regelmatig, waardoor de uitspraak uit de spelling
/// afgeleid kan worden: lettergrepen worden gesplitst, de klemtoonlettergreep
/// (accent, of de standaardregel) wordt in hoofdletters gezet en letters
/// worden naar een benaderende klank omgezet.
library;

const _vowels = 'aeiouáéíóú';
const _strongVowels = 'aeoáéó';
const _accented = 'áéíóú';

// Medeklinkerclusters die samen de aanzet van een lettergreep vormen.
const _onsetClusters = {
  'pr', 'br', 'tr', 'dr', 'cr', 'gr', 'fr', //
  'pl', 'bl', 'cl', 'gl', 'fl',
};

/// Interne representatie: digrafen worden één symbool (hoofdletter, komt in
/// de kleingemaakte invoer niet voor) zodat splitsen en klankvertaling
/// eenvoudig blijven. C = ch, Y = ll, R = rr, N = ñ.
String _normalize(String word) {
  return word
      .replaceAll('ch', 'C')
      .replaceAll('ll', 'Y')
      .replaceAll('rr', 'R')
      .replaceAll('qu', 'k')
      .replaceAll('güe', 'we')
      .replaceAll('güi', 'wi')
      .replaceAll('ñ', 'N');
}

bool _isVowel(String c) => _vowels.contains(c);

/// Splitst een (genormaliseerd) woord in lettergrepen volgens de
/// vereenvoudigde Spaanse regels.
List<String> _syllabify(String s) {
  final syllables = <String>[];
  var current = StringBuffer();
  var i = 0;

  while (i < s.length) {
    // Aanzet: alle medeklinkers tot de volgende klinker.
    while (i < s.length && !_isVowel(s[i])) {
      current.write(s[i]);
      i++;
    }
    // Kern: klinker plus eventuele tweeklank (zwakke klinker ernaast).
    if (i < s.length) {
      current.write(s[i]);
      var prev = s[i];
      i++;
      while (i < s.length &&
          _isVowel(s[i]) &&
          !(_strongVowels.contains(prev) && _strongVowels.contains(s[i]))) {
        current.write(s[i]);
        prev = s[i];
        i++;
      }
    }
    // Coda: kijk vooruit naar het volgende cluster medeklinkers.
    var j = i;
    while (j < s.length && !_isVowel(s[j])) {
      j++;
    }
    final consonants = j - i;
    if (j >= s.length) {
      // Einde van het woord: alles bij deze lettergreep.
      current.write(s.substring(i));
      i = s.length;
    } else if (consonants >= 2) {
      final lastTwo = s.substring(j - 2, j);
      final onset = _onsetClusters.contains(lastTwo) ? 2 : 1;
      current.write(s.substring(i, j - onset));
      i = j - onset;
    }
    // Bij 0 of 1 medeklinker gaat alles naar de volgende aanzet.
    syllables.add(current.toString());
    current = StringBuffer();
  }
  if (current.isNotEmpty) syllables.add(current.toString());
  return syllables.where((syl) => syl.isNotEmpty).toList();
}

int _stressIndex(List<String> syllables, String normalized) {
  for (var i = 0; i < syllables.length; i++) {
    if (syllables[i].split('').any(_accented.contains)) return i;
  }
  final last = normalized[normalized.length - 1];
  final stressPenultimate = _isVowel(last) || last == 'n' || last == 's';
  if (stressPenultimate && syllables.length > 1) return syllables.length - 2;
  return syllables.length - 1;
}

/// Zet één lettergreep om naar een benaderende Nederlandse klank.
String _phonetic(String syllable) {
  final out = StringBuffer();
  for (var i = 0; i < syllable.length; i++) {
    final c = syllable[i];
    final prev = i > 0 ? syllable[i - 1] : '';
    final next = i + 1 < syllable.length ? syllable[i + 1] : '';
    final isLastLetter = i == syllable.length - 1;
    switch (c) {
      case 'C': // ch
        out.write('tsj');
      case 'Y': // ll
        out.write('j');
      case 'R': // rr
        out.write('rr');
      case 'N': // ñ
        out.write('nj');
      case 'c':
        out.write('eiéí'.contains(next) ? 's' : 'k');
      case 'g':
        out.write('eiéí'.contains(next) ? 'ch' : 'g');
      case 'j':
        out.write('ch');
      case 'h':
        break; // stomme h
      case 'v':
        out.write('b');
      case 'z':
        out.write('s');
      case 'x':
        out.write('ks');
      case 'y':
        out.write(isLastLetter ? 'ie' : 'j');
      case 'a':
      case 'á':
        out.write(isLastLetter ? 'ah' : 'a');
      case 'e':
      case 'é':
        out.write(isLastLetter ? 'eh' : 'e');
      case 'i':
      case 'í':
        // Zwakke klinker naast een andere klinker wordt een glijklank.
        if (_isVowel(next) || _isVowel(prev)) {
          out.write('j');
        } else {
          out.write('ee');
        }
      case 'o':
      case 'ó':
        out.write(isLastLetter ? 'oh' : 'o');
      case 'u':
      case 'ú':
        if (_isVowel(next) || _isVowel(prev)) {
          out.write('w');
        } else {
          out.write('oe');
        }
      default:
        out.write(c);
    }
  }
  return out.toString();
}

/// Genereert de uitspraakbenadering, met de klemtoon in hoofdletters.
String pronounceEs(String word) {
  final cleaned = word.toLowerCase().replaceAll(RegExp(r'[^a-záéíóúüñ]'), '');
  if (cleaned.isEmpty) return '';
  final normalized = _normalize(cleaned);
  final syllables = _syllabify(normalized);
  if (syllables.isEmpty) return '';
  final stress = _stressIndex(syllables, normalized);
  final parts = <String>[];
  for (var i = 0; i < syllables.length; i++) {
    final p = _phonetic(syllables[i]);
    parts.add(i == stress && syllables.length > 1 ? p.toUpperCase() : p);
  }
  return parts.join('-');
}
