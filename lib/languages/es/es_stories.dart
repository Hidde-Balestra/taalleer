import '../../story_content.dart';

/// Leesverhalen: een kleine, handgeschreven set (net als de voorbeeldzinnen
/// en de invulzinnen) — geen automatisch gegenereerde tekst. Drie niveaus,
/// vijf verhalen elk, uiteenlopende onderwerpen.
const List<Story> kSpanishStories = [
  // ─── Makkelijk ────────────────────────────────────────────────────────
  Story(
    id: 'beginner_daily_routine',
    titleTarget: 'Un día normal',
    titleNl: 'Een gewone dag',
    titleEn: 'A normal day',
    level: StoryLevel.beginner,
    topicNl: 'Dagelijks leven',
    topicEn: 'Daily life',
    paragraphs: [
      StoryParagraph(
        target:
            'Me llamo Laura. Todos los días me levanto a las siete de la '
            'mañana.',
        nl: "Ik heet Laura. Elke dag sta ik om zeven uur 's ochtends op.",
      ),
      StoryParagraph(
        target:
            'Primero, desayuno pan con mantequilla y bebo un café. '
            'Después, voy al trabajo en autobús.',
        nl:
            'Eerst ontbijt ik brood met boter en drink ik een koffie. '
            'Daarna ga ik met de bus naar mijn werk.',
      ),
      StoryParagraph(
        target:
            'Trabajo en una tienda de ropa. Por la tarde, vuelvo a casa y '
            'ceno con mi familia.',
        nl:
            'Ik werk in een kledingwinkel. \'s Middags ga ik terug naar '
            'huis en eet ik met mijn familie.',
      ),
      StoryParagraph(
        target:
            'Por la noche, leo un libro y me acuesto a las diez y media. '
            '¡Es un día normal!',
        nl:
            "'s Avonds lees ik een boek en ga ik om half elf naar bed. "
            'Het is een gewone dag!',
      ),
    ],
  ),
  Story(
    id: 'beginner_family',
    titleTarget: 'Mi familia',
    titleNl: 'Mijn familie',
    titleEn: 'My family',
    level: StoryLevel.beginner,
    topicNl: 'Familie',
    topicEn: 'Family',
    paragraphs: [
      StoryParagraph(
        target:
            'Mi familia es pequeña pero muy unida. Somos cuatro personas: '
            'mi padre, mi madre, mi hermano y yo.',
        nl:
            'Mijn familie is klein maar heel hecht. We zijn met vier '
            'personen: mijn vader, mijn moeder, mijn broer en ik.',
      ),
      StoryParagraph(
        target:
            'Mi padre se llama Carlos. Es alto y trabaja como profesor. '
            'Mi madre se llama Elena y es médica.',
        nl:
            'Mijn vader heet Carlos. Hij is lang en werkt als leraar. '
            'Mijn moeder heet Elena en is dokter.',
      ),
      StoryParagraph(
        target:
            'Mi hermano tiene doce años y le gusta jugar al fútbol. Yo '
            'tengo quince años y me gusta dibujar.',
        nl:
            'Mijn broer is twaalf jaar en houdt van voetballen. Ik ben '
            'vijftien jaar en houd van tekenen.',
      ),
      StoryParagraph(
        target:
            'Los domingos, comemos todos juntos en la casa de mis '
            'abuelos. Es mi momento favorito de la semana.',
        nl:
            'Op zondag eten we allemaal samen bij mijn grootouders. Dat '
            'is mijn favoriete moment van de week.',
      ),
    ],
  ),
  Story(
    id: 'beginner_cat',
    titleTarget: 'El gato de Ana',
    titleNl: 'De kat van Ana',
    titleEn: "Ana's cat",
    level: StoryLevel.beginner,
    topicNl: 'Dieren',
    topicEn: 'Animals',
    paragraphs: [
      StoryParagraph(
        target:
            'Ana tiene un gato pequeño y negro. Se llama Luna y tiene dos años.',
        nl: 'Ana heeft een kleine, zwarte kat. Ze heet Luna en is twee jaar oud.',
      ),
      StoryParagraph(
        target:
            'A Luna le gusta dormir en el sofá y jugar con una pelota '
            'roja. No le gusta el agua.',
        nl:
            'Luna houdt van slapen op de bank en spelen met een rode '
            'bal. Ze houdt niet van water.',
      ),
      StoryParagraph(
        target:
            'Cada mañana, Ana le da comida a Luna antes de ir al '
            'colegio. Luna espera en la cocina.',
        nl:
            'Elke ochtend geeft Ana Luna te eten voordat ze naar school '
            'gaat. Luna wacht in de keuken.',
      ),
      StoryParagraph(
        target:
            'Por la noche, Luna duerme encima de la cama de Ana. Son muy '
            'buenas amigas.',
        nl:
            "'s Avonds slaapt Luna boven op Ana's bed. Ze zijn heel goede "
            'vriendinnen.',
      ),
    ],
  ),
  Story(
    id: 'beginner_market',
    titleTarget: 'En el mercado',
    titleNl: 'Op de markt',
    titleEn: 'At the market',
    level: StoryLevel.beginner,
    topicNl: 'Eten',
    topicEn: 'Food',
    paragraphs: [
      StoryParagraph(
        target:
            'Los sábados, voy al mercado con mi madre. El mercado está '
            'en el centro de la ciudad.',
        nl:
            'Op zaterdag ga ik met mijn moeder naar de markt. De markt '
            'is in het centrum van de stad.',
      ),
      StoryParagraph(
        target:
            'Compramos frutas frescas: manzanas, plátanos y naranjas. '
            'También compramos pan y queso.',
        nl:
            'We kopen verse vruchten: appels, bananen en sinaasappels. '
            'We kopen ook brood en kaas.',
      ),
      StoryParagraph(
        target:
            'Mi madre habla con el vendedor de verduras. Él es muy '
            'simpático y siempre sonríe.',
        nl:
            'Mijn moeder praat met de groenteverkoper. Hij is erg aardig '
            'en glimlacht altijd.',
      ),
      StoryParagraph(
        target:
            'Después de comprar, tomamos un chocolate caliente en una '
            'cafetería pequeña. Me encanta el sábado.',
        nl:
            'Na het winkelen drinken we een warme chocolademelk in een '
            'klein café. Ik hou van de zaterdag.',
      ),
    ],
  ),
  Story(
    id: 'beginner_bedroom',
    titleTarget: 'Mi habitación',
    titleNl: 'Mijn kamer',
    titleEn: 'My room',
    level: StoryLevel.beginner,
    topicNl: 'Thuis',
    topicEn: 'Home',
    paragraphs: [
      StoryParagraph(
        target:
            'Mi habitación no es grande, pero me gusta mucho. Las paredes son azules.',
        nl: 'Mijn kamer is niet groot, maar ik hou er veel van. De muren zijn blauw.',
      ),
      StoryParagraph(
        target:
            'Tengo una cama, un escritorio y una estantería con muchos '
            'libros. También tengo una ventana grande.',
        nl:
            'Ik heb een bed, een bureau en een boekenkast met veel '
            'boeken. Ik heb ook een groot raam.',
      ),
      StoryParagraph(
        target:
            'Encima del escritorio, hay una lámpara y fotos de mis '
            'amigos. Me gusta estudiar allí.',
        nl:
            "Boven op het bureau staan een lamp en foto's van mijn "
            'vrienden. Ik studeer daar graag.',
      ),
      StoryParagraph(
        target:
            'Por las noches, miro las estrellas desde la ventana antes de dormir.',
        nl: "'s Avonds kijk ik vanuit het raam naar de sterren voordat ik ga slapen.",
      ),
    ],
  ),

  // ─── Gevorderd ────────────────────────────────────────────────────────
  Story(
    id: 'intermediate_beach_trip',
    titleTarget: 'Un viaje a la playa',
    titleNl: 'Een reisje naar het strand',
    titleEn: 'A trip to the beach',
    level: StoryLevel.intermediate,
    topicNl: 'Reizen',
    topicEn: 'Travel',
    paragraphs: [
      StoryParagraph(
        target:
            'El verano pasado, mi familia y yo viajamos a la costa. '
            'Cogimos el coche muy temprano por la mañana.',
        nl:
            'Afgelopen zomer reisden mijn familie en ik naar de kust. We '
            "namen 's ochtends heel vroeg de auto.",
      ),
      StoryParagraph(
        target:
            'Después de tres horas, llegamos a un pueblo pequeño cerca '
            'del mar. El hotel estaba justo enfrente de la playa.',
        nl:
            'Na drie uur kwamen we aan in een klein dorpje bij de zee. '
            'Het hotel stond precies tegenover het strand.',
      ),
      StoryParagraph(
        target:
            'Todos los días, nadamos en el mar y construimos castillos '
            'de arena. Por la tarde, comíamos helado en el paseo '
            'marítimo.',
        nl:
            "'s Middags aten we ijs op de boulevard. Elke dag zwommen we "
            'in de zee en bouwden we zandkastelen.',
      ),
      StoryParagraph(
        target:
            'Una noche, vimos una puesta de sol increíble. Fue el mejor '
            'viaje de mi vida.',
        nl:
            'Op een avond zagen we een ongelooflijke zonsondergang. Het '
            'was de mooiste reis van mijn leven.',
      ),
    ],
  ),
  Story(
    id: 'intermediate_surprise_party',
    titleTarget: 'La fiesta sorpresa',
    titleNl: 'Het verrassingsfeestje',
    titleEn: 'The surprise party',
    level: StoryLevel.intermediate,
    topicNl: 'Vrienden',
    topicEn: 'Friends',
    paragraphs: [
      StoryParagraph(
        target:
            'El cumpleaños de mi amiga Sofía era el sábado pasado. '
            'Decidimos organizar una fiesta sorpresa para ella.',
        nl:
            'De verjaardag van mijn vriendin Sofía was afgelopen '
            'zaterdag. We besloten een verrassingsfeestje voor haar te '
            'organiseren.',
      ),
      StoryParagraph(
        target:
            'Durante toda la semana, preparamos globos, una tarta de '
            'chocolate y una lista de música. Todo tenía que ser '
            'secreto.',
        nl:
            'De hele week bereidden we ballonnen, een chocoladetaart en '
            'een muzieklijst voor. Alles moest geheim blijven.',
      ),
      StoryParagraph(
        target:
            'El día de la fiesta, invitamos a Sofía a cenar en mi casa. '
            'Cuando abrió la puerta, todos gritamos: "¡Sorpresa!"',
        nl:
            'Op de dag van het feest nodigden we Sofía uit om bij mij '
            'thuis te eten. Toen ze de deur opendeed, riepen we '
            'allemaal: "Verrassing!"',
      ),
      StoryParagraph(
        target:
            'Sofía se puso muy contenta y casi lloró de alegría. '
            'Bailamos y comimos tarta hasta muy tarde.',
        nl:
            'Sofía werd heel blij en huilde bijna van vreugde. We '
            'dansten en aten taart tot heel laat.',
      ),
    ],
  ),
  Story(
    id: 'intermediate_lost_dog',
    titleTarget: 'El perro perdido',
    titleNl: 'De verdwaalde hond',
    titleEn: 'The lost dog',
    level: StoryLevel.intermediate,
    topicNl: 'Dieren',
    topicEn: 'Animals',
    paragraphs: [
      StoryParagraph(
        target:
            'Una tarde de otoño, Miguel encontró un perro solo en el '
            'parque. El perro estaba mojado y tenía mucho miedo.',
        nl:
            'Op een herfstmiddag vond Miguel een hond die alleen in het '
            'park liep. De hond was nat en erg bang.',
      ),
      StoryParagraph(
        target:
            'Miguel se acercó despacio y le habló con voz suave. El '
            'perro no llevaba collar, así que no podía saber su nombre.',
        nl:
            'Miguel liep langzaam dichterbij en sprak zachtjes tegen '
            'hem. De hond had geen halsband om, dus kon Miguel zijn '
            'naam niet weten.',
      ),
      StoryParagraph(
        target:
            'Decidió llevarlo a casa y le dio agua y comida. Al día '
            'siguiente, hizo carteles con una foto del perro.',
        nl:
            'Hij besloot hem mee naar huis te nemen en gaf hem water en '
            'eten. De volgende dag maakte hij posters met een foto van '
            'de hond.',
      ),
      StoryParagraph(
        target:
            'Dos días después, una familia llamó a la puerta. Era el '
            'perro de sus vecinos, que se llamaba Toby. Todos se '
            'alegraron mucho.',
        nl:
            'Twee dagen later klopte een gezin aan de deur. Het was de '
            'hond van hun buren, die Toby heette. Iedereen was heel '
            'blij.',
      ),
    ],
  ),
  Story(
    id: 'intermediate_new_job',
    titleTarget: 'Un nuevo trabajo',
    titleNl: 'Een nieuwe baan',
    titleEn: 'A new job',
    level: StoryLevel.intermediate,
    topicNl: 'Werk',
    topicEn: 'Work',
    paragraphs: [
      StoryParagraph(
        target:
            'El mes pasado, Elena empezó a trabajar en una empresa de '
            'tecnología. Estaba muy nerviosa el primer día.',
        nl:
            'Vorige maand begon Elena te werken bij een '
            'technologiebedrijf. Ze was erg zenuwachtig op de eerste '
            'dag.',
      ),
      StoryParagraph(
        target:
            'Sus compañeros la recibieron con una sonrisa y le '
            'explicaron todo con paciencia. Poco a poco, se sintió más '
            'segura.',
        nl:
            'Haar collega\'s ontvingen haar met een glimlach en legden '
            'alles geduldig uit. Beetje bij beetje voelde ze zich '
            'zekerder.',
      ),
      StoryParagraph(
        target:
            'Después de un mes, Elena ya conocía bien su trabajo. Le '
            'gustaba resolver problemas y aprender cosas nuevas cada '
            'día.',
        nl:
            'Na een maand kende Elena haar werk al goed. Ze hield ervan '
            'problemen op te lossen en elke dag nieuwe dingen te leren.',
      ),
      StoryParagraph(
        target:
            'Ahora, Elena está muy contenta con su decisión. Dice que '
            'cambiar de trabajo fue difícil, pero valió la pena.',
        nl:
            'Nu is Elena erg blij met haar beslissing. Ze zegt dat van '
            'baan veranderen moeilijk was, maar de moeite waard.',
      ),
    ],
  ),
  Story(
    id: 'intermediate_grandmother_recipe',
    titleTarget: 'La receta de mi abuela',
    titleNl: 'Het recept van mijn oma',
    titleEn: "My grandmother's recipe",
    level: StoryLevel.intermediate,
    topicNl: 'Eten',
    topicEn: 'Food',
    paragraphs: [
      StoryParagraph(
        target:
            'Cada domingo, mi abuela cocina una sopa especial. Es una '
            'receta que aprendió de su propia madre hace muchos años.',
        nl:
            'Elke zondag kookt mijn oma een speciale soep. Het is een '
            'recept dat ze vele jaren geleden van haar eigen moeder '
            'leerde.',
      ),
      StoryParagraph(
        target:
            'Primero, corta cebollas, zanahorias y patatas. Luego, las '
            'cocina lentamente con un poco de sal y hierbas.',
        nl:
            'Eerst snijdt ze uien, wortels en aardappelen. Daarna kookt '
            'ze ze langzaam met een beetje zout en kruiden.',
      ),
      StoryParagraph(
        target:
            'El olor llena toda la casa y todos sabemos que la comida '
            'está casi lista. Nos sentamos juntos a la mesa.',
        nl:
            'De geur vult het hele huis en we weten allemaal dat het '
            'eten bijna klaar is. We gaan samen aan tafel zitten.',
      ),
      StoryParagraph(
        target:
            'El mes pasado, le pedí a mi abuela que me enseñara la '
            'receta. Ahora también yo sé cocinar su sopa especial.',
        nl:
            'Vorige maand vroeg ik mijn oma of ze me het recept wilde '
            'leren. Nu kan ik ook haar speciale soep koken.',
      ),
    ],
  ),

  // ─── Lastig ───────────────────────────────────────────────────────────
  Story(
    id: 'advanced_lighthouse_mystery',
    titleTarget: 'El misterio del faro',
    titleNl: 'Het mysterie van de vuurtoren',
    titleEn: 'The mystery of the lighthouse',
    level: StoryLevel.advanced,
    topicNl: 'Mysterie',
    topicEn: 'Mystery',
    paragraphs: [
      StoryParagraph(
        target:
            'En un pueblo pequeño de la costa, había un viejo faro que '
            'llevaba años abandonado. Los habitantes contaban historias '
            'extrañas sobre una luz que aparecía allí por las noches.',
        nl:
            'In een klein kustdorpje stond een oude vuurtoren die al '
            'jaren verlaten was. De inwoners vertelden vreemde verhalen '
            "over een licht dat daar 's nachts verscheen.",
      ),
      StoryParagraph(
        target:
            'Una noche de tormenta, la joven pescadora Marta decidió '
            'investigar. Subió la escalera de piedra mientras el viento '
            'soplaba con fuerza.',
        nl:
            'Op een stormachtige nacht besloot de jonge visser Marta '
            'het te onderzoeken. Ze beklom de stenen trap terwijl de '
            'wind hard blies.',
      ),
      StoryParagraph(
        target:
            'Al llegar arriba, encontró una vieja lámpara de aceite '
            'todavía encendida, y junto a ella, un diario lleno de '
            'anotaciones sobre barcos perdidos.',
        nl:
            'Toen ze boven aankwam, vond ze een oude olielamp die nog '
            'brandde, en ernaast een dagboek vol aantekeningen over '
            'verdwenen schepen.',
      ),
      StoryParagraph(
        target:
            'Marta comprendió que el antiguo guardián del faro nunca '
            'había dejado de cuidar el lugar, incluso después de su '
            'muerte. Desde entonces, ella misma enciende la lámpara '
            'cada noche.',
        nl:
            'Marta begreep dat de oude vuurtorenwachter nooit was '
            'gestopt met het verzorgen van de plek, zelfs niet na zijn '
            'dood. Sindsdien steekt ze zelf elke avond de lamp aan.',
      ),
    ],
  ),
  Story(
    id: 'advanced_difficult_decision',
    titleTarget: 'La decisión difícil',
    titleNl: 'De moeilijke beslissing',
    titleEn: 'The difficult decision',
    level: StoryLevel.advanced,
    topicNl: 'Persoonlijk',
    topicEn: 'Personal',
    paragraphs: [
      StoryParagraph(
        target:
            'Cuando Daniel terminó sus estudios, recibió dos ofertas de '
            'trabajo el mismo día. Una era en su ciudad natal, cerca de '
            'su familia; la otra, en el extranjero, con un sueldo mucho '
            'más alto.',
        nl:
            'Toen Daniel zijn studie afrondde, kreeg hij op dezelfde '
            'dag twee baanaanbiedingen. De ene was in zijn '
            'geboortestad, dicht bij zijn familie; de andere in het '
            'buitenland, met een veel hoger salaris.',
      ),
      StoryParagraph(
        target:
            'Durante varias semanas, no pudo decidir. Hablaba con sus '
            'padres, con sus amigos, e incluso escribía listas de '
            'ventajas y desventajas por la noche.',
        nl:
            'Weken lang kon hij geen beslissing nemen. Hij praatte met '
            "zijn ouders, met zijn vrienden, en schreef 's avonds zelfs "
            'lijstjes met voor- en nadelen.',
      ),
      StoryParagraph(
        target:
            'Finalmente, comprendió que el dinero no era lo más '
            'importante para él. Prefería crecer profesionalmente '
            'rodeado de las personas que quería.',
        nl:
            'Uiteindelijk begreep hij dat geld niet het belangrijkste '
            'voor hem was. Hij wilde liever professioneel groeien '
            'omringd door de mensen van wie hij hield.',
      ),
      StoryParagraph(
        target:
            'Aceptó el trabajo en su ciudad. Años después, sigue '
            'pensando que fue la decisión correcta, aunque a veces se '
            'pregunta qué habría pasado si hubiera elegido lo '
            'contrario.',
        nl:
            'Hij accepteerde de baan in zijn stad. Jaren later denkt '
            'hij nog steeds dat het de juiste beslissing was, al vraagt '
            'hij zich soms af wat er zou zijn gebeurd als hij anders '
            'had gekozen.',
      ),
    ],
  ),
  Story(
    id: 'advanced_time_travel',
    titleTarget: 'Un viaje en el tiempo',
    titleNl: 'Een reis door de tijd',
    titleEn: 'A journey through time',
    level: StoryLevel.advanced,
    topicNl: 'Fictie',
    topicEn: 'Fiction',
    paragraphs: [
      StoryParagraph(
        target:
            'El profesor Ibáñez llevaba treinta años construyendo una '
            'máquina en su sótano. Nadie en el pueblo sabía exactamente '
            'qué hacía allí abajo, entre cables y libros polvorientos.',
        nl:
            'Professor Ibáñez was dertig jaar bezig geweest met het '
            'bouwen van een machine in zijn kelder. Niemand in het '
            'dorp wist precies wat hij daar beneden deed, tussen '
            'kabels en stoffige boeken.',
      ),
      StoryParagraph(
        target:
            'Una tarde de invierno, la máquina finalmente se encendió. '
            'Una luz blanca llenó la habitación y, cuando se apagó, el '
            'profesor ya no estaba en su sótano.',
        nl:
            'Op een winteravond kwam de machine eindelijk tot leven. '
            'Een wit licht vulde de kamer, en toen het doofde, was de '
            'professor niet meer in zijn kelder.',
      ),
      StoryParagraph(
        target:
            'Se encontró en la misma calle, pero cien años antes. Los '
            'coches habían desaparecido; en su lugar, caballos y '
            'carruajes recorrían las calles de tierra.',
        nl:
            'Hij bevond zich op dezelfde straat, maar honderd jaar '
            "eerder. De auto's waren verdwenen; in plaats daarvan "
            'reden paarden en koetsen over de onverharde straten.',
      ),
      StoryParagraph(
        target:
            'Durante unos días, el profesor observó aquel mundo antiguo '
            'con asombro, sin atreverse a hablar con nadie. Cuando por '
            'fin encontró el camino de vuelta a su época, decidió no '
            'contarle a nadie lo que había vivido.',
        nl:
            'Enkele dagen lang bekeek de professor die oude wereld met '
            'verbazing, zonder het aan te durven met iemand te praten. '
            'Toen hij eindelijk de weg terug naar zijn eigen tijd '
            'vond, besloot hij niemand te vertellen wat hij had '
            'meegemaakt.',
      ),
    ],
  ),
  Story(
    id: 'advanced_city_never_sleeps',
    titleTarget: 'La ciudad que nunca duerme',
    titleNl: 'De stad die nooit slaapt',
    titleEn: 'The city that never sleeps',
    level: StoryLevel.advanced,
    topicNl: 'Reizen',
    topicEn: 'Travel',
    paragraphs: [
      StoryParagraph(
        target:
            'Cuando Clara llegó a la gran ciudad por primera vez, se '
            'sintió pequeña entre los edificios altos y las calles '
            'llenas de gente. Todo se movía más rápido de lo que '
            'estaba acostumbrada.',
        nl:
            'Toen Clara voor het eerst in de grote stad aankwam, '
            'voelde ze zich klein tussen de hoge gebouwen en de '
            'drukke straten. Alles bewoog sneller dan ze gewend was.',
      ),
      StoryParagraph(
        target:
            'Por el día, la ciudad olía a café y a pan recién horneado. '
            'Los vendedores gritaban precios en las esquinas y los '
            'trenes pasaban bajo sus pies cada pocos minutos.',
        nl:
            'Overdag rook de stad naar koffie en vers gebakken brood. '
            'Verkopers riepen prijzen op de hoeken van de straat en '
            'treinen reden elke paar minuten onder haar voeten door.',
      ),
      StoryParagraph(
        target:
            'Por la noche, las luces de los rascacielos convertían la '
            'oscuridad en un espectáculo de colores. Clara descubrió '
            'que, incluso a las tres de la madrugada, las calles '
            'seguían llenas de vida.',
        nl:
            "'s Nachts veranderden de lichten van de wolkenkrabbers de "
            'duisternis in een kleurenspektakel. Clara ontdekte dat, '
            "zelfs om drie uur 's nachts, de straten nog steeds vol "
            'leven waren.',
      ),
      StoryParagraph(
        target:
            'Con el tiempo, aquella ciudad ruidosa se convirtió en su '
            'hogar. Aprendió a amar el caos que al principio tanto la '
            'asustaba.',
        nl:
            'Na verloop van tijd werd die drukke stad haar thuis. Ze '
            'leerde houden van de chaos waar ze in het begin zo bang '
            'voor was.',
      ),
    ],
  ),
  Story(
    id: 'advanced_last_train',
    titleTarget: 'El último tren',
    titleNl: 'De laatste trein',
    titleEn: 'The last train',
    level: StoryLevel.advanced,
    topicNl: 'Kort verhaal',
    topicEn: 'Short story',
    paragraphs: [
      StoryParagraph(
        target:
            'Eran las once y media de la noche cuando Roberto corrió '
            'hacia la estación. Si perdía el último tren, tendría que '
            'esperar hasta la mañana siguiente para volver a casa.',
        nl:
            'Het was half twaalf \'s nachts toen Roberto naar het '
            'station rende. Als hij de laatste trein miste, zou hij '
            'tot de volgende ochtend moeten wachten om naar huis te '
            'gaan.',
      ),
      StoryParagraph(
        target:
            'La estación estaba casi vacía. Solo una mujer mayor '
            'esperaba sentada en un banco, con una maleta pequeña a su '
            'lado y la mirada perdida en las vías.',
        nl:
            'Het station was bijna leeg. Alleen een oudere vrouw zat '
            'op een bankje te wachten, met een kleine koffer naast '
            'zich en een blik die verloren was op de rails.',
      ),
      StoryParagraph(
        target:
            'Roberto se sentó a su lado para recuperar el aliento. Ella '
            'le sonrió y le contó que llevaba cincuenta años tomando '
            'ese mismo tren, cada noche, para visitar la tumba de su '
            'marido.',
        nl:
            'Roberto ging naast haar zitten om op adem te komen. Ze '
            'glimlachte naar hem en vertelde dat ze al vijftig jaar '
            'elke avond dezelfde trein nam om het graf van haar man '
            'te bezoeken.',
      ),
      StoryParagraph(
        target:
            'Cuando el tren finalmente llegó, Roberto la ayudó a subir '
            'con su maleta. Durante el trayecto, pensó que a veces las '
            'historias más bonitas se encuentran cuando menos las '
            'esperamos.',
        nl:
            'Toen de trein eindelijk aankwam, hielp Roberto haar met '
            'haar koffer aan boord. Tijdens de rit dacht hij dat je de '
            'mooiste verhalen soms tegenkomt wanneer je ze het minst '
            'verwacht.',
      ),
    ],
  ),
];
