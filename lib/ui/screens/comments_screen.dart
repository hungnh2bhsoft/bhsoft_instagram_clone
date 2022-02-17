import 'package:bhsoft_instagram_clone/models/models.dart';
import 'package:bhsoft_instagram_clone/providers/user_provider.dart';
import 'package:bhsoft_instagram_clone/resources/firestore_methods.dart';
import 'package:bhsoft_instagram_clone/ui/widgets/widgets.dart';
import 'package:bhsoft_instagram_clone/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({Key? key, required this.post}) : super(key: key);

  final Post post;

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final _commetController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<UserProvider>(context).user!;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Comments",
        ),
        centerTitle: false,
        backgroundColor: kMobileBackgroundColor,
      ),
      body: StreamBuilder<List<Comment>>(
        stream: FirestoreMethods().getPostComments(widget.post.postId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final comment = snapshot.data![index];
                return CommentCard(
                  comment: comment,
                  currentUserId: Provider.of<UserProvider>(context).user!.uid,
                  postId: widget.post.postId,
                );
              },
            );
          }
          return Container();
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                    Provider.of<UserProvider>(context).user!.imageUrl),
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: TextField(
                  controller: _commetController,
                  decoration: const InputDecoration(
                      border: InputBorder.none, hintText: "Add a comment"),
                ),
              ),
              IconButton(
                onPressed: () async {
                  await FirestoreMethods().postComment(
                    widget.post.postId,
                    _commetController.text,
                    currentUser.uid,
                    currentUser.username,
                    currentUser.imageUrl,
                  );
                  _commetController.clear();
                },
                icon: const Icon(Icons.send_rounded),
              )
            ],
          ),
        ),
      ),
    );
  }
}
