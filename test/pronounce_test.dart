import 'package:flutter_test/flutter_test.dart';
import 'package:taalleer/pronounce.dart';

void main() {
  group('pronounceEs', () {
    test('klemtoon op voorlaatste lettergreep bij woorden op klinker', () {
      expect(pronounceEs('casa'), 'KAH-sah');
      expect(pronounceEs('mesa'), 'MEH-sah');
    });

    test('klemtoon op laatste lettergreep bij woorden op medeklinker', () {
      expect(pronounceEs('hablar'), 'ah-BLAR');
      expect(pronounceEs('feliz'), 'feh-LEES');
    });

    test('accent bepaalt de klemtoon', () {
      // sábado: accent op de eerste lettergreep.
      expect(pronounceEs('sábado'), startsWith('SAH'));
      // café: accent op de laatste lettergreep.
      expect(pronounceEs('café'), endsWith('FEH'));
    });

    test('stomme h wordt niet uitgesproken', () {
      expect(pronounceEs('hola'), 'OH-lah');
    });

    test('digrafen krijgen hun eigen klank', () {
      expect(pronounceEs('coche'), 'KOH-tsjeh'); // ch
      expect(pronounceEs('calle'), 'KAH-jeh'); // ll
      expect(pronounceEs('año'), 'AH-njoh'); // ñ
      expect(pronounceEs('perro'), 'PEH-rroh'); // rr
    });

    test('c en g zijn zacht voor e/i en hard voor a/o/u', () {
      expect(pronounceEs('cinco'), 'SEEN-koh');
      expect(pronounceEs('gato'), 'GAH-toh');
      expect(pronounceEs('gente'), startsWith('CHEN'));
    });

    test('qu klinkt als k en v als b', () {
      expect(pronounceEs('queso'), 'KEH-soh');
      expect(pronounceEs('vaso'), 'BAH-soh');
    });

    test('tweeklanken worden glijklanken', () {
      expect(pronounceEs('tiempo'), 'TJEM-poh');
      expect(pronounceEs('bueno'), 'BWEH-noh');
    });

    test('woorden met één lettergreep krijgen geen hoofdletters', () {
      expect(pronounceEs('sol'), 'sol');
      expect(pronounceEs('pan'), 'pan');
    });

    test('lege of ongeldige invoer geeft lege string', () {
      expect(pronounceEs(''), '');
      expect(pronounceEs('123'), '');
    });
  });
}
