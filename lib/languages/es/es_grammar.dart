/// Spaanse grammatica-hulpmiddelen: de tegenwoordige tijd (presente de
/// indicativo) van werkwoorden en het lidwoord (el/la) van zelfstandige
/// naamwoorden.
///
/// Beide worden uit het woord zelf afgeleid: regelmatige vervoegingen via
/// vaste uitgangen, onregelmatige en stamwisselende werkwoorden via tabellen,
/// en het geslacht via uitgangsregels met een lijst uitzonderingen. Zo werkt
/// het ook voor later toegevoegde woorden.
library;

/// De persoonsvormen in vaste volgorde.
const List<String> kPronouns = [
  'yo',
  'tú',
  'él/ella',
  'nosotros',
  'vosotros',
  'ellos/ellas',
];

const List<String> _reflexive = ['me', 'te', 'se', 'nos', 'os', 'se'];

// ─── Werkwoorden ──────────────────────────────────────────────────────────

/// Volledig onregelmatige werkwoorden (yo, tú, él, nosotros, vosotros, ellos).
const Map<String, List<String>> _fullyIrregular = {
  'ser': ['soy', 'eres', 'es', 'somos', 'sois', 'son'],
  'estar': ['estoy', 'estás', 'está', 'estamos', 'estáis', 'están'],
  'ir': ['voy', 'vas', 'va', 'vamos', 'vais', 'van'],
  'haber': ['he', 'has', 'ha', 'hemos', 'habéis', 'han'],
  'ver': ['veo', 'ves', 've', 'vemos', 'veis', 'ven'],
  'dar': ['doy', 'das', 'da', 'damos', 'dais', 'dan'],
  'saber': ['sé', 'sabes', 'sabe', 'sabemos', 'sabéis', 'saben'],
  'decir': ['digo', 'dices', 'dice', 'decimos', 'decís', 'dicen'],
  'oír': ['oigo', 'oyes', 'oye', 'oímos', 'oís', 'oyen'],
  'reír': ['río', 'ríes', 'ríe', 'reímos', 'reís', 'ríen'],
  'freír': ['frío', 'fríes', 'fríe', 'freímos', 'freís', 'fríen'],
  'enviar': ['envío', 'envías', 'envía', 'enviamos', 'enviáis', 'envían'],
  'confiar': [
    'confío',
    'confías',
    'confía',
    'confiamos',
    'confiáis',
    'confían',
  ],
  'vaciar': ['vacío', 'vacías', 'vacía', 'vaciamos', 'vaciáis', 'vacían'],
  'continuar': [
    'continúo',
    'continúas',
    'continúa',
    'continuamos',
    'continuáis',
    'continúan',
  ],
  'reunir': ['reúno', 'reúnes', 'reúne', 'reunimos', 'reunís', 'reúnen'],
  'construir': [
    'construyo',
    'construyes',
    'construye',
    'construimos',
    'construís',
    'construyen',
  ],
  'huir': ['huyo', 'huyes', 'huye', 'huimos', 'huís', 'huyen'],
};

/// Stamwisseling: bron>doel, toegepast op yo/tú/él/ellos.
const Map<String, String> _stemChange = {
  // e → ie
  'querer': 'e>ie', 'pensar': 'e>ie', 'empezar': 'e>ie', 'comenzar': 'e>ie',
  'entender': 'e>ie', 'perder': 'e>ie', 'sentir': 'e>ie', 'mentir': 'e>ie',
  'preferir': 'e>ie', 'encender': 'e>ie', 'defender': 'e>ie',
  'despertar': 'e>ie', 'herir': 'e>ie', 'negar': 'e>ie', 'tener': 'e>ie',
  'venir': 'e>ie',
  // o → ue
  'poder': 'o>ue', 'volver': 'o>ue', 'dormir': 'o>ue', 'morir': 'o>ue',
  'contar': 'o>ue', 'encontrar': 'o>ue', 'recordar': 'o>ue', 'mostrar': 'o>ue',
  'costar': 'o>ue', 'soñar': 'o>ue', 'volar': 'o>ue', 'mover': 'o>ue',
  'colgar': 'o>ue',
  // e → i
  'pedir': 'e>i', 'servir': 'e>i', 'repetir': 'e>i', 'seguir': 'e>i',
  'conseguir': 'e>i', 'perseguir': 'e>i', 'elegir': 'e>i', 'corregir': 'e>i',
  'medir': 'e>i', 'despedir': 'e>i', 'rendir': 'e>i',
  // u → ue
  'jugar': 'u>ue',
};

