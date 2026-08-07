import 'package:flutter_test/flutter_test.dart';
import 'package:taalleer/app_state.dart';
import 'package:taalleer/home_widget_service.dart';
import 'package:taalleer/models.dart';

void main() {
  group('widgetDataFor', () {
    test('bevat de huidige streak', () {
      // De streak-getter valt terug op 0 zonder een geldige lastActivityWeek
      // (zie AppState.streak) — nowWeek vastzetten zodat "week 100" telt
      // als de meest recente toets-activiteit.
      final state = AppState(
        nowWeek: () => 100,
        streakState: const StreakState(streak: 7, lastActivityWeek: 100),
      );
      final data = widgetDataFor(state);
      expect(data['streak'], '7');
    });

    test('bevat een week-label met een weeknummer', () {
      final state = AppState(streakState: const StreakState(streak: 0));
      final data = widgetDataFor(state);
      expect(data['week_label'], startsWith('Week '));
    });

    test('streak 0 wordt correct weergegeven', () {
      final state = AppState();
      expect(widgetDataFor(state)['streak'], '0');
    });
  });
}
