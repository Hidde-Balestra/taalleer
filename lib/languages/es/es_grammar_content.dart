import 'package:flutter/material.dart';

import '../../grammar_content.dart';

/// Gecategoriseerde grammaticaregels voor het Spaans, getoond in het
/// grammatica-scherm. Sluit aan bij wat er al functioneel in de app zit
/// (`es_grammar.dart`: vervoeging en lidwoorden) plus wat een leerder verder
/// nodig heeft.
final List<GrammarCategory> kSpanishGrammarCategories = [
  GrammarCategory(
    titleNl: 'Zelfstandige naamwoorden & lidwoorden',
    titleEn: 'Nouns & articles',
    icon: Icons.label_outline,
    rules: [
      GrammarRule(
        titleNl: 'El of la',
        titleEn: 'El or la',
        bodyNl:
            'Elk zelfstandig naamwoord heeft een geslacht. Woorden op -o zijn '
            'meestal mannelijk (el) en krijgen "el", woorden op -a meestal '
            'vrouwelijk en krijgen "la". Er zijn uitzonderingen die je gewoon '
            'moet leren, zoals "el día" en "la mano".',
        bodyEn:
            'Every noun has a gender. Words ending in -o are usually '
            'masculine and take "el"; words ending in -a are usually '
            'feminine and take "la". There are exceptions you just have to '
            'learn, such as "el día" and "la mano".',
        examples: [
          ('el libro', 'het boek', 'the book'),
          ('la casa', 'het huis', 'the house'),
          ('el día', 'de dag', 'the day'),
          ('la mano', 'de hand', 'the hand'),
        ],
      ),
      GrammarRule(
        titleNl: 'Meervoud',
        titleEn: 'Plural',
        bodyNl:
            'Eindigt het woord op een klinker? Voeg dan -s toe. Eindigt het '
            'op een medeklinker? Voeg dan -es toe. Het lidwoord verandert mee: '
            'el → los, la → las.',
        bodyEn:
            'If the word ends in a vowel, add -s. If it ends in a '
            'consonant, add -es. The article changes along with it: '
            'el → los, la → las.',
        examples: [
          ('los libros', 'de boeken', 'the books'),
          ('las casas', 'de huizen', 'the houses'),
          ('las ciudades', 'de steden', 'the cities'),
        ],
      ),
    ],
  ),
  GrammarCategory(
    titleNl: 'Bijvoeglijke naamwoorden',
    titleEn: 'Adjectives',
    icon: Icons.style_outlined,
    rules: [
      GrammarRule(
        titleNl: 'Overeenkomst in geslacht en getal',
        titleEn: 'Gender and number agreement',
        bodyNl:
            'Een bijvoeglijk naamwoord past zich aan het zelfstandig '
            'naamwoord aan: mannelijk/vrouwelijk en enkelvoud/meervoud. '
            'Woorden op -o krijgen -a in het vrouwelijk; op een medeklinker '
            'of -e verandert er meestal niets.',
        bodyEn:
            'An adjective agrees with the noun it describes: masculine or '
            'feminine, singular or plural. Words ending in -o take -a in '
            'the feminine form; words ending in a consonant or -e usually '
            'stay the same.',
        examples: [
          ('el chico alto', 'de lange jongen', 'the tall boy'),
          ('la chica alta', 'het lange meisje', 'the tall girl'),
          ('los chicos altos', 'de lange jongens', 'the tall boys'),
        ],
      ),
      GrammarRule(
        titleNl: 'Plaatsing',
        titleEn: 'Placement',
        bodyNl:
            'Anders dan in het Nederlands staat een bijvoeglijk naamwoord in '
            'het Spaans meestal ná het zelfstandig naamwoord.',
        bodyEn:
            'Unlike in English, an adjective in Spanish usually comes '
            'after the noun it describes.',
        examples: [
          ('el coche rojo', 'de rode auto', 'the red car'),
          ('una casa grande', 'een groot huis', 'a big house'),
        ],
      ),
    ],
  ),
  GrammarCategory(
    titleNl: 'Werkwoorden — regelmatige tegenwoordige tijd',
    titleEn: 'Verbs — regular present tense',
    icon: Icons.auto_awesome_motion_outlined,
    rules: [
      GrammarRule(
        titleNl: 'Werkwoorden op -ar',
        titleEn: 'Verbs ending in -ar',
        bodyNl:
            'Haal -ar weg en voeg de uitgang toe: -o, -as, -a, -amos, -áis, '
            '-an. Dit is de grootste en meest regelmatige groep werkwoorden.',
        bodyEn:
            'Drop -ar and add the ending: -o, -as, -a, -amos, -áis, -an. '
            'This is the largest and most regular group of verbs.',
        examples: [
          ('hablo', 'ik spreek', 'I speak'),
          ('hablamos', 'wij spreken', 'we speak'),
        ],
      ),
      GrammarRule(
        titleNl: 'Werkwoorden op -er',
        titleEn: 'Verbs ending in -er',
        bodyNl: 'Haal -er weg en voeg toe: -o, -es, -e, -emos, -éis, -en.',
        bodyEn: 'Drop -er and add: -o, -es, -e, -emos, -éis, -en.',
        examples: [
          ('como', 'ik eet', 'I eat'),
          ('comes', 'jij eet', 'you eat'),
        ],
      ),
      GrammarRule(
        titleNl: 'Werkwoorden op -ir',
        titleEn: 'Verbs ending in -ir',
        bodyNl:
            'Haal -ir weg en voeg toe: -o, -es, -e, -imos, -ís, -en — bijna '
            'gelijk aan -er, behalve bij "wij" en "jullie".',
        bodyEn:
            'Drop -ir and add: -o, -es, -e, -imos, -ís, -en — almost the '
            'same as -er, except for the "we" and "you all" forms.',
        examples: [
          ('vivo', 'ik woon', 'I live'),
          ('vivimos', 'wij wonen', 'we live'),
        ],
      ),
    ],
  ),
  GrammarCategory(
    titleNl: 'Onregelmatige werkwoorden & stamwisseling',
    titleEn: 'Irregular verbs & stem changes',
    icon: Icons.sync_alt,
    rules: [
      GrammarRule(
        titleNl: 'Stamwisseling e → ie',
        titleEn: 'Stem change e → ie',
        bodyNl:
            'Bij sommige werkwoorden verandert de klinker in de stam van e '
            'naar ie — in alle vormen behalve "wij" en "jullie".',
        bodyEn:
            'In some verbs the stem vowel changes from e to ie — in every '
            'form except "we" and "you all".',
        examples: [
          ('quiero', 'ik wil', 'I want'),
          ('queremos', 'wij willen', 'we want'),
        ],
      ),
      GrammarRule(
        titleNl: 'Stamwisseling o → ue',
        titleEn: 'Stem change o → ue',
        bodyNl: 'Net als bij e→ie, maar dan verandert de o in ue.',
        bodyEn: 'Just like e→ie, but here the o changes to ue.',
        examples: [
          ('puedo', 'ik kan', 'I can'),
          ('podemos', 'wij kunnen', 'we can'),
        ],
      ),
      GrammarRule(
        titleNl: 'Stamwisseling e → i',
        titleEn: 'Stem change e → i',
        bodyNl: 'Komt alleen voor bij -ir werkwoorden: de e wordt een i.',
        bodyEn: 'Only found in -ir verbs: the e becomes an i.',
        examples: [
          ('pido', 'ik vraag', 'I ask for'),
          ('pedimos', 'wij vragen', 'we ask for'),
        ],
      ),
      GrammarRule(
        titleNl: 'Volledig onregelmatig',
        titleEn: 'Fully irregular',
        bodyNl:
            'Een paar veelgebruikte werkwoorden volgen geen enkel patroon en '
            'moeten uit het hoofd geleerd worden: ser, estar, ir, haber, ver.',
        bodyEn:
            'A handful of very common verbs follow no pattern at all and '
            'have to be memorised: ser, estar, ir, haber, ver.',
        examples: [
          ('soy', 'ik ben', 'I am'),
          ('voy', 'ik ga', 'I go'),
        ],
      ),
    ],
  ),
  GrammarCategory(
    titleNl: 'Ser vs. estar',
    titleEn: 'Ser vs. estar',
    icon: Icons.compare_arrows,
    rules: [
      GrammarRule(
        titleNl: 'Ser: blijvende eigenschappen',
        titleEn: 'Ser: permanent characteristics',
        bodyNl:
            '"Ser" gebruik je voor wie of wat iets ís: identiteit, '
            'nationaliteit, beroep, karakter, tijd en datum.',
        bodyEn:
            'Use "ser" for who or what something is: identity, '
            'nationality, occupation, character, time and date.',
        examples: [
          ('Soy médico.', 'Ik ben arts.', 'I am a doctor.'),
          ('Es alta.', 'Zij is lang.', 'She is tall.'),
        ],
      ),
      GrammarRule(
        titleNl: 'Estar: toestand en locatie',
        titleEn: 'Estar: state and location',
        bodyNl:
            '"Estar" gebruik je voor waar iets zich bevindt, en voor '
            'tijdelijke toestanden zoals gevoelens of gezondheid.',
        bodyEn:
            'Use "estar" for where something is located, and for '
            'temporary states such as feelings or health.',
        examples: [
          ('Estoy en casa.', 'Ik ben thuis.', 'I am at home.'),
          ('Está cansado.', 'Hij is moe.', 'He is tired.'),
        ],
      ),
    ],
  ),
  GrammarCategory(
    titleNl: 'Voornaamwoorden',
    titleEn: 'Pronouns',
    icon: Icons.people_outline,
    rules: [
      GrammarRule(
        titleNl: 'Persoonlijke voornaamwoorden',
        titleEn: 'Personal pronouns',
        bodyNl:
            'yo, tú, él/ella, nosotros, vosotros, ellos/ellas. Ze worden '
            'vaak weggelaten omdat de werkwoordsvorm al aangeeft wie het '
            'onderwerp is.',
        bodyEn:
            'yo, tú, él/ella, nosotros, vosotros, ellos/ellas. They are '
            'often left out, since the verb ending already shows who the '
            'subject is.',
        examples: [
          ('(Yo) hablo español.', 'Ik spreek Spaans.', 'I speak Spanish.'),
        ],
      ),
      GrammarRule(
        titleNl: 'Bezittelijke voornaamwoorden',
        titleEn: 'Possessive pronouns',
        bodyNl:
            'mi, tu, su, nuestro/a, vuestro/a, su — vóór het zelfstandig '
            'naamwoord, en ze passen zich aan het getal (en bij '
            'nuestro/vuestro ook het geslacht) van dat woord aan.',
        bodyEn:
            'mi, tu, su, nuestro/a, vuestro/a, su — placed before the '
            'noun, and they agree with the number (and, for '
            'nuestro/vuestro, gender) of that noun.',
        examples: [
          ('mi casa', 'mijn huis', 'my house'),
          ('nuestros amigos', 'onze vrienden', 'our friends'),
        ],
      ),
    ],
  ),
  GrammarCategory(
    titleNl: 'Ontkenning & vraagzinnen',
    titleEn: 'Negation & questions',
    icon: Icons.help_outline,
    rules: [
      GrammarRule(
        titleNl: 'Ontkenning met no',
        titleEn: 'Negation with no',
        bodyNl:
            'Zet "no" vóór het werkwoord om een zin ontkennend te maken — '
            'eenvoudiger dan in het Nederlands, er is geen los ontkennend '
            'woord na het werkwoord nodig.',
        bodyEn:
            'Place "no" before the verb to make a sentence negative — '
            'simpler than in English, there is no separate negative word '
            'needed after the verb.',
        examples: [
          ('No hablo francés.', 'Ik spreek geen Frans.', "I don't speak French."),
        ],
      ),
      GrammarRule(
        titleNl: 'Vraagwoorden',
        titleEn: 'Question words',
        bodyNl:
            'qué (wat), quién (wie), dónde (waar), cuándo (wanneer), cómo '
            '(hoe), por qué (waarom) — altijd met accent als het om een '
            'vraag gaat.',
        bodyEn:
            'qué (what), quién (who), dónde (where), cuándo (when), cómo '
            '(how), por qué (why) — always with an accent when used as a '
            'question word.',
        examples: [
          ('¿Dónde vives?', 'Waar woon je?', 'Where do you live?'),
        ],
      ),
      GrammarRule(
        titleNl: 'Vraag- en uitroeptekens aan het begin',
        titleEn: 'Opening question and exclamation marks',
        bodyNl:
            'Spaans zet een omgekeerd vraagteken (¿) of uitroepteken (¡) aan '
            'het begin van een vraag of uitroep, naast het gewone teken aan '
            'het eind.',
        bodyEn:
            'Spanish places an inverted question mark (¿) or exclamation '
            'mark (¡) at the start of a question or exclamation, in '
            'addition to the regular mark at the end.',
        examples: [
          ('¿Cómo estás?', 'Hoe gaat het?', 'How are you?'),
          ('¡Qué bien!', 'Wat leuk!', 'How nice!'),
        ],
      ),
    ],
  ),
];
