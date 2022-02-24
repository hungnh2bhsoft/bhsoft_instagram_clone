import 'package:bhsoft_instagram_clone/providers/feeds_provider.dart';
import 'package:bhsoft_instagram_clone/ui/widgets/widgets.dart';
import 'package:bhsoft_instagram_clone/utils/colors.dart';
import 'package:bhsoft_instagram_clone/utils/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class FeedsScreen extends StatelessWidget {
  const FeedsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor:
          size.width <= kMobileMaxWidth ? null : kWebBackgroundColor,
      appBar: size.width <= kMobileMaxWidth
          ? AppBar(
              backgroundColor: kMobileBackgroundColor,
              title: SvgPicture.asset(
                "assets/ic_instagram.svg",
                color: kPrimaryColor,
                height: 32,
              ),
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.messenger_outline_rounded,
                    color: kPrimaryColor,
                  ),
                  onPressed: () {},
                ),
              ],
            )
          : null,
      body: Consumer<FeedProvider>(
        builder: (context, value, _) {
          final posts = value.posts;
          if (posts == null) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          if (posts.isEmpty) {
            return const Center(
              child: Text("No post to show"),
            );
          }
          return ListView.builder(
            itemBuilder: (_, index) {
              return PostCard(
                post: posts[index],
                onLiked: value.likePost,
                onDeleted: value.deletePost,
              );
            },
            itemCount: posts.length,
          );
        },
      ),
    );
  }
}
