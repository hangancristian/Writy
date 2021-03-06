import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/models/data.dart';
import 'package:fluttershare/pages/home.dart';
import 'package:fluttershare/widgets/progress.dart';
import 'package:stats/stats.dart';

class MedianAgeGlobal extends StatefulWidget {
  MedianAgeGlobal();

  @override
  _MedianAgeGlobalState createState() => _MedianAgeGlobalState();
}

class _MedianAgeGlobalState extends State<MedianAgeGlobal> {
  Future<QuerySnapshot> searchResultsFuture;
  int med = 0;
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
        List<int> searchResults = [];
        snapshot.data.documents.forEach((doc) {
          Data user = Data.fromDocument(doc);

          searchResults.add(user.age);
        });
        final stats = Stats.fromData(searchResults);
        if (searchResults.length == 1) {
          return Center(
            child: Text(
              searchResults[0].toString(),
              style: TextStyle(
                fontSize: 50,
                color: Colors.black,
              ),
            ),
          );
        } else {
          return Center(
            child: Text(
              stats.median.toString(),
              style: TextStyle(
                fontSize: 50,
                color: Colors.black,
              ),
            ),
          );
        }
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
            "Median age",
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
