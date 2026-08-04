import 'package:flutter_test/flutter_test.dart';
import 'package:taalleer/notifications.dart';

void main() {
  group('nextTrigger', () {
    test('vandaag vóór het gekozen uur geeft vandaag', () {
      final now = DateTime(2026, 8, 3, 10, 0);
      final result = nextTrigger(now, 19);
      expect(result, DateTime(2026, 8, 3, 19, 0));
    });

    test('vandaag na het gekozen uur geeft morgen', () {
      final now = DateTime(2026, 8, 3, 20, 0);
      final result = nextTrigger(now, 19);
      expect(result, DateTime(2026, 8, 4, 19, 0));
    });

    test('exact op het gekozen uur geeft morgen (al gepasseerd)', () {
      final now = DateTime(2026, 8, 3, 19, 0);
      final result = nextTrigger(now, 19);
      expect(result, DateTime(2026, 8, 4, 19, 0));
    });

    test('randgeval rond middernacht: uur 0', () {
      final now = DateTime(2026, 8, 3, 23, 30);
      final result = nextTrigger(now, 0);
      expect(result, DateTime(2026, 8, 4, 0, 0));
    });

    test('maandovergang wordt correct afgehandeld', () {
      final now = DateTime(2026, 8, 31, 20, 0);
      final result = nextTrigger(now, 19);
      expect(result, DateTime(2026, 9, 1, 19, 0));
    });
  });
}
