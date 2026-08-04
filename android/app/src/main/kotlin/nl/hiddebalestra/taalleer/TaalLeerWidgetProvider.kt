package nl.hiddebalestra.taalleer

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider

/// Toont streak en weeknummer op het startscherm. De data zelf wordt door
/// Flutter geschreven (zie lib/home_widget_service.dart) via het
/// home_widget-package; deze provider leest 'm alleen en tekent 'm.
class TaalLeerWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.taalleer_widget).apply {
                val streak = widgetData.getString("streak", "0") ?: "0"
                val weekLabel = widgetData.getString("week_label", "") ?: ""
                setTextViewText(R.id.widget_streak, "🔥 $streak")
                setTextViewText(R.id.widget_week_label, weekLabel)
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
