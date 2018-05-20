import 'package:flutter/material.dart';
import 'history.dart';
import 'stats.dart';

GlobalKey<HistoryState> historyKey = new GlobalKey<HistoryState>();
GlobalKey<StatsState> statsKey = new GlobalKey<StatsState>();

void reload() {
  historyKey.currentState?.getReceipts();
  statsKey.currentState?.getCharts();
}