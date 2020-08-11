import 'package:flutter/material.dart';
import 'package:fluttershare/pages/post_screen.dart';

import 'package:fluttershare/widgets/post.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PostTile extends StatelessWidget {
  final Post post;

  PostTile(this.post);

  showPost(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostScreen(
          ownerId: post.ownerId,
          postId: post.postId,
          userId: post.ownerId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showPost(context),
      child: Container(
        margin: EdgeInsets.only(bottom: 15.0, top: 15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            LimitedBox(
              maxWidth: MediaQuery.of(context).size.width * .9,
              maxHeight: 280,
              child: Stack(
                children: <Widget>[
                  Container(
                    width: 200,
                    height: 250,
                    margin: EdgeInsets.only(left: 100),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          colorFilter: ColorFilter.mode(
                              Color(0xFF3C4858), BlendMode.lighten),
                          image: CachedNetworkImageProvider(post.mediaUrl),
                          fit: BoxFit.cover),
                      boxShadow: [
                        BoxShadow(
                            color: Color(0xFF3C4858).withOpacity(.4),
                            offset: Offset(5.0, 5.0),
                            blurRadius: 10.0),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 0.0,
                    top: 30.0,
                    //the center = (height of image container/2) - (height of this container/2)
                    child: Container(
                      width: 180,
                      height: 190,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black12,
                                offset: Offset(0.0, 0.0),
                                blurRadius: 10.0),
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: <Widget>[
                            Text(
                              post.username,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.event_note,
                                        size: 18.0,
                                        color: Color(0xFF3C4858),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(post.title,
                                            overflow: TextOverflow.fade),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Icon(
                                        Icons.arrow_forward,
                                        size: 26.0,
                                        color: Colors.blueGrey,
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
