import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/pages/home.dart';

import 'package:fluttershare/widgets/post.dart';
import 'package:fluttershare/widgets/progress.dart';

class PostScreen extends StatelessWidget {
  final String userId;
  final String postId;
  final String ownerId;
  final String currentUserId = currentUser?.id;

  PostScreen({this.ownerId, this.userId, this.postId});

  handleDeletePost(BuildContext parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text("Remove this post?"),
            children: <Widget>[
              SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context);
                    deletePost();
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  )),
              SimpleDialogOption(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel')),
            ],
          );
        });
  }

  // Note: To delete post, ownerId and currentUserId must be equal, so they can be used interchangeably
  deletePost() async {
    // delete post itself
    postsRef
        .document(ownerId)
        .collection('userPosts')
        .document(postId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    // delete uploaded image for thep ost
    storageRef.child("post_$postId.jpg").delete();
    // then delete all activity feed notifications
    QuerySnapshot activityFeedSnapshot = await activityFeedRef
        .document(ownerId)
        .collection("feedItems")
        .where('postId', isEqualTo: postId)
        .getDocuments();
    activityFeedSnapshot.documents.forEach((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    // then delete all comments
    QuerySnapshot commentsSnapshot = await commentsRef
        .document(postId)
        .collection('comments')
        .getDocuments();
    commentsSnapshot.documents.forEach((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    buildProfileNav() {
      // viewing your own profile - should show edit profile button
      bool isProfileOwner = currentUserId == ownerId;
      if (isProfileOwner) {
        return Positioned(
          top: 15.0,
          right: 10.0,
          child: InkResponse(
            onTap: () => handleDeletePost(context),
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black12),
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                      color: Color(0xFF3C4858).withOpacity(.5),
                      offset: Offset(1.0, 10.0),
                      blurRadius: 10.0),
                ],
              ),
              child: Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ),
          ),
        );
      } else {
        return Positioned(
          child: Icon(null),
        );
      }
    }

    return FutureBuilder(
      future: postsRef
          .document(userId)
          .collection('userPosts')
          .document(postId)
          .get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        Post post = Post.fromDocument(snapshot.data);
        return Scaffold(
          body: Stack(
            children: <Widget>[
              ListView(
                physics: ClampingScrollPhysics(),
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        height: 240.0,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          image: DecorationImage(
                              colorFilter: ColorFilter.mode(
                                  Color(0xFF3C4858), BlendMode.lighten),
                              image: CachedNetworkImageProvider(post.mediaUrl),
                              fit: BoxFit.cover),
                        ),
                      ),
                      Positioned(
                        top: 100.0,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            post.title,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                letterSpacing: 0.8,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 200.0,
                        width: MediaQuery.of(context).size.width,
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(100.0),
                                  topLeft: Radius.circular(100.0)),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFF3C4858).withOpacity(.4),
                                  offset: Offset(0.0, -8),
                                  blurRadius: 6,
                                )
                              ]),
                        ),
                      ),
                      Positioned(
                        top: 15.0,
                        left: 10.0,
                        child: InkResponse(
                          onTap: () {
                            if (Navigator.of(context).canPop()) {
                              Navigator.of(context).pop();
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.black12),
                              borderRadius: BorderRadius.circular(100),
                              boxShadow: [
                                BoxShadow(
                                    color: Color(0xFF3C4858).withOpacity(.5),
                                    offset: Offset(1.0, 10.0),
                                    blurRadius: 10.0),
                              ],
                            ),
                            child: Icon(Icons.arrow_downward,
                                color: Color(0xFF3C4858)),
                          ),
                        ),
                      ),
                      buildProfileNav(),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 50.0),
                    child: Text(
                      post.content,
                      style: TextStyle(
                          fontSize: 16.0,
                          height: 1.2,
                          color: Color(0xFF3C4858).withOpacity(0.8)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
