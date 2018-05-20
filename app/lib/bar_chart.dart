import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

/// Example of using a custom primary measure axis replacing the default
/// gridline rendering with a short tick rendering. It also turns on the axis
/// line so that the ticks have something to line up against.
///
/// There are many axis styling options in the SmallTickRenderer allowing you
/// to customize the font, tick lengths, and offsets.
class BarChart extends StatelessWidget {
  final List<double> list;
  final bool animate;

  BarChart(this.list, {this.animate: true});


  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      getGraphs(list),
      animate: animate,

      /// Customize the primary measure axis using a small tick renderer.
      /// Note: use String instead of num for ordinal domain axis
      /// (typically bar charts).
      primaryMeasureAxis: new charts.NumericAxisSpec(
          renderSpec: new charts.SmallTickRendererSpec(
            // Tick and Label styling here.
          )),
      secondaryMeasureAxis: null
    );
  }

  /// Create series list with single series
  List<charts.Series<OrdinalSales, String>> getGraphs(List<double> l) {
    final globalSalesData = [
      new OrdinalSales('Mon', (l[0] * 100).floor()),
      new OrdinalSales('Tue', (l[1] * 100).floor()),
      new OrdinalSales('Wen', (l[2] * 100).floor()),
      new OrdinalSales('Thu', (l[3] * 100).floor()),
      new OrdinalSales('Fri', (l[4] * 100).floor()),
      new OrdinalSales('Sat', (l[5] * 100).floor()),
      new OrdinalSales('Sun', (l[6] * 100).floor()),
    ];

    return [
      new charts.Series<OrdinalSales, String>(
        id: 'Chart id',
        domainFn: (OrdinalSales sales, _) => sales.day,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: globalSalesData,
      ),
    ];
  }
}

class OrdinalSales {
  final String day;
  final int sales;

  OrdinalSales(this.day, this.sales);
}