/// Onregelmatige yo-vorm (naast een eventuele stamwisseling in de andere
/// vormen).
const Map<String, String> _yoIrregular = {
  'tener': 'tengo',
  'venir': 'vengo',
  'poner': 'pongo',
  'salir': 'salgo',
  'hacer': 'hago',
  'traer': 'traigo',
  'caer': 'caigo',
  'suponer': 'supongo',
  'proponer': 'propongo',
  'mantener': 'mantengo',
  'obtener': 'obtengo',
  'conocer': 'conozco',
  'reconocer': 'reconozco',
  'parecer': 'parezco',
  'aparecer': 'aparezco',
  'agradecer': 'agradezco',
  'ofrecer': 'ofrezco',
  'crecer': 'crezco',
  'nacer': 'nazco',
  'conducir': 'conduzco',
  'coger': 'cojo',
  'proteger': 'protejo',
  'recoger': 'recojo',
  'escoger': 'escojo',
  'seguir': 'sigo',
  'conseguir': 'consigo',
  'perseguir': 'persigo',
  'elegir': 'elijo',
  'corregir': 'corrijo',
};

/// Vervoegt [infinitive] in de tegenwoordige tijd (6 vormen), of geeft `null`
/// als het geen op -ar/-er/-ir eindigend werkwoord is.
List<String>? presentTense(String infinitive) {
  var verb = infinitive.trim().toLowerCase();
  var reflexive = false;
  if (verb.length > 4 &&
      (verb.endsWith('arse') ||
          verb.endsWith('erse') ||
          verb.endsWith('irse') ||
          verb.endsWith('írse'))) {
    reflexive = true;
    verb = verb.substring(0, verb.length - 2);
  }

  final forms = _conjugate(verb);
  if (forms == null) return null;
  if (!reflexive) return forms;
  return [for (var i = 0; i < 6; i++) '${_reflexive[i]} ${forms[i]}'];
}

List<String>? _conjugate(String verb) {
  final irregular = _fullyIrregular[verb];
  if (irregular != null) return List.of(irregular);

  String group;
  if (verb.endsWith('ar')) {
    group = 'ar';
  } else if (verb.endsWith('er')) {
    group = 'er';
  } else if (verb.endsWith('ir') || verb.endsWith('ír')) {
    group = 'ir';
  } else {
    return null;
  }
  final stem = verb.substring(0, verb.length - 2);
  final endings = group == 'ar'
      ? ['o', 'as', 'a', 'amos', 'áis', 'an']
      : group == 'er'
      ? ['o', 'es', 'e', 'emos', 'éis', 'en']
      : ['o', 'es', 'e', 'imos', 'ís', 'en'];

  final forms = [for (var i = 0; i < 6; i++) stem + endings[i]];

  final change = _stemChange[verb];
  if (change != null) {
    final changedStem = _applyStemChange(stem, change);
    for (final i in [0, 1, 2, 5]) {
      forms[i] = changedStem + endings[i];
    }
  }

  // -uir (bijv. huir, construir): tussen-y in yo/tú/él/ellos.
  if (verb.endsWith('uir') &&
      !verb.endsWith('guir') &&
      !verb.endsWith('quir')) {
    for (final i in [0, 1, 2, 5]) {
      forms[i] = '${stem}y${endings[i]}';
    }
  }

  final yo = _yoIrregular[verb];
  if (yo != null) forms[0] = yo;

  return forms;
}

String _applyStemChange(String stem, String rule) {
  final parts = rule.split('>');
  final from = parts[0], to = parts[1];
  final idx = stem.lastIndexOf(from);
  if (idx < 0) return stem;
  return stem.substring(0, idx) + to + stem.substring(idx + from.length);
}

// ─── Lidwoord (el/la) ─────────────────────────────────────────────────────

