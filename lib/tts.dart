import 'package:flutter_tts/flutter_tts.dart';

/// Dunne wrapper om tekst-naar-spraak: spreekt een woord of zin uit in de
/// opgegeven taal-locale (bijv. `es-ES`).
///
/// Fouten (geen spraak-engine beschikbaar, zoals op sommige desktops, in
/// tests of in CI) worden stil genegeerd — uitspraak is een leuke extra,
/// geen kernfunctie die de rest van de app mag laten crashen.
class SpeechService {
  final FlutterTts _tts = FlutterTts();

  Future<void> speak(String text, String locale) async {
    if (text.isEmpty) return;
    try {
      await _tts.stop();
      await _tts.setLanguage(locale);
      await _tts.setSpeechRate(0.45);
      await _tts.speak(text);
    } catch (_) {
      // Geen TTS-engine beschikbaar; niets aan te doen.
    }
  }
}

final speechService = SpeechService();
