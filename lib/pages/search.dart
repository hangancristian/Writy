import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/models/user.dart';
import 'package:fluttershare/pages/activity_feed.dart';
import 'package:fluttershare/pages/home.dart';
import 'package:fluttershare/widgets/discover.dart';
import 'package:fluttershare/widgets/discover_top.dart';
import 'package:fluttershare/widgets/header.dart';
import 'package:fluttershare/widgets/progress.dart';
import 'package:fluttershare/widgets/constant.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController searchController = TextEditingController();
  final controller = ScrollController();
  Future<QuerySnapshot> searchResultsFuture;
  String _query;

  double offset = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void onScroll() {
    setState(() {});
  }

  handleSearch(String query) {
    Future<QuerySnapshot> users = usersRef.getDocuments();
    setState(() {
      searchResultsFuture = users;
      _query = query;
    });
  }

  clearSearch() {
    searchController.clear();
  }

  AppBar buildSearchField() {
    return AppBar(
      backgroundColor: Colors.white,
      title: TextFormField(
        controller: searchController,
        decoration: InputDecoration(
          fillColor: Colors.white,
          hintText: "Search for a user...",
          filled: true,
          prefixIcon: Icon(
            Icons.account_box,
            size: 28.0,
          ),
          suffixIcon: IconButton(
            icon: Icon(Icons.clear),
            onPressed: clearSearch,
          ),
        ),
        onFieldSubmitted: handleSearch,
      ),
    );
  }

  Container buildNoContent() {
    return Container(
      child: SingleChildScrollView(
        controller: controller,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            MyHeader(
              textTop: "Discover",
              offset: offset,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Tech",
                    style: kTitleTextstyle,
                  ),
                  SizedBox(height: 20),
                  Discover(query: "Tech"),
                  SizedBox(height: 20),
                  Text(
                    "Travel",
                    style: kTitleTextstyle,
                  ),
                  SizedBox(height: 20),
                  Discover(query: "Travel"),
                  SizedBox(height: 20),
                  Text(
                    "Food",
                    style: kTitleTextstyle,
                  ),
                  SizedBox(height: 20),
                  Discover(query: "Food"),
                  SizedBox(height: 20),
                  Text(
                    "Politics",
                    style: kTitleTextstyle,
                  ),
                  SizedBox(height: 20),
                  Discover(query: "Politics"),
                  SizedBox(height: 20),
                  Text(
                    "Others",
                    style: kTitleTextstyle,
                  ),
                  SizedBox(height: 20),
                  Discover(query: "Others"),
                  SizedBox(height: 20),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  buildSearchResults() {
    return FutureBuilder(
      future: searchResultsFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        List<UserCard> searchResults = [];
        List<String> verify = [];
        snapshot.data.documents.forEach((doc) {
          User user = User.fromDocument(doc);
          verify = user.displayName.toUpperCase().split(" ");
          if (verify.contains(_query.toUpperCase())) {
            UserCard searchResult = UserCard(user);
            searchResults.add(searchResult);
          }
        });
        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 30),
              Wrap(
                runSpacing: 10,
                children: searchResults,
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildSearchField(),
      body:
          searchResultsFuture == null ? buildNoContent() : buildSearchResults(),
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
        margin: EdgeInsets.only(right: 10, left: 20),
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
