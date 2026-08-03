import 'package:flutter_tts/flutter_tts.dart';

/// Dunne wrapper om tekst-naar-spraak: spreekt een woord of zin uit in de
/// opgegeven taal-locale (bijv. `es-ES`).
///
/// Sommige toestellen hebben geen enkele spraak-engine geïnstalleerd (bv.
/// GrapheneOS zonder Google-diensten) — [speak] geeft dan `false` terug
/// i.p.v. te crashen, zodat de aanroeper de gebruiker kan laten weten dat
/// uitspraak hier niet beschikbaar is. Uitspraak is een leuke extra, geen
/// kernfunctie die de rest van de app mag laten crashen.
class SpeechService {
  final FlutterTts _tts = FlutterTts();

  /// Spreekt [text] uit in [locale]. Geeft `true` terug als dat is gelukt,
  /// `false` als er geen (passende) spraak-engine beschikbaar is.
  Future<bool> speak(String text, String locale) async {
    if (text.isEmpty) return false;
    try {
      await _tts.stop();
      await _tts.setLanguage(locale);
      await _tts.setSpeechRate(0.45);
      return _looksSuccessful(await _tts.speak(text));
    } catch (_) {
      return false;
    }
  }

  /// `speak()` geeft platform-afhankelijk een statuscode terug (op Android
  /// bijv. 1 = gelukt, 0/-1 = mislukt). We checken hem waar mogelijk, maar
  /// zijn bewust soepel voor onbekende vormen (bv. andere platforms/engines)
  /// zodat een werkende engine niet ten onrechte als "niet beschikbaar"
  /// wordt gemeld — dat gebeurde eerder met een aparte
  /// `isLanguageAvailable()`-vooraf-check, die bij sommige engines (o.a.
  /// eSpeak) onterecht negatief uitpakte terwijl uitspreken zelf wel werkte.
  bool _looksSuccessful(dynamic result) {
    if (result == null) return false;
    if (result is int) return result == 1;
    if (result is bool) return result;
    return true;
  }
}

final speechService = SpeechService();
