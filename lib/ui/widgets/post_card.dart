import 'package:bhsoft_instagram_clone/models/models.dart';
import 'package:bhsoft_instagram_clone/ui/screens/screens.dart';
import 'package:bhsoft_instagram_clone/ui/widgets/widgets.dart';
import 'package:bhsoft_instagram_clone/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PostCard extends StatefulWidget {
  const PostCard(
      {Key? key,
      required this.post,
      required this.onLiked,
      required this.onDeleted})
      : super(key: key);

  final Post post;
  final Function(Post) onLiked;
  final void Function(Post) onDeleted;

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool _isAnimating = false;

  String convertTime(DateTime dateTime) {
    final DateFormat dateFormat = DateFormat("dd/MM/yyyy");
    return dateFormat.format(dateTime).toString();
  }

  bool userLiked(List likes) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return likes.contains(uid);
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
                  backgroundImage: NetworkImage(widget.post.profImage),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.post.username,
                          style: const TextStyle(
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
                        final uid = FirebaseAuth.instance.currentUser!.uid;
                        return Dialog(
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              if (uid == widget.post.uid)
                                SimpleDialogOption(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0, horizontal: 12.0),
                                  child: const Text("Delete"),
                                  onPressed: () {
                                    widget.onDeleted(widget.post);
                                    Navigator.of(context).pop();
                                  },
                                )
                            ],
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
            height: 300,
            child: Image.network(
              widget.post.postUrl,
              fit: BoxFit.cover,
            ),
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
                  icon: Icon(userLiked(widget.post.likes!)
                      ? Icons.favorite
                      : Icons.favorite_border),
                ),
                onEnd: () async {
                  setState(() {
                    _isAnimating = false;
                  });
                  widget.onLiked(widget.post);
                },
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                    return CommentScreen(post: widget.post);
                  }));
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
                icon: const Icon(Icons.bookmark_outline_rounded),
              ),
            ],
          ),
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
                  "${widget.post.likes.length} like${widget.post.likes.length <= 1 ? "" : "s"}",
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
                      style: const TextStyle(color: kPrimaryColor),
                      children: [
                        TextSpan(
                          text: widget.post.username,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        TextSpan(text: widget.post.description),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    convertTime(widget.post.datePublished),
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
                    child: const Text(
                      "View all comments",
                      style: TextStyle(
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
