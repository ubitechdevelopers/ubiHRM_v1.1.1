/// Bar chart example
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:math';
import 'package:intl/intl.dart';

/// Example of a grouped bar chart with three series, each rendered with GroupedFillColorBarChart
/// different fill colors.HorizontalBarLabelCustomChart
/// //StackedHorizontalBarChart
/// //BarChartWithSecondaryAxis
class StackedHorizontalBarChart  extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  //BarOutsideLabelChart
  StackedHorizontalBarChart (this.seriesList, {this.animate});

  factory StackedHorizontalBarChart .withSampleData(info) {
    return new StackedHorizontalBarChart (
      _createSampleData(info),
      // Disable animations for image tests.
      animate: false,
    );
  }
  /*@override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList,
      animate: animate,
  // vertical: false,
      barRendererDecorator: new charts.BarLabelDecorator<String>(),
      // Hide domain axis.
      domainAxis:
      new charts.OrdinalAxisSpec(renderSpec: new charts.NoneRenderSpec()),
    );
  }
*/

  /*@override
  Widget build(BuildContext context) {

    return new charts.BarChart(
      seriesList,
      animate: animate,
      vertical: false,
      //barGroupingType: charts.BarGroupingType.stacked,
  barGroupingType: charts.BarGroupingType.grouped,
      barRendererDecorator: new charts.BarLabelDecorator<String>(),
      behaviors: [new charts.SeriesLegend()

      ],
      domainAxis:
      new charts.OrdinalAxisSpec(renderSpec: new charts.NoneRenderSpec()),
      // It is important when using both primary and secondary axes to choose
      // the same number of ticks for both sides to get the gridlines to line
      // up.
    /*  primaryMeasureAxis: new charts.NumericAxisSpec(
          tickProviderSpec:
          new charts.BasicNumericTickProviderSpec(desiredTickCount: 3)),
      secondaryMeasureAxis: new charts.NumericAxisSpec(
          tickProviderSpec:
          new charts.BasicNumericTickProviderSpec(desiredTickCount: 3)),*/
    );
  }




  /// Create one series with sample hard coded data.
  static List<charts.Series<OrdinalSales, String>> _createSampleData() {
   // final random = new Random();
    final data = [
      new OrdinalSales('Leave Entitled', 10),
      new OrdinalSales('Leave utilized', 12),
      new OrdinalSales('Balance Leave ', 12),

    ];

   final tableSalesData = [
      //new OrdinalSales('Casual Leave', 27),
     // new OrdinalSales('Loss of pay', 2),
      new OrdinalSales('Leave Entitled', 20),
      new OrdinalSales('Leave utilized', 15),
      new OrdinalSales('Balance Leave  ', 12),

    ];
    final mobileSalesData = [
      //new OrdinalSales('Casual Leave', 13),
      //  new OrdinalSales('Loss of pay', 17),
      new OrdinalSales('Leave Entitled',13),
      new OrdinalSales('Leave utilized', 17),
      new OrdinalSales('Balance Leave ', 12),
    ];

    return [
      new charts.Series<OrdinalSales, String>(
        id: 'Casual',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        fillColorFn: (_, __) =>
        charts.MaterialPalette.blue.shadeDefault.lighter,
        data: data,
        // Set a label accessor to control the text of the bar label.
       // labelAccessorFn: (OrdinalSales sales, _) =>
        labelAccessorFn: (OrdinalSales row, _) => '${row.year}: ${row.sales}',
      //  '${sales.year}: \$${sales.sales.toString()}',
       /* insideLabelStyleAccessorFn: (OrdinalSales sales, _) {
          final color = (sales.year == '2014')
              ? charts.MaterialPalette.red.shadeDefault
              : charts.MaterialPalette.yellow.shadeDefault.darker;
          return new charts.TextStyleSpec(color: color);
        },
        outsideLabelStyleAccessorFn: (OrdinalSales sales, _) {
          final color = (sales.year == '2014')
              ? charts.MaterialPalette.red.shadeDefault
              : charts.MaterialPalette.yellow.shadeDefault.darker;
          return new charts.TextStyleSpec(color: color);
        },*/
      ),
     new charts.Series<OrdinalSales, String>(
        id: 'Loss of pay',
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: tableSalesData,
        // labelAccessorFn: (OrdinalSales row, _) => '${row.year}: ${row.sales}',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        fillColorFn: (_, __) =>
        charts.MaterialPalette.red.shadeDefault.lighter,
        domainFn: (OrdinalSales sales, _) => sales.year,
        labelAccessorFn: (OrdinalSales row, _) => '${row.year}: ${row.sales}',
       // labelAccessorFn: (OrdinalSales sales, _) =>
        //'${sales.year}: \$${sales.sales.toString()}',
       /* insideLabelStyleAccessorFn: (OrdinalSales sales, _) {
          final color = (sales.year == '2014')
              ? charts.MaterialPalette.red.shadeDefault
              : charts.MaterialPalette.yellow.shadeDefault.darker;
          return new charts.TextStyleSpec(color: color);
        },
        outsideLabelStyleAccessorFn: (OrdinalSales sales, _) {
          final color = (sales.year == '2014')
              ? charts.MaterialPalette.red.shadeDefault
              : charts.MaterialPalette.yellow.shadeDefault.darker;
          return new charts.TextStyleSpec(color: color);
        },*/
      ),
      new charts.Series<OrdinalSales, String>(
        id: 'Sick leave',
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: mobileSalesData,
        // labelAccessorFn: (OrdinalSales row, _) => '${row.year}: ${row.sales}',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        fillColorFn: (_, __) => charts.MaterialPalette.green.shadeDefault.lighter,
        domainFn: (OrdinalSales sales, _) => sales.year,
        labelAccessorFn: (OrdinalSales row, _) => '${row.year}: ${row.sales}',
       // labelAccessorFn: (OrdinalSales sales, _) =>
        //'${sales.year}: \$${sales.sales.toString()}',
       /* insideLabelStyleAccessorFn: (OrdinalSales sales, _) {
          final color = (sales.year == '2014')
              ? charts.MaterialPalette.red.shadeDefault
              : charts.MaterialPalette.yellow.shadeDefault.darker;
          return new charts.TextStyleSpec(color: color);
        },
        outsideLabelStyleAccessorFn: (OrdinalSales sales, _) {
          final color = (sales.year == '2014')
              ? charts.MaterialPalette.red.shadeDefault
              : charts.MaterialPalette.yellow.shadeDefault.darker;
          return new charts.TextStyleSpec(color: color);
        },*/
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
*/
  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList,
      animate: true,
      // vertical: false,
      // Configure a stroke width to enable borders on the bars.
      defaultRenderer: new charts.BarRendererConfig(
        groupingType: charts.BarGroupingType.grouped, strokeWidthPx: 2.0,
      ),

      primaryMeasureAxis: new charts.NumericAxisSpec(
        tickProviderSpec: new charts.BasicNumericTickProviderSpec(
          desiredTickCount: 11,
        ),
      ),
      // barRendererDecorator: new charts.BarLabelDecorator<String>(),
      // domainAxis:   new charts.OrdinalAxisSpec(renderSpec: new charts.NoneRenderSpec()),
      barRendererDecorator: new charts.BarLabelDecorator<String>(),
      behaviors: [
        new charts.SeriesLegend(),
        new charts.SlidingViewport(),
        new charts.PanAndZoomBehavior(),
        // Add the sliding viewport behavior to have the viewport center on the
        // domain that is currently selected.
        //new charts.SlidingViewport(),
        // A pan and zoom behavior helps demonstrate the sliding viewport
        // behavior by allowing the data visible in the viewport to be adjusted
        // dynamically.
        // new charts.PanAndZoomBehavior
        //
        //
        //
        //
        // (),
      ],
      /*    customSeriesRenderers: [
          new charts.BarTargetLineRendererConfig<String>(
            // ID used to link series to this renderer.
              customRendererId: 'customTargetLine',
              groupingType: charts.BarGroupingType.grouped)
        ]*/
    );
    // Hide domain axis.
    // domainAxis:
    //   new charts.OrdinalAxisSpec(renderSpec: new charts.NoneRenderSpec()),

    // );

  }
  factory StackedHorizontalBarChart.withRandomData(info) {
    return new StackedHorizontalBarChart(_createSampleData(info));
  }
  /// Create series list with multiple series
  static List<charts.Series<OrdinalSales, String>> _createSampleData(info) {
    final random = new Random();
   // print(info);
    // print("00000000000"+info[]['totalleaveC']);
    final desktopSalesData = [new OrdinalSales('', 0) ];
    final mobileSalesData = [new OrdinalSales('', 0) ];
    final tableSalesData = [new OrdinalSales('', 0) ];
    desktopSalesData.clear();
    for(int i=0;i<info.length;i++){
    //  print(")))))))))))))");
    //  print(info[i]['total']);
     // print("--------");
    //  print(info[i]['used']);
   //   print("2222222222");
    //  print(info[i]['left']);

      desktopSalesData.add(
        new OrdinalSales(info[i]['name'], double.parse(info[i]['total'])),
      );
      mobileSalesData.add(
        new OrdinalSales(info[i]['name'], double.parse(info[i]['used'])),
      );
      tableSalesData.add(
        new OrdinalSales(info[i]['name'], double.parse(info[i]['left'])),
      );
    }

    /*final desktopSalesData = [
      new OrdinalSales('Casual Leave', double .parse(info[0]['totalleaveC'])),
      new OrdinalSales('LOP',  double .parse(info[0]['totalleaveL'])),
      new OrdinalSales('Annual', double .parse(info[0]['totalleaveA'])),

      new OrdinalSales('Casual Leave', double .parse(info[0]['usedleaveC'])),
      new OrdinalSales('LOP',  double .parse(info[0]['usedleaveL'])),
      new OrdinalSales('Annual', double .parse(info[0]['usedleaveA'])),

      new OrdinalSales('Casual Leave', double .parse(info[0]['leftleaveC'])),
      new OrdinalSales('LOP',  double .parse(info[0]['leftleaveL'])),
      new OrdinalSales('Annual', double .parse(info[0]['leftleaveA'])),

    ];*/
    /*final mobileSalesData = [
      new OrdinalSales('Casual Leave', double .parse(info[0]['usedleaveC'])),
      new OrdinalSales('LOP',  double .parse(info[0]['usedleaveL'])),
      new OrdinalSales('Annual', double .parse(info[0]['usedleaveA'])),
    ];

    final tableSalesData = [
      new OrdinalSales('Casual Leave', double .parse(info[0]['leftleaveC'])),
      new OrdinalSales('LOP',  double .parse(info[0]['leftleaveL'])),
      new OrdinalSales('Annual', double .parse(info[0]['leftleaveA'])),
    ];*/



    return [
      // Blue bars with a lighter center color.


      new charts.Series<OrdinalSales, String>(
        id: 'Entitled',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,

        data: desktopSalesData,

        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        fillColorFn: (_, __) =>
        charts.MaterialPalette.blue.shadeDefault.lighter,

        labelAccessorFn: (OrdinalSales sales, _) =>
        ' ${sales.sales}',


      ),

      // Solid red bars. Fill color will default to the series color if no
      // fillColorFn is configured.
      new charts.Series<OrdinalSales, String>(
        id: 'Utilized',
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: mobileSalesData,
        // labelAccessorFn: (OrdinalSales row, _) => '${row.year}: ${row.sales}',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        fillColorFn: (_, __) =>
        charts.MaterialPalette.red.shadeDefault.lighter,
        domainFn: (OrdinalSales sales, _) => sales.year,

        labelAccessorFn: (OrdinalSales sales, _) =>
        '${sales.sales}',

      ),
      // Hollow green bars.
      new charts.Series<OrdinalSales, String>(
        id: 'Balance',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data:  tableSalesData,

        //labelAccessorFn: (OrdinalSales row, _) => '${row.year}: ${row.sales}',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        fillColorFn: (_, __) => charts.MaterialPalette.green.shadeDefault.lighter,

        labelAccessorFn: (OrdinalSales sales, _) =>
        '${sales.sales}',

      ),


    ];
  }
}

/// Sample ordinal data type.
class OrdinalSales {
  final String year;
  final double sales;

  OrdinalSales(this.year, this.sales);
}