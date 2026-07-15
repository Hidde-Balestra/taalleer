import 'package:flutter_test/flutter_test.dart';
import 'package:taalleer/grammar.dart';

void main() {
  group('presentTense — regelmatig', () {
    test('-ar (hablar)', () {
      expect(presentTense('hablar'), [
        'hablo',
        'hablas',
        'habla',
        'hablamos',
        'habláis',
        'hablan',
      ]);
    });

    test('-er (comer)', () {
      expect(presentTense('comer'), [
        'como',
        'comes',
        'come',
        'comemos',
        'coméis',
        'comen',
      ]);
    });

    test('-ir (vivir)', () {
      expect(presentTense('vivir'), [
        'vivo',
        'vives',
        'vive',
        'vivimos',
        'vivís',
        'viven',
      ]);
    });

    test('geen werkwoord geeft null', () {
      expect(presentTense('casa'), isNull);
      expect(presentTense('color'), isNull);
    });
  });

  group('presentTense — onregelmatig', () {
    test('ser', () {
      expect(presentTense('ser'), [
        'soy',
        'eres',
        'es',
        'somos',
        'sois',
        'son',
      ]);
    });

    test('ir', () {
      expect(presentTense('ir'), ['voy', 'vas', 'va', 'vamos', 'vais', 'van']);
    });

    test('estar', () {
      expect(presentTense('estar'), [
        'estoy',
        'estás',
        'está',
        'estamos',
        'estáis',
        'están',
      ]);
    });

    test('tener (e→ie + yo tengo)', () {
      expect(presentTense('tener'), [
        'tengo',
        'tienes',
        'tiene',
        'tenemos',
        'tenéis',
        'tienen',
      ]);
    });

    test('poder (o→ue)', () {
      expect(presentTense('poder'), [
        'puedo',
        'puedes',
        'puede',
        'podemos',
        'podéis',
        'pueden',
      ]);
    });

    test('pedir (e→i)', () {
      expect(presentTense('pedir'), [
        'pido',
        'pides',
        'pide',
        'pedimos',
        'pedís',
        'piden',
      ]);
    });

    test('jugar (u→ue)', () {
      expect(presentTense('jugar'), [
        'juego',
        'juegas',
        'juega',
        'jugamos',
        'jugáis',
        'juegan',
      ]);
    });

    test('conocer (yo -zco)', () {
      expect(presentTense('conocer')!.first, 'conozco');
      expect(presentTense('conocer')![1], 'conoces');
    });

    test('seguir (e→i + yo sigo)', () {
      expect(presentTense('seguir'), [
        'sigo',
        'sigues',
        'sigue',
        'seguimos',
        'seguís',
        'siguen',
      ]);
    });

    test('construir (tussen-y)', () {
      expect(presentTense('construir'), [
        'construyo',
        'construyes',
        'construye',
        'construimos',
        'construís',
        'construyen',
      ]);
    });

    test('deber is regelmatig', () {
      expect(presentTense('deber')!.first, 'debo');
    });
  });

  group('presentTense — wederkerend', () {
    test('equivocarse krijgt voornaamwoorden', () {
      expect(presentTense('equivocarse'), [
        'me equivoco',
        'te equivocas',
        'se equivoca',
        'nos equivocamos',
        'os equivocáis',
        'se equivocan',
      ]);
    });

    test('despedirse (e→i + wederkerend)', () {
      expect(presentTense('despedirse')!.first, 'me despido');
      expect(presentTense('despedirse')![2], 'se despide');
    });
  });

  group('articleFor', () {
    test('-o is el, -a is la', () {
      expect(articleFor('libro'), 'el');
      expect(articleFor('casa'), 'la');
    });

    test('bekende uitzonderingen', () {
      expect(articleFor('día'), 'el');
      expect(articleFor('mano'), 'la');
      expect(articleFor('problema'), 'el');
      expect(articleFor('foto'), 'la');
      expect(articleFor('mapa'), 'el');
      expect(articleFor('agua'), 'el');
    });

    test('achtervoegsels', () {
      expect(articleFor('universidad'), 'la');
      expect(articleFor('canción'), 'la');
      expect(articleFor('televisión'), 'la');
      expect(articleFor('viaje'), 'el');
      expect(articleFor('color'), 'el');
      expect(articleFor('naturaleza'), 'la');
    });

    test('-e en medeklinkers', () {
      expect(articleFor('coche'), 'el');
      expect(articleFor('noche'), 'la');
      expect(articleFor('flor'), 'la');
      expect(articleFor('sal'), 'la');
      expect(articleFor('pez'), 'el');
      expect(articleFor('ciudad'), 'la');
      expect(articleFor('papel'), 'el');
    });
  });

  group('isVerbEntry / kNonNouns', () {
    test('werkwoord herkennen aan Engelse vertaling', () {
      expect(isVerbEntry('hablar', 'to speak'), isTrue);
      expect(isVerbEntry('deber', 'must'), isTrue);
      expect(isVerbEntry('casa', 'house'), isFalse);
    });

    test('niet-zelfstandige naamwoorden zijn uitgesloten', () {
      expect(kNonNouns, contains('rojo'));
      expect(kNonNouns, contains('con'));
      expect(kNonNouns, contains('muy'));
      expect(kNonNouns, isNot(contains('casa')));
    });
  });
}
