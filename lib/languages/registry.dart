import '../language_course.dart';
import 'es/es_course.dart';

/// Alle talen die in TaalLeer geleerd kunnen worden. Een taal toevoegen: een
/// nieuwe map onder `languages/` met een `LanguageCourse`-implementatie, en
/// die hier registreren.
final List<LanguageCourse> kCourses = [SpanishCourse()];

/// Zoekt een cursus op id, of valt terug op de eerste geregistreerde cursus
/// als [id] onbekend is (bijv. een oude instelling na het verwijderen van
/// een taal).
LanguageCourse courseById(String id) =>
    kCourses.firstWhere((c) => c.id == id, orElse: () => kCourses.first);
