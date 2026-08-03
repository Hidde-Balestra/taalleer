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
      final available = await _tts.isLanguageAvailable(locale);
      if (available != true) return false;
      await _tts.stop();
      await _tts.setLanguage(locale);
      await _tts.setSpeechRate(0.45);
      await _tts.speak(text);
      return true;
    } catch (_) {
      return false;
    }
  }
}

final speechService = SpeechService();
