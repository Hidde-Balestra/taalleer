import 'package:home_widget/home_widget.dart';

import 'app_state.dart';
import 'utils.dart';

const androidHomeWidgetName = 'TaalLeerWidgetProvider';

/// Pure mapping van de app-state naar de data die de widget nodig heeft —
/// los van de eigenlijke `HomeWidget`-aanroepen, dus apart testbaar. De
/// native rendering zelf kan in deze omgeving niet getest worden.
Map<String, String> widgetDataFor(AppState state) => {
  'streak': '${state.streak}',
  'week_label': 'Week ${currentWeekNumber()}',
};

/// Schrijft de widget-data weg en ververst de widget op het startscherm
/// (no-op als de gebruiker geen widget heeft toegevoegd).
Future<void> updateHomeWidget(AppState state) async {
  final data = widgetDataFor(state);
  for (final entry in data.entries) {
    await HomeWidget.saveWidgetData<String>(entry.key, entry.value);
  }
  await HomeWidget.updateWidget(androidName: androidHomeWidgetName);
}
