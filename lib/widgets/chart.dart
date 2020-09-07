import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:fluttershare/pages/home.dart';

class AgeChart extends StatefulWidget {
  final String profileId;
  AgeChart({this.profileId});

  @override
  _AgeChartState createState() => _AgeChartState();
}

class ClicksPerYear {
  final String year;
  final int clicks;
  final charts.Color color;

  ClicksPerYear(this.year, this.clicks, Color color)
      : this.color = charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha);
}

class _AgeChartState extends State<AgeChart> {
  int followerCount = 0;
  int followerCount2 = 0;
  int followerCount3 = 0;
  List<String> searchResultsFuture;

  @override
  void initState() {
    super.initState();

    getFollowerso2();
    getFollowerso4();
    getFollowerso6();
  }

  getFollowerso2() async {
    QuerySnapshot snapshot = await followersRef
        .document(widget.profileId)
        .collection('userFollowers')
        .where('age', isLessThanOrEqualTo: 30)
        .getDocuments();

    setState(() {
      followerCount = snapshot.documents.length;
    });
  }

  getFollowerso4() async {
    QuerySnapshot snapshot = await followersRef
        .document(widget.profileId)
        .collection('userFollowers')
        .where('age', isGreaterThan: 30)
        .getDocuments();

    setState(() {
      followerCount2 = snapshot.documents.length;
    });
  }

  getFollowerso6() async {
    QuerySnapshot snapshot = await followersRef
        .document(widget.profileId)
        .collection('userFollowers')
        .where('age', isGreaterThan: 60)
        .getDocuments();

    setState(() {
      followerCount3 = snapshot.documents.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    var data = [
      ClicksPerYear('Under 30', followerCount, Colors.red),
      ClicksPerYear('30 to 60', followerCount2 - followerCount3, Colors.yellow),
      ClicksPerYear('Over 60', followerCount3, Colors.green),
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

    var chart = charts.BarChart(
      series,
      animate: true,
      vertical: false,
      domainAxis: new charts.OrdinalAxisSpec(
        renderSpec: new charts.SmallTickRendererSpec(
          // Tick and Label styling here.
          labelStyle: new charts.TextStyleSpec(
              fontSize: 18, // size in Pts.
              color: charts.MaterialPalette.black),

          // Change the line colors to match text color.
          lineStyle:
              new charts.LineStyleSpec(color: charts.MaterialPalette.black),
        ),
      ),
      primaryMeasureAxis: new charts.NumericAxisSpec(
        renderSpec: new charts.GridlineRendererSpec(
          // Tick and Label styling here.
          labelStyle: new charts.TextStyleSpec(
              fontSize: 18, // size in Pts.
              color: charts.MaterialPalette.black),

          // Change the line colors to match text color.
          lineStyle:
              new charts.LineStyleSpec(color: charts.MaterialPalette.black),
        ),
      ),
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
