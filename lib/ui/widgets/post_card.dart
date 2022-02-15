import 'dart:developer';

import 'package:bhsoft_instagram_clone/resources/firestore_methods.dart';
import 'package:bhsoft_instagram_clone/ui/widgets/like_animation.dart';
import 'package:bhsoft_instagram_clone/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PostCard extends StatefulWidget {
  const PostCard({Key? key, required this.data}) : super(key: key);

  final Map<String, dynamic> data;

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool _isAnimating = false;

  String convertTime(Timestamp timestamp) {
    final time = widget.data["datePublished"] as Timestamp;
    final DateFormat dateFormat = DateFormat("dd/MM/yyyy");
    return dateFormat.format(time.toDate()).toString();
  }

  bool userLiked(List likes) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return likes.contains(uid);
  }

  Future<ImageProvider> getProfileImage() async {
    final url =
        await FirestoreMethods().getUserProfileImage(widget.data["uid"]);
    if (url.isEmpty) {
      return const AssetImage("assets/user_dummy.jpeg");
    } else {
      return NetworkImage(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 4,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(widget.data["profImage"]),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${widget.data["username"]}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          child: ListView(
                            shrinkWrap: true,
                            children: ["Delete"]
                                .map(
                                  (e) => InkWell(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                        horizontal: 16,
                                      ),
                                      child: Text(e),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        );
                      },
                    );
                  },
                  icon: const Icon(
                    Icons.more_vert,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height / 3,
            child: Image.network(widget.data["postUrl"] as String),
          ),
          Row(
            children: [
              LikeAnimation(
                isAnimating: _isAnimating,
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      _isAnimating = true;
                    });
                  },
                  icon: Icon(userLiked(widget.data["likes"])
                      ? Icons.favorite
                      : Icons.favorite_border),
                ),
                onEnd: () async {
                  setState(() {
                    _isAnimating = false;
                  });
                  await FirestoreMethods().likePost(
                    widget.data['likes'],
                    widget.data['postId'],
                    FirebaseAuth.instance.currentUser!.uid,
                  );
                },
              ),
              IconButton(
                onPressed: () {
                  // TODO: Handle togglig comment
                },
                icon: const Icon(Icons.comment_outlined),
              ),
              IconButton(
                onPressed: () {
                  // TODO: Handle sending message
                },
                icon: const Icon(Icons.send_outlined),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.bookmark_outline_rounded),
              ),
            ],
          ),

          // Description and comments
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${widget.data["likes"].length} likes",
                  style: Theme.of(context).textTheme.bodyText2,
                  textAlign: TextAlign.start,
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                    top: 8,
                  ),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(color: kprimaryColor),
                      children: [
                        TextSpan(
                          text: "${widget.data["username"]} ",
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        TextSpan(text: " ${widget.data["description"]}"),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    convertTime(widget.data["datePublished"]),
                    style: const TextStyle(
                      fontSize: 12,
                      color: kSecondaryColor,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    // TODO: show all comments
                  },
                  child: Container(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      "View all${(widget.data["comments"] as List).isNotEmpty ? " " + widget.data["comments"].length : ""} comments",
                      style: const TextStyle(
                        fontSize: 16,
                        color: kBlueColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
