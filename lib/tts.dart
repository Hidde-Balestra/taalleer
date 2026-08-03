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
  // Lazy (niet als veldinitialisator): FlutterTts() zet zelf al een
  // MethodChannel-handler op in zijn constructor, wat crasht als de Flutter-
  // binding nog niet is geïnitialiseerd (bv. in een kale `test()`, of in
  // theorie vóór WidgetsFlutterBinding.ensureInitialized()). Door de
  // constructie hier, binnen de try/catch, te doen, vangen we ook dát geval
  // netjes op i.p.v. alleen fouten uit latere methodeaanroepen.
  FlutterTts? _tts;

  /// Spreekt [text] uit in [locale]. Geeft `true` terug als dat is gelukt,
  /// `false` als er geen (passende) spraak-engine beschikbaar is.
  Future<bool> speak(String text, String locale) async {
    if (text.isEmpty) return false;
    try {
      final tts = _tts ??= FlutterTts();
      final resolved = await _resolveLocale(tts, locale);
      if (resolved == null) return false;
      await tts.stop();
      await tts.setLanguage(resolved);
      await tts.setSpeechRate(0.45);
      return _looksSuccessful(await tts.speak(text));
    } catch (_) {
      return false;
    }
  }

  /// Zoekt een locale die de geïnstalleerde spraak-engine daadwerkelijk
  /// heeft. Sommige (lichte, offline) engines zoals RHVoice of eSpeak
  /// installeren maar één regionale variant van een taal — bv. Spaans
  /// (Ecuador, `es-EC`) i.p.v. Spaans (Spanje, `es-ES`) — en doen, anders dan
  /// Google's engine, geen automatische taal-fallback: `setLanguage('es-ES')`
  /// mislukt dan altijd, ook al kan de engine gewoon Spaans. We vragen
  /// daarom eerst op wat er écht geïnstalleerd is en kiezen de eerste
  /// variant met dezelfde taalcode. Geeft `null` als de engine deze taal
  /// helemaal niet heeft.
  Future<String?> _resolveLocale(FlutterTts tts, String locale) async {
    List<String> installed;
    try {
      final raw = await tts.getLanguages;
      installed = raw is List ? raw.whereType<String>().toList() : const [];
    } catch (_) {
      installed = const [];
    }
    // Geen lijst op te vragen (bv. niet ondersteund door de engine): gewoon
    // de gevraagde locale proberen, zoals voorheen.
    if (installed.isEmpty) return locale;
    if (installed.contains(locale)) return locale;
    final wanted = locale.split(RegExp('[-_]')).first.toLowerCase();
    for (final code in installed) {
      if (code.split(RegExp('[-_]')).first.toLowerCase() == wanted) {
        return code;
      }
    }
    return null;
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
