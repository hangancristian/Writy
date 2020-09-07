import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:fluttershare/pages/home.dart';

class CategoryChart extends StatefulWidget {
  CategoryChart();

  @override
  _CategoryChartState createState() => _CategoryChartState();
}

class ClicksPerYear {
  final String year;
  final double clicks;
  final charts.Color color;

  ClicksPerYear(this.year, this.clicks, Color color)
      : this.color = charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha);
}

class _CategoryChartState extends State<CategoryChart> {
  int users = 0;
  int tech = 0;
  int travel = 0;
  int food = 0;
  int politics = 0;
  int others = 0;
  List<String> searchResultsFuture;

  @override
  void initState() {
    super.initState();

    getUsers();
    getTech();
    getTravel();
    getFood();
    getPolitics();
    getOthers();
  }

  getUsers() async {
    QuerySnapshot snapshot = await usersRef.getDocuments();

    setState(() {
      users = snapshot.documents.length;
    });
  }

  getTech() async {
    QuerySnapshot snapshot =
        await usersRef.where('category', isEqualTo: "Tech").getDocuments();

    setState(() {
      tech = snapshot.documents.length;
    });
  }

  getTravel() async {
    QuerySnapshot snapshot =
        await usersRef.where('category', isEqualTo: "Travel").getDocuments();

    setState(() {
      travel = snapshot.documents.length;
    });
  }

  getFood() async {
    QuerySnapshot snapshot =
        await usersRef.where('category', isEqualTo: "Food").getDocuments();

    setState(() {
      food = snapshot.documents.length;
    });
  }

  getPolitics() async {
    QuerySnapshot snapshot =
        await usersRef.where('category', isEqualTo: "Politics").getDocuments();

    setState(() {
      politics = snapshot.documents.length;
    });
  }

  getOthers() async {
    QuerySnapshot snapshot =
        await usersRef.where('category', isEqualTo: "Others").getDocuments();

    setState(() {
      others = snapshot.documents.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    var data = [
      ClicksPerYear('Tech', (tech / users) * 100, Colors.red),
      ClicksPerYear('Travel', (travel / users) * 100, Colors.yellow),
      ClicksPerYear('Food', (food / users) * 100, Colors.green),
      ClicksPerYear('Politics', (politics / users) * 100, Colors.blue),
      ClicksPerYear('Others', (others / users) * 100, Colors.brown),
    ];

    var series = [
      charts.Series(
        domainFn: (ClicksPerYear clickData, _) => clickData.year,
        measureFn: (ClicksPerYear clickData, _) => clickData.clicks,
        colorFn: (ClicksPerYear clickData, _) => clickData.color,
        id: 'Clicks',
        data: data,
        labelAccessorFn: (ClicksPerYear row, _) => '${row.year}: ${row.clicks}',
      ),
    ];

    var chart = charts.PieChart(
      series,
      animate: true,
      behaviors: [
        new charts.DatumLegend(
          // Positions for "start" and "end" will be left and right respectively
          // for widgets with a build context that has directionality ltr.
          // For rtl, "start" and "end" will be right and left respectively.
          // Since this example has directionality of ltr, the legend is
          // positioned on the right side of the chart.
          position: charts.BehaviorPosition.end,

          // By default, if the position of the chart is on the left or right of
          // the chart, [horizontalFirst] is set to false. This means that the
          // legend entries will grow as new rows first instead of a new column.
          horizontalFirst: false,
          // This defines the padding around each legend entry.
          cellPadding: new EdgeInsets.only(right: 4.0, bottom: 4.0),
          // Set [showMeasures] to true to display measures in series legend.
          showMeasures: true,
          // Configure the measure value to be shown by default in the legend.
          legendDefaultMeasure: charts.LegendDefaultMeasure.firstValue,
          // Optionally provide a measure formatter to format the measure value.
          // If none is specified the value is formatted as a decimal.
          measureFormatter: (num value) {
            
            return value == null ? '-' : '${value}%';
          },
        ),
      ],
      defaultRenderer: new charts.ArcRendererConfig(arcWidth: 60),
    );

    var chartWidget = Padding(
      padding: EdgeInsets.all(32.0),
      child: SizedBox(
        height: 250.0,
        child: chart,
      ),
    );

    return Container(
      child: chartWidget,
    );
  }
}
