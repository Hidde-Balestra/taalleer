import '../../models.dart';

/// Invulzinnen voor de "invuloefening in context": een zin met een
/// weggelaten vervoegde werkwoordsvorm, per infinitief.
///
/// Bewust een kleine, handgekozen set (net als `es_examples.dart`) — elke
/// zin is met zorg geschreven en gecontroleerd i.p.v. automatisch
/// gegenereerd. Elk werkwoord hieronder komt ook echt voor in
/// `es_words.dart` (nagekeken, geen giswerk). Het verwachte antwoord wordt
/// niet apart opgeslagen: dat is gewoon `word.present[entry.person]`, al
/// aanwezig via de bestaande vervoeging in `es_grammar.dart`.
///
/// "gustar" en "deber" zijn bewust weggelaten: "gustar" vervoegt naar het
/// onderwerp van de gevoelde zaak, niet naar de persoon ("me gusta", niet
/// "yo gusto") — een gewone persoon-invuloefening zou daar een fout patroon
/// aanleren.
const Map<String, ClozeEntry> kSpanishCloze = {
  'ser': ClozeEntry(
    sentenceTemplate: 'Yo ___ profesor.',
    translationNl: 'Ik ben leraar.',
    person: 0,
  ),
  'estar': ClozeEntry(
    sentenceTemplate: 'Ella ___ muy cansada hoy.',
    translationNl: 'Zij is vandaag erg moe.',
    person: 2,
  ),
  'tener': ClozeEntry(
    sentenceTemplate: 'Tú ___ dos hermanos.',
    translationNl: 'Jij hebt twee broers of zussen.',
    person: 1,
  ),
  'hacer': ClozeEntry(
    sentenceTemplate: 'Yo ___ la cena todos los días.',
    translationNl: 'Ik maak elke dag het avondeten.',
    person: 0,
  ),
  'poder': ClozeEntry(
    sentenceTemplate: 'Nosotros ___ ir a la playa mañana.',
    translationNl: 'Wij kunnen morgen naar het strand gaan.',
    person: 3,
  ),
  'decir': ClozeEntry(
    sentenceTemplate: 'Él siempre ___ la verdad.',
    translationNl: 'Hij zegt altijd de waarheid.',
    person: 2,
  ),
  'ir': ClozeEntry(
    sentenceTemplate: 'Ellos ___ al cine los viernes.',
    translationNl: 'Zij gaan op vrijdag naar de bioscoop.',
    person: 5,
  ),
  'ver': ClozeEntry(
    sentenceTemplate: 'Yo ___ la televisión por la noche.',
    translationNl: "Ik kijk 's avonds televisie.",
    person: 0,
  ),
  'dar': ClozeEntry(
    sentenceTemplate: 'Tú siempre me ___ buenos consejos.',
    translationNl: 'Jij geeft me altijd goede adviezen.',
    person: 1,
  ),
  'saber': ClozeEntry(
    sentenceTemplate: 'Ella ___ hablar tres idiomas.',
    translationNl: 'Zij kan drie talen spreken.',
    person: 2,
  ),
  'querer': ClozeEntry(
    sentenceTemplate: 'Yo ___ un café, por favor.',
    translationNl: 'Ik wil graag een koffie.',
    person: 0,
  ),
  'llegar': ClozeEntry(
    sentenceTemplate: 'Nosotros ___ a las ocho.',
    translationNl: 'Wij komen om acht uur aan.',
    person: 3,
  ),
  'poner': ClozeEntry(
    sentenceTemplate: 'Yo ___ la mesa antes de comer.',
    translationNl: 'Ik dek de tafel voor het eten.',
    person: 0,
  ),
  'creer': ClozeEntry(
    sentenceTemplate: '¿Tú ___ en fantasmas?',
    translationNl: 'Geloof jij in spoken?',
    person: 1,
  ),
  'hablar': ClozeEntry(
    sentenceTemplate: 'Ella ___ español muy bien.',
    translationNl: 'Zij spreekt heel goed Spaans.',
    person: 2,
  ),
  'llevar': ClozeEntry(
    sentenceTemplate: 'Yo ___ una chaqueta azul.',
    translationNl: 'Ik draag een blauwe jas.',
    person: 0,
  ),
  'seguir': ClozeEntry(
    sentenceTemplate: 'Yo ___ las instrucciones con cuidado.',
    translationNl: 'Ik volg de instructies zorgvuldig.',
    person: 0,
  ),
  'encontrar': ClozeEntry(
    sentenceTemplate: 'Nosotros no ___ las llaves.',
    translationNl: 'Wij vinden de sleutels niet.',
    person: 3,
  ),
  'venir': ClozeEntry(
    sentenceTemplate: '¿Tú ___ a la fiesta esta noche?',
    translationNl: 'Kom jij vanavond naar het feest?',
    person: 1,
  ),
  'pensar': ClozeEntry(
    sentenceTemplate: 'Yo ___ mucho en mi familia.',
    translationNl: 'Ik denk veel aan mijn familie.',
    person: 0,
  ),
  'salir': ClozeEntry(
    sentenceTemplate: 'Ellos ___ de casa muy temprano.',
    translationNl: 'Zij gaan heel vroeg het huis uit.',
    person: 5,
  ),
  'tomar': ClozeEntry(
    sentenceTemplate: 'Él ___ café cada mañana.',
    translationNl: 'Hij drinkt elke ochtend koffie.',
    person: 2,
  ),
  'conocer': ClozeEntry(
    sentenceTemplate: 'Yo ___ a mucha gente aquí.',
    translationNl: 'Ik ken hier veel mensen.',
    person: 0,
  ),
  'vivir': ClozeEntry(
    sentenceTemplate: 'Nosotros ___ en Madrid.',
    translationNl: 'Wij wonen in Madrid.',
    person: 3,
  ),
  'sentir': ClozeEntry(
    sentenceTemplate: 'Yo ___ un dolor en la espalda.',
    translationNl: 'Ik voel pijn in mijn rug.',
    person: 0,
  ),
  'mirar': ClozeEntry(
    sentenceTemplate: 'Tú ___ las estrellas por la noche.',
    translationNl: "Jij kijkt 's avonds naar de sterren.",
    person: 1,
  ),
  'empezar': ClozeEntry(
    sentenceTemplate: 'La clase ___ a las nueve.',
    translationNl: 'De les begint om negen uur.',
    person: 2,
  ),
  'esperar': ClozeEntry(
    sentenceTemplate: 'Nosotros ___ el autobús.',
    translationNl: 'Wij wachten op de bus.',
    person: 3,
  ),
  'buscar': ClozeEntry(
    sentenceTemplate: 'Yo ___ mis gafas.',
    translationNl: 'Ik zoek mijn bril.',
    person: 0,
  ),
  'trabajar': ClozeEntry(
    sentenceTemplate: 'Ella ___ en un hospital.',
    translationNl: 'Zij werkt in een ziekenhuis.',
    person: 2,
  ),
  'escribir': ClozeEntry(
    sentenceTemplate: 'Yo ___ una carta a mi abuela.',
    translationNl: 'Ik schrijf een brief aan mijn oma.',
    person: 0,
  ),
  'entender': ClozeEntry(
    sentenceTemplate: '¿Tú ___ la pregunta?',
    translationNl: 'Begrijp jij de vraag?',
    person: 1,
  ),
  'pedir': ClozeEntry(
    sentenceTemplate: 'Ellos ___ la cuenta al final.',
    translationNl: 'Zij vragen aan het einde om de rekening.',
    person: 5,
  ),
  'recordar': ClozeEntry(
    sentenceTemplate: 'Yo no ___ su nombre.',
    translationNl: 'Ik herinner me zijn naam niet.',
    person: 0,
  ),
  'necesitar': ClozeEntry(
    sentenceTemplate: 'Nosotros ___ más tiempo.',
    translationNl: 'Wij hebben meer tijd nodig.',
    person: 3,
  ),
  'leer': ClozeEntry(
    sentenceTemplate: 'Él ___ el periódico cada mañana.',
    translationNl: 'Hij leest elke ochtend de krant.',
    person: 2,
  ),
  'abrir': ClozeEntry(
    sentenceTemplate: 'Yo ___ la ventana porque hace calor.',
    translationNl: 'Ik doe het raam open omdat het warm is.',
    person: 0,
  ),
  'explicar': ClozeEntry(
    sentenceTemplate: 'La profesora ___ la lección.',
    translationNl: 'De lerares legt de les uit.',
    person: 2,
  ),
  'preguntar': ClozeEntry(
    sentenceTemplate: 'Tú siempre me ___ lo mismo.',
    translationNl: 'Jij vraagt me altijd hetzelfde.',
    person: 1,
  ),
  'estudiar': ClozeEntry(
    sentenceTemplate: 'Yo ___ español todos los días.',
    translationNl: 'Ik studeer elke dag Spaans.',
    person: 0,
  ),
  'correr': ClozeEntry(
    sentenceTemplate: 'Nosotros ___ en el parque los domingos.',
    translationNl: 'Wij rennen op zondag in het park.',
    person: 3,
  ),
  'ayudar': ClozeEntry(
    sentenceTemplate: 'Ella ___ a sus vecinos.',
    translationNl: 'Zij helpt haar buren.',
    person: 2,
  ),
  'jugar': ClozeEntry(
    sentenceTemplate: 'Ellos ___ al fútbol los sábados.',
    translationNl: 'Zij voetballen op zaterdag.',
    person: 5,
  ),
  'escuchar': ClozeEntry(
    sentenceTemplate: 'Yo ___ música mientras estudio.',
    translationNl: 'Ik luister naar muziek terwijl ik studeer.',
    person: 0,
  ),
  'olvidar': ClozeEntry(
    sentenceTemplate: '¿Tú ___ las llaves otra vez?',
    translationNl: 'Vergeet jij de sleutels weer?',
    person: 1,
  ),
  'comer': ClozeEntry(
    sentenceTemplate: 'Él ___ una manzana cada día.',
    translationNl: 'Hij eet elke dag een appel.',
    person: 2,
  ),
  'aprender': ClozeEntry(
    sentenceTemplate: 'Nosotros ___ español juntos.',
    translationNl: 'Wij leren samen Spaans.',
    person: 3,
  ),
  'comprar': ClozeEntry(
    sentenceTemplate: 'Yo ___ pan fresco cada mañana.',
    translationNl: 'Ik koop elke ochtend vers brood.',
    person: 0,
  ),
  'cerrar': ClozeEntry(
    sentenceTemplate: 'Ellos ___ la tienda a las ocho.',
    translationNl: 'Zij sluiten de winkel om acht uur.',
    person: 5,
  ),
  'responder': ClozeEntry(
    sentenceTemplate: 'Ella ___ todos los correos rápido.',
    translationNl: 'Zij beantwoordt alle e-mails snel.',
    person: 2,
  ),
  'vender': ClozeEntry(
    sentenceTemplate: 'Yo ___ mi coche viejo.',
    translationNl: 'Ik verkoop mijn oude auto.',
    person: 0,
  ),
  'cantar': ClozeEntry(
    sentenceTemplate: 'Tú ___ muy bien.',
    translationNl: 'Jij zingt heel goed.',
    person: 1,
  ),
  'bailar': ClozeEntry(
    sentenceTemplate: 'Nosotros ___ salsa los viernes.',
    translationNl: 'Wij dansen salsa op vrijdag.',
    person: 3,
  ),
  'dormir': ClozeEntry(
    sentenceTemplate: 'Yo ___ ocho horas cada noche.',
    translationNl: 'Ik slaap elke nacht acht uur.',
    person: 0,
  ),
  'viajar': ClozeEntry(
    sentenceTemplate: 'Ellos ___ mucho por trabajo.',
    translationNl: 'Zij reizen veel voor hun werk.',
    person: 5,
  ),
  'nadar': ClozeEntry(
    sentenceTemplate: 'Ella ___ en el mar todos los veranos.',
    translationNl: 'Zij zwemt elke zomer in de zee.',
    person: 2,
  ),
  'cocinar': ClozeEntry(
    sentenceTemplate: 'Nosotros ___ juntos los domingos.',
    translationNl: 'Wij koken samen op zondag.',
    person: 3,
  ),
  'limpiar': ClozeEntry(
    sentenceTemplate: 'Yo ___ mi habitación cada semana.',
    translationNl: 'Ik maak elke week mijn kamer schoon.',
    person: 0,
  ),
  'caminar': ClozeEntry(
    sentenceTemplate: 'Tú ___ muy rápido.',
    translationNl: 'Jij loopt heel snel.',
    person: 1,
  ),
  'beber': ClozeEntry(
    sentenceTemplate: 'Él ___ mucha agua.',
    translationNl: 'Hij drinkt veel water.',
    person: 2,
  ),
  'preferir': ClozeEntry(
    sentenceTemplate: 'Yo ___ el té al café.',
    translationNl: 'Ik heb liever thee dan koffie.',
    person: 0,
  ),
  'enseñar': ClozeEntry(
    sentenceTemplate: 'El profesor ___ matemáticas.',
    translationNl: 'De leraar onderwijst wiskunde.',
    person: 2,
  ),
};
