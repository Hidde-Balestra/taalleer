import 'package:flutter_test/flutter_test.dart';
import 'package:taalleer/languages/es/es_stories.dart';
import 'package:taalleer/story_content.dart';

void main() {
  group('kSpanishStories', () {
    test('bevat 15 verhalen, 5 per niveau', () {
      expect(kSpanishStories, hasLength(15));
      for (final level in StoryLevel.values) {
        expect(
          kSpanishStories.where((s) => s.level == level),
          hasLength(5),
          reason: level.name,
        );
      }
    });

    test('elk verhaal heeft niet-lege titels/onderwerp en minstens één '
        'alinea', () {
      for (final story in kSpanishStories) {
        expect(story.id, isNotEmpty);
        expect(story.titleTarget, isNotEmpty, reason: story.id);
        expect(story.titleNl, isNotEmpty, reason: story.id);
        expect(story.titleEn, isNotEmpty, reason: story.id);
        expect(story.topicNl, isNotEmpty, reason: story.id);
        expect(story.topicEn, isNotEmpty, reason: story.id);
        expect(story.paragraphs, isNotEmpty, reason: story.id);
        for (final paragraph in story.paragraphs) {
          expect(paragraph.target, isNotEmpty, reason: story.id);
          expect(paragraph.nl, isNotEmpty, reason: story.id);
        }
      }
    });

    test('verhaal-id\'s zijn uniek', () {
      final ids = kSpanishStories.map((s) => s.id).toSet();
      expect(ids, hasLength(kSpanishStories.length));
    });
  });
}