/// Woorden die geen lidwoord krijgen (bijvoeglijke naamwoorden, telwoorden,
/// bijwoorden, voorzetsels, voegwoorden, vraagwoorden en groetwoorden).
const Set<String> kNonNouns = {
  // Telwoorden
  'cero', 'uno', 'dos', 'tres', 'cuatro', 'cinco', 'seis', 'siete', 'ocho',
  'nueve', 'diez', 'once', 'doce', 'trece', 'catorce', 'quince', 'veinte',
  'treinta', 'cuarenta', 'cincuenta', 'sesenta', 'setenta', 'ochenta',
  'noventa', 'cien', 'mil', 'primero', 'último',
  // Kleuren (bijvoeglijk)
  'rojo', 'azul', 'verde', 'amarillo', 'negro', 'blanco', 'gris', 'marrón',
  'morado', 'dorado',
  // Bijvoeglijke naamwoorden
  'grande', 'pequeño', 'alto', 'bajo', 'largo', 'corto', 'ancho', 'estrecho',
  'gordo', 'delgado', 'fuerte', 'débil', 'rápido', 'lento', 'nuevo', 'viejo',
  'bueno', 'malo', 'mejor', 'peor', 'bonito', 'feo', 'hermoso', 'guapo',
  'limpio', 'sucio', 'lleno', 'vacío', 'abierto', 'cerrado', 'caliente',
  'frío', 'caro', 'barato', 'rico', 'pobre', 'fácil', 'difícil', 'feliz',
  'triste', 'contento', 'enfadado', 'cansado', 'enfermo', 'sano', 'vivo',
  'muerto', 'ocupado', 'libre', 'tranquilo', 'nervioso', 'valiente', 'tímido',
  'simpático', 'antipático', 'amable', 'serio', 'divertido', 'aburrido',
  'interesante', 'importante', 'necesario', 'posible', 'imposible', 'correcto',
  'falso', 'verdadero', 'igual', 'diferente', 'similar', 'extraño', 'normal',
  'especial', 'famoso', 'conocido', 'peligroso', 'dulce', 'amargo', 'salado',
  'picante', 'suave', 'duro', 'blando', 'pesado', 'ligero', 'oscuro', 'claro',
  'brillante', 'mojado', 'seco', 'listo', 'tonto', 'loco', 'sabio', 'profundo',
  'plano', 'redondo', 'cuadrado', 'curvo', 'agudo', 'grueso', 'fino', 'áspero',
  'liso', 'transparente', 'templado', 'maduro', 'crudo', 'fresco', 'podrido',
  'venenoso', 'ruidoso', 'silencioso', 'educado', 'grosero', 'generoso',
  'tacaño', 'honesto', 'sincero', 'orgulloso', 'humilde', 'egoísta',
  'perezoso', 'inteligente', 'estúpido', 'raro', 'común', 'único', 'completo',
  'entero', 'medio', 'doble', 'próximo', 'anterior', 'recto',
  // Nationaliteiten (bijvoeglijk)
  'español', 'francés', 'alemán', 'italiano', 'inglés',
  // Bijwoorden, voorzetsels, voegwoorden, vraag- en verwijswoorden
  'sí', 'no', 'quizás', 'también', 'tampoco', 'siempre', 'nunca', 'luego',
  'después', 'antes', 'durante', 'mientras', 'ya', 'todavía', 'aquí', 'allí',
  'cerca', 'lejos', 'arriba', 'abajo', 'dentro', 'fuera', 'delante', 'detrás',
  'encima', 'debajo', 'entre', 'junto', 'alrededor', 'muy', 'mucho', 'poco',
  'bastante', 'demasiado', 'casi', 'solo', 'bien', 'mal', 'despacio',
  'además', 'entonces', 'pero', 'porque', 'aunque', 'cuando', 'donde', 'como',
  'qué', 'quién', 'cuál', 'cuánto', 'nada', 'algo', 'todo', 'nadie',
  'alguien', 'cada', 'otro', 'mismo', 'este', 'ese', 'aquel', 'con', 'sin',
  'para', 'por', 'sobre', 'hasta', 'desde', 'hacia', 'contra', 'según',
  'gracias', 'hola', 'adiós', 'perdón', 'bienvenido',
};

/// Zelfstandige naamwoorden die vrouwelijk zijn ondanks de uitgangsregel.
const Set<String> _feminineExceptions = {
  'mano', 'foto', 'moto', 'radio', // -o maar vrouwelijk
  'noche', 'tarde', 'gente', 'llave', 'sangre', 'nieve', 'calle', 'clase',
  'madre', 'carne', 'leche', 'muerte', 'suerte', 'fuente', 'nube',
  'serpiente', 'frase', 'superficie', 'fe', // -e maar vrouwelijk
  'sal', 'piel', 'cárcel', 'señal', 'capital', 'catedral', // -l
  'flor', 'mujer', 'coliflor', // -r
  'tos', 'gafas', // -s
  'razón', 'sartén', 'imagen', // -n
};

/// Zelfstandige naamwoorden die mannelijk zijn (of het lidwoord `el` krijgen)
/// ondanks de uitgangsregel.
const Set<String> _masculineExceptions = {
  'día', 'mapa', 'problema', 'planeta', 'idioma', 'yoga', 'pijama', 'tranvía',
  'cometa', 'sofá', // -a maar mannelijk
  'agua', 'águila', 'aula', 'alma', // vrouwelijk maar 'el' (klinker-a)
  'pez', 'lápiz', 'arroz', 'ajedrez', 'maíz', 'disfraz', // -z maar mannelijk
};

/// Geeft het lidwoord ('el' of 'la') van een zelfstandig naamwoord.
String articleFor(String noun) {
  final w = noun.trim().toLowerCase();
  if (w.isEmpty) return 'el';
  if (_feminineExceptions.contains(w)) return 'la';
  if (_masculineExceptions.contains(w)) return 'el';

  // Betrouwbare achtervoegsels.
  const feminineSuffixes = [
    'ción',
    'sión',
    'dad',
    'tad',
    'tud',
    'umbre',
    'eza',
    'cia',
  ];
  for (final s in feminineSuffixes) {
    if (w.endsWith(s)) return 'la';
  }
  if (w.endsWith('aje') || w.endsWith('or')) return 'el';

  final last = w[w.length - 1];
  switch (last) {
    case 'a':
      return 'la';
    case 'o':
    case 'e':
      return 'el';
    case 'd':
    case 'z':
      return 'la';
    default:
      return 'el';
  }
}

/// Is [word] een werkwoord (op basis van de Engelse vertaling)?
bool isVerbEntry(String es, String en) => en.startsWith('to ') || es == 'deber';
