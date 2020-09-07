import 'package:flutter/material.dart';
import 'package:fluttershare/widgets/chart.dart';
import 'package:fluttershare/widgets/coutries_global.dart';
import 'package:fluttershare/widgets/global_chart.dart';
import 'package:fluttershare/pages/home.dart';
import 'package:fluttershare/widgets/coutry.dart';
import 'package:fluttershare/widgets/median.dart';
import 'package:fluttershare/widgets/median_global.dart';

class Analitycs extends StatefulWidget {
  final String profileId;
  Analitycs({this.profileId});
  @override
  _AnalitycsState createState() {
    return _AnalitycsState();
  }
}

class _AnalitycsState extends State<Analitycs> {
  final String currentUserId = currentUser?.id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff333340),
      body: ListView(
        children: [
          SizedBox(height: 30),
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(left: 20),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Container(
                child: Text(
                  'Local',
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 30),
                  child: Text(
                    "Age",
                    style: TextStyle(fontSize: 25, color: Colors.black),
                  ),
                ),
                AgeChart(profileId: currentUserId)
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 190,
                height: 190,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                ),
                child: Coutries(profileId: currentUserId),
              ),
              Container(
                width: 190,
                height: 190,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                ),
                child: MedianAge(profileId: currentUserId),
              ),
            ],
          ),
          SizedBox(height: 40),
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(left: 70),
                child: Text(
                  'Global',
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Container(
            margin: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 30),
                  child: Text(
                    "Categories",
                    style: TextStyle(fontSize: 25, color: Colors.black),
                  ),
                ),
                CategoryChart(),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 190,
                height: 190,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                ),
                child: CoutriesGlobal(),
              ),
              Container(
                width: 190,
                height: 190,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                ),
                child: MedianAgeGlobal(),
              ),
            ],
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}
