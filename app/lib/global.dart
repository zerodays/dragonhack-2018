import 'package:flutter/material.dart';
import 'history.dart';
import 'stats.dart';

GlobalKey<HistoryState> historyKey = new GlobalKey<HistoryState>();
GlobalKey<StatsState> statsKey = new GlobalKey<StatsState>();
final GlobalKey<ScaffoldState> mainScaffoldKey = new GlobalKey<ScaffoldState>();

void reload() {
  historyKey.currentState?.getReceipts();
  statsKey.currentState?.getCharts();
}

void showSnackbar(String message) {
  mainScaffoldKey.currentState?.showSnackBar(new SnackBar(
    content: new Text(message),
  ));
}