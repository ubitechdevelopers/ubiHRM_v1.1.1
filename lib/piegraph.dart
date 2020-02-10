import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

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
    final List<LinearSales> data = <LinearSales>[
      new LinearSales('Present', int.parse(info[0]['present']), Colors.blueAccent),
      new LinearSales('Absent', int.parse(info[0]['absent']), Colors.red),
      /*new LinearSales('Week Off',int.parse(info[0]['weekoff']), Colors.orange),
      new LinearSales('Halfday', int.parse(info[0]['halfday']), Colors.blueGrey),
      new LinearSales('Holiday', int.parse(info[0]['holiday']), Colors.green),*/
      new LinearSales('Leave', int.parse(info[0]['leave']), Colors.blue),
     /* new LinearSales('Comp Off', int.parse(info[0]['compoff']), Colors.purpleAccent[100]),
      new LinearSales('WFH', int.parse(info[0]['workfromhome']), Colors.brown[200]),
      new LinearSales('Unpaid Leave', int.parse(info[0]['unpaidleave']),Colors.brown),
      new LinearSales('Unpaid Halfday', int.parse(info[0]['unpaidhalfday']),Colors.grey),*/
    ];

    return <charts.Series<LinearSales, String>>[
      new charts.Series<LinearSales, String >(
        id: 'Attandance',
        domainFn: (LinearSales sales, _) => sales.x,
        measureFn: (LinearSales sales, _) => sales.y,
        data: data,

        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault.lighter,
        fillColorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault.lighter,
        // Set a label accessor to control the text of the arc label.
        labelAccessorFn: (LinearSales row, _) => '${row.x}:${row.y}',
        //  labelAccessorFn: (LinearSales sales, _) =>
          //'${sales.year}: \$${sales.sales.toString()}'
      ),

    ];
  }
}

/// Sample linear data type.
class LinearSales {
  final dynamic x;
  final dynamic y;
  final Color color;
  LinearSales(this.x, this.y, this.color);
}
/*getmonth ()async{
  final prefs = await SharedPreferences.getInstance();
  String attmonth = prefs.getString('attmonth')??"";
  return attmonth;
}*/
