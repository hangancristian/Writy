import 'dart:collection';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/models/user.dart';
import 'package:fluttershare/pages/activity_feed.dart';
import 'package:fluttershare/pages/home.dart';
import 'package:fluttershare/widgets/progress.dart';

import 'constant.dart';

class DiscoverTop extends StatefulWidget {
  final String query;

  DiscoverTop({this.query});
  @override
  _DiscoverTopState createState() => _DiscoverTopState();
}

class _DiscoverTopState extends State<DiscoverTop> {
  bool isAuth = false;
  var map = Map();
  int i = 0;
  Future<QuerySnapshot> searchResultsFuture;
  void initState() {
    super.initState();

    handleSearch(widget.query);
  }

  handleSearch(String query) {
    Future<QuerySnapshot> users =
        usersRef.where("category", isEqualTo: query).getDocuments();
    setState(() {
      searchResultsFuture = users;
    });
  }

  Future getFollowers(profileId) async {
    QuerySnapshot snapshot2 = await followersRef
        .document(profileId)
        .collection('userFollowers')
        .getDocuments();

    var nr = snapshot2.documents.length;
    return nr;
  }

  buildSearchResults() {
    return FutureBuilder(
      future: searchResultsFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        List<UserCard> searchResults = [];
        List<UserCard> finalsearchResults = [];
        snapshot.data.documents.forEach((doc) {
          User user = User.fromDocument(doc);
          print(getFollowers(user.id));
          if (!map.containsKey(user.displayName)) {
            map[user.displayName] = getFollowers(user.id);
          }
        }).toList();
        snapshot.data.documents.forEach((doc) {
          User user = User.fromDocument(doc);
          UserCard searchResult = UserCard(user);
          searchResults.add(searchResult);
        });

        var sortedKeys = map.keys.toList(growable: false)
          ..sort((k1, k2) => map[k2].compareTo(map[k1]));
        LinkedHashMap sortedMap = new LinkedHashMap.fromIterable(sortedKeys,
            key: (k) => k, value: (k) => map[k]);
        print(sortedMap);

        var _list = sortedMap.keys.toList();

        if (searchResults.length > 5) {
          while (i < 5) {
            searchResults.forEach((element) {
              if (element.user.displayName == _list[i]) {
                finalsearchResults.add(element);
                i++;
              }
            });
          }
        } else {
          finalsearchResults = searchResults;
        }

        if (finalsearchResults.length > 0) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: finalsearchResults,
            ),
          );
        } else {
          return Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 10),
                  blurRadius: 20,
                  color: kActiveShadowColor,
                ),
              ],
            ),
            child: ConstrainedBox(
              constraints: new BoxConstraints(
                minWidth: 130.0,
              ),
              child: Column(
                children: <Widget>[
                  Image.asset("assets/images/headache.png", height: 90),
                  SizedBox(height: 10),
                  Text(
                    'No users',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 15, bottom: 20),
      child: buildSearchResults(),
    );
  }
}

class UserCard extends StatelessWidget {
  final User user;

  UserCard(this.user);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showProfile(context, profileId: user.id),
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 10),
              blurRadius: 20,
              color: kActiveShadowColor,
            ),
          ],
        ),
        child: ConstrainedBox(
          constraints: new BoxConstraints(
            minWidth: 130.0,
          ),
          child: Column(
            children: <Widget>[
              CircleAvatar(
                radius: 40.0,
                backgroundColor: Colors.grey,
                backgroundImage: CachedNetworkImageProvider(user.photoUrl),
              ),
              SizedBox(height: 10),
              Text(
                user.displayName,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
