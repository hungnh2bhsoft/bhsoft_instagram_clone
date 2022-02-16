import 'package:bhsoft_instagram_clone/models/models.dart';
import 'package:bhsoft_instagram_clone/providers/user_provider.dart';
import 'package:bhsoft_instagram_clone/resources/firestore_methods.dart';
import 'package:bhsoft_instagram_clone/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CommentCard extends StatefulWidget {
  const CommentCard(
      {Key? key,
      required this.comment,
      required this.currentUserId,
      required this.postId})
      : super(key: key);

  final Comment comment;
  final String postId;
  final String currentUserId;

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  String _formatDate(DateTime dateTime) {
    return DateFormat("dd/MM/yyyy").format(dateTime).toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 18,
        horizontal: 16,
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(widget.comment.profileImage),
            radius: 16,
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: widget.comment.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: " ${_formatDate(widget.comment.datePublished)}",
                      style: TextStyle(color: kSecondaryColor),
                    ),
                  ]),
                ),
                SizedBox(height: 8),
                Text(widget.comment.content),
              ],
            ),
          ),
          InkWell(
            onTap: () async {
              final currentUserId =
                  Provider.of<UserProvider>(context, listen: false).user!.uid;
              await FirestoreMethods().toggleLikeComment(widget.comment.likes,
                  widget.postId, widget.comment.id, currentUserId);
            },
            child: Column(
              children: [
                Icon(widget.comment.likes.contains(widget.currentUserId)
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded),
                Text(widget.comment.likes.length.toString()),
              ],
            ),
          )
        ],
      ),
    );
  }
}
