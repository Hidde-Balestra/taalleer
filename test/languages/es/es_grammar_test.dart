import 'package:flutter_test/flutter_test.dart';
import 'package:taalleer/languages/es/es_grammar.dart';

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

  group('preteriteTense — regelmatig', () {
    test('-ar (hablar)', () {
      expect(preteriteTense('hablar'), [
        'hablé',
        'hablaste',
        'habló',
        'hablamos',
        'hablasteis',
        'hablaron',
      ]);
    });

    test('-er (comer)', () {
      expect(preteriteTense('comer'), [
        'comí',
        'comiste',
        'comió',
        'comimos',
        'comisteis',
        'comieron',
      ]);
    });

    test('-ir (vivir)', () {
      expect(preteriteTense('vivir'), [
        'viví',
        'viviste',
        'vivió',
        'vivimos',
        'vivisteis',
        'vivieron',
      ]);
    });

    test('geen werkwoord geeft null', () {
      expect(preteriteTense('casa'), isNull);
      expect(preteriteTense('color'), isNull);
    });
  });

  group('preteriteTense — spellingswijziging yo-vorm', () {
    test('-car (buscar → busqué)', () {
      expect(preteriteTense('buscar')!.first, 'busqué');
      expect(preteriteTense('buscar')![2], 'buscó');
    });

    test('-gar (jugar → jugué)', () {
      expect(preteriteTense('jugar')!.first, 'jugué');
    });

    test('-zar (empezar → empecé)', () {
      expect(preteriteTense('empezar')!.first, 'empecé');
    });
  });

  group('preteriteTense — klinkerstam (tussen-y)', () {
    test('leer (leyó/leyeron + accenten)', () {
      expect(preteriteTense('leer'), [
        'leí',
        'leíste',
        'leyó',
        'leímos',
        'leísteis',
        'leyeron',
      ]);
    });

    test('construir (tussen-y, geen accenten)', () {
      expect(preteriteTense('construir'), [
        'construí',
        'construiste',
        'construyó',
        'construimos',
        'construisteis',
        'construyeron',
      ]);
    });
  });

  group('preteriteTense — stamwisseling (alleen 3e persoon)', () {
    test('pedir (e→i)', () {
      expect(preteriteTense('pedir'), [
        'pedí',
        'pediste',
        'pidió',
        'pedimos',
        'pedisteis',
        'pidieron',
      ]);
    });

    test('dormir (o→u)', () {
      expect(preteriteTense('dormir'), [
        'dormí',
        'dormiste',
        'durmió',
        'dormimos',
        'dormisteis',
        'durmieron',
      ]);
    });

    test('pensar (-ar met stamwisseling in presente) blijft regelmatig', () {
      expect(preteriteTense('pensar'), [
        'pensé',
        'pensaste',
        'pensó',
        'pensamos',
        'pensasteis',
        'pensaron',
      ]);
    });
  });

  group('preteriteTense — onregelmatig', () {
    test('ser en ir hebben gelijke vormen', () {
      expect(preteriteTense('ser'), [
        'fui',
        'fuiste',
        'fue',
        'fuimos',
        'fuisteis',
        'fueron',
      ]);
      expect(preteriteTense('ir'), preteriteTense('ser'));
    });

    test('tener', () {
      expect(preteriteTense('tener'), [
        'tuve',
        'tuviste',
        'tuvo',
        'tuvimos',
        'tuvisteis',
        'tuvieron',
      ]);
    });

    test('estar', () {
      expect(preteriteTense('estar')!.first, 'estuve');
    });

    test('hacer (c→z in hij/zij-vorm)', () {
      expect(preteriteTense('hacer'), [
        'hice',
        'hiciste',
        'hizo',
        'hicimos',
        'hicisteis',
        'hicieron',
      ]);
    });

    test('decir (dijeron, geen -ieron)', () {
      expect(preteriteTense('decir'), [
        'dije',
        'dijiste',
        'dijo',
        'dijimos',
        'dijisteis',
        'dijeron',
      ]);
    });

    test('dar en ver zijn onregelmatig kort', () {
      expect(preteriteTense('dar'), [
        'di',
        'diste',
        'dio',
        'dimos',
        'disteis',
        'dieron',
      ]);
      expect(preteriteTense('ver'), [
        'vi',
        'viste',
        'vio',
        'vimos',
        'visteis',
        'vieron',
      ]);
    });
  });

  group('preteriteTense — wederkerend', () {
    test('despedirse (e→i + wederkerend)', () {
      expect(preteriteTense('despedirse')!.first, 'me despedí');
      expect(preteriteTense('despedirse')![2], 'se despidió');
    });
  });

  group('futureTense — regelmatig', () {
    test('-ar (hablar)', () {
      expect(futureTense('hablar'), [
        'hablaré',
        'hablarás',
        'hablará',
        'hablaremos',
        'hablaréis',
        'hablarán',
      ]);
    });

    test('-er (comer)', () {
      expect(futureTense('comer'), [
        'comeré',
        'comerás',
        'comerá',
        'comeremos',
        'comeréis',
        'comerán',
      ]);
    });

    test('-ir (vivir)', () {
      expect(futureTense('vivir'), [
        'viviré',
        'vivirás',
        'vivirá',
        'viviremos',
        'viviréis',
        'vivirán',
      ]);
    });

    test('geen werkwoord geeft null', () {
      expect(futureTense('casa'), isNull);
      expect(futureTense('color'), isNull);
    });
  });

  group('futureTense — onregelmatige stam', () {
    test('tener (tendr-)', () {
      expect(futureTense('tener'), [
        'tendré',
        'tendrás',
        'tendrá',
        'tendremos',
        'tendréis',
        'tendrán',
      ]);
    });

    test('hacer (har-)', () {
      expect(futureTense('hacer')!.first, 'haré');
    });

    test('decir (dir-)', () {
      expect(futureTense('decir')!.first, 'diré');
    });

    test('poder (podr-)', () {
      expect(futureTense('poder')!.first, 'podré');
    });
  });

  group('futureTense — wederkerend', () {
    test('despedirse', () {
      expect(futureTense('despedirse')!.first, 'me despediré');
      expect(futureTense('despedirse')![2], 'se despedirá');
    });
  });

  group('gerundioForm — regelmatig', () {
    test('-ar (hablar)', () {
      expect(gerundioForm('hablar'), 'hablando');
    });

    test('-er (comer)', () {
      expect(gerundioForm('comer'), 'comiendo');
    });

    test('-ir (vivir)', () {
      expect(gerundioForm('vivir'), 'viviendo');
    });

    test('geen werkwoord geeft null', () {
      expect(gerundioForm('casa'), isNull);
    });

    test('-ar/-er met stamwisseling in presente blijft regelmatig', () {
      expect(gerundioForm('contar'), 'contando');
      expect(gerundioForm('tener'), 'teniendo');
      expect(gerundioForm('querer'), 'queriendo');
    });
  });

  group('gerundioForm — klinkerstam (tussen-y)', () {
    test('leer', () {
      expect(gerundioForm('leer'), 'leyendo');
    });

    test('construir', () {
      expect(gerundioForm('construir'), 'construyendo');
    });

    test('oír', () {
      expect(gerundioForm('oír'), 'oyendo');
    });
  });

  group('gerundioForm — stamwisseling (alleen -ir)', () {
    test('pedir (e→i)', () {
      expect(gerundioForm('pedir'), 'pidiendo');
    });

    test('dormir (o→u)', () {
      expect(gerundioForm('dormir'), 'durmiendo');
    });

    test('sentir (e→ie in presente wordt e→i)', () {
      expect(gerundioForm('sentir'), 'sintiendo');
    });
  });

  group('gerundioForm — onregelmatig', () {
    test('ir', () {
      expect(gerundioForm('ir'), 'yendo');
    });

    test('poder', () {
      expect(gerundioForm('poder'), 'pudiendo');
    });

    test('decir', () {
      expect(gerundioForm('decir'), 'diciendo');
    });

    test('reír / freír', () {
      expect(gerundioForm('reír'), 'riendo');
      expect(gerundioForm('freír'), 'friendo');
    });
  });

  group('gerundioForm — wederkerend', () {
    test('equivocarse (achtervoegsel + accent)', () {
      expect(gerundioForm('equivocarse'), 'equivocándose');
    });

    test('despedirse (stamwisseling + achtervoegsel)', () {
      expect(gerundioForm('despedirse'), 'despidiéndose');
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
