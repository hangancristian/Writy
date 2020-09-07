import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/models/user.dart';
import 'package:fluttershare/pages/activity_feed.dart';
import 'package:fluttershare/pages/home.dart';
import 'package:fluttershare/widgets/progress.dart';

import 'constant.dart';

class Discover extends StatefulWidget {
  final String query;

  Discover({this.query});
  @override
  _DiscoverState createState() => _DiscoverState();
}

class _DiscoverState extends State<Discover> {
  bool isAuth = false;
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
          UserCard searchResult = UserCard(user);
          searchResults.add(searchResult);
        });
        searchResults.shuffle();
        if (searchResults.length > 5) {
          for (var i = 0; i < 5; i++) {
            finalsearchResults.add(searchResults[i]);
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
