import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/models/data.dart';
import 'package:fluttershare/pages/home.dart';
import 'package:fluttershare/widgets/progress.dart';
import 'package:stats/stats.dart';

class CoutriesGlobal extends StatefulWidget {
  CoutriesGlobal();

  @override
  _CoutriesGlobalState createState() => _CoutriesGlobalState();
}

class _CoutriesGlobalState extends State<CoutriesGlobal> {
  Future<QuerySnapshot> searchResultsFuture;
  int med = 0;
  int val = 0;
  String c = "";
  var map = Map();
  void initState() {
    super.initState();

    handleSearch();
  }

  handleSearch() {
    Future<QuerySnapshot> users = usersRef.getDocuments();

    setState(() {
      searchResultsFuture = users;
    });
  }

  buildSearchResults() {
    return FutureBuilder(
      future: searchResultsFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        List<String> searchResults = [];
        snapshot.data.documents.forEach((doc) {
          Data user = Data.fromDocument(doc);

          searchResults.add(user.country);
        });
        snapshot.data.documents.map((doc) {
          Data user = Data.fromDocument(doc);
          if (!map.containsKey(user.country)) {
            map[user.country] = 1;
          } else {
            map[user.country] += 1;
          }
        }).toList();

        var sortedKeys = map.keys.toList(growable: false)
          ..sort((k1, k2) => map[k2].compareTo(map[k1]));
        LinkedHashMap sortedMap = new LinkedHashMap.fromIterable(sortedKeys,
            key: (k) => k, value: (k) => map[k]);
        print(sortedMap);

        var _list = sortedMap.keys.toList();

        return Column(
          children: [
            Center(
              child: Text(
                _list[0].toString(),
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
            ),
            Center(
              child: Text(
                _list[1].toString(),
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
            ),
            Center(
              child: Text(
                _list[2].toString(),
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20),
        Center(
          child: Text(
            "Most users are from:",
            style: TextStyle(fontSize: 20),
          ),
        ),
        Container(
          height: 110,
          child: buildSearchResults(),
        ),
      ],
    );
  }
}
