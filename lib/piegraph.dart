import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class DonutAutoLabelChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  DonutAutoLabelChart(this.seriesList, {this.animate});

  /// Creates a [PieChart] with sample data and no transition.
  factory DonutAutoLabelChart.withSampleData(info) {
    return new DonutAutoLabelChart(
      _createSampleData(info),
      // Disable animations for image tests.
      animate: false,
    );
  }


  @override
  Widget build(BuildContext context) {
   // String attmonthh =getmonth();
  //var now = new DateTime.now();
// var formatter = new DateFormat('MMMM');

 // String formatted = formatter.format(now);
    return new charts.PieChart(seriesList,
        animate: true,

    /*  behaviors: [
        new charts.ChartTitle(formatted,
       behaviorPosition: charts.BehaviorPosition.top,
        titleOutsideJustification: charts.OutsideJustification.start,
        innerPadding: 18),
      ],*/

        // Configure the width of the pie slices to 60px. The remaining space in
        // the chart will be left as a hole in the center.
        //
        // [ArcLabelDecorator] will automatically position the label inside the
        // arc if the label will fit. If the label will not fit, it will draw
        // outside of the arc with a leader line. Labels can always display
        // inside or outside using [LabelPosition].
        //
        // Text style for inside / outside can be controlled independently by
        // setting [insideLabelStyleSpec] and [outsideLabelStyleSpec].
        //
        // Example configuring different styles for inside/outside:
        //       new charts.ArcLabelDecorator(
        //          insideLabelStyleSpec: new charts.TextStyleSpec(...),
        //          outsideLabelStyleSpec: new charts.TextStyleSpec(...)),
        defaultRenderer: new charts.ArcRendererConfig(
            arcWidth: 60,
            arcRendererDecorators: [new charts.ArcLabelDecorator(labelPosition: charts.ArcLabelPosition.auto)]),


    );


  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<LinearSales, String>> _createSampleData(info) {
   /* final data = [
      new LinearSales(0, 100),
      new LinearSales(1, 75),
      new LinearSales(2, 25),
      new LinearSales(3, 5),
    ];
*/
    final data = [



      new LinearSales('Leave', int.parse(info[0]['leave'])),

      new LinearSales('Absent', int.parse(info[0]['absent'])),
      new LinearSales('Present', int.parse(info[0]['present'])),


    ];
    return [
      new charts.Series<LinearSales, String >(
        id: 'Attandance',
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: data,
        // Set a label accessor to control the text of the arc label.
     labelAccessorFn: (LinearSales row, _) => '${row.year}:${row.sales}',
        //  labelAccessorFn: (LinearSales sales, _) =>
          //'${sales.year}: \$${sales.sales.toString()}'
      )
    ];
  }
}

/// Sample linear data type.
class LinearSales {
  final String year;
  final int  sales;

  LinearSales(this.year, this.sales);
}
/*getmonth ()async{
  final prefs = await SharedPreferences.getInstance();
  String attmonth = prefs.getString('attmonth')??"";
  return attmonth;
}*/

