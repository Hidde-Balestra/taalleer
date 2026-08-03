import 'package:flutter_test/flutter_test.dart';
import 'package:taalleer/tts.dart';

void main() {
  group('SpeechService', () {
    test(
      'lege tekst geeft direct false, zonder de TTS-engine aan te roepen',
      () async {
        expect(await speechService.speak('', 'es-ES'), isFalse);
      },
    );

    test(
      'ontbrekende spraak-engine (bv. geen platformkanaal in tests, of '
      'GrapheneOS zonder Google-diensten) geeft false i.p.v. te crashen',
      () async {
        expect(await speechService.speak('hola', 'es-ES'), isFalse);
      },
    );
  });
}
