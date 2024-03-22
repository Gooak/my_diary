package com.my_little_memory_diary

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.net.Uri
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetBackgroundIntent
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

class HomeWidgetProvider : HomeWidgetProvider() {
        override fun onUpdate(
                        context: Context,
                        appWidgetManager: AppWidgetManager,
                        appWidgetIds: IntArray,
                        widgetData: SharedPreferences
        ) {
                appWidgetIds.forEach { widgetId ->
                        val views =
                                        RemoteViews(context.packageName, R.layout.widget_layout)
                                                        .apply {
                                                                val pendingIntent =
                                                                                HomeWidgetLaunchIntent
                                                                                                .getActivity(
                                                                                                                context,
                                                                                                                MainActivity::class
                                                                                                                                .java
                                                                                                )
                                                                setOnClickPendingIntent(
                                                                                R.id.widget_root,
                                                                                pendingIntent
                                                                )
                                                                val todoList =
                                                                                widgetData.getString(
                                                                                                "todoList",
                                                                                                ""
                                                                                )
                                                                var todoText = todoList
                                                                if (todoList == "") {
                                                                    todoText = "오늘 투두리스트를 작성하세요"
                                                                }
                                                                setTextViewText(
                                                                                R.id.todoList,
                                                                    todoText
                                                                )
//
//                                                                                              val
//                                                                 backgroundIntent =
//
//
//
//                                                                 HomeWidgetBackgroundIntent
//
//
//
//                                                                 .getBroadcast(
//
//
//
//                                                                          context,
//
//
//
//                                                                          Uri.parse(
//
//
//
//
//                                                                 "myAppWidget://todoOnClick"
//
//
//
//                                                                          )
//
//
//                                                                                            )
//
//
//                                                                 setOnClickPendingIntent(
//
//
//                                                                     R.id.widget_root,
//
//
//                                                                            backgroundIntent
//
//                                                                                              )
                                                        }
                        appWidgetManager.updateAppWidget(widgetId, views)
                }
        }
}
