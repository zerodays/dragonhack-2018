import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

/// Example of using a custom primary measure axis replacing the default
/// gridline rendering with a short tick rendering. It also turns on the axis
/// line so that the ticks have something to line up against.
///
/// There are many axis styling options in the SmallTickRenderer allowing you
/// to customize the font, tick lengths, and offsets.
class BarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  BarChart(this.seriesList, {this.animate});

  factory BarChart.withSampleData() {
    return new BarChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: true,
    );
  }


  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList,
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
  static List<charts.Series<OrdinalSales, String>> _createSampleData() {
    final globalSalesData = [
      new OrdinalSales('Mon', 13),
      new OrdinalSales('Tue', 20),
      new OrdinalSales('Wen', 4),
      new OrdinalSales('Thu', 16),
      new OrdinalSales('Fri', 52),
      new OrdinalSales('Sat', 0),
      new OrdinalSales('Sun', 10),
    ];

    return [
      new charts.Series<OrdinalSales, String>(
        id: 'Global Revenue',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: globalSalesData,
      ),
    ];
  }
}

/// Sample ordinal data type.
class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}