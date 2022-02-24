import 'package:bhsoft_instagram_clone/providers/profile_provider.dart';
import 'package:bhsoft_instagram_clone/providers/user_provider.dart';
import 'package:bhsoft_instagram_clone/resources/auth_methods.dart';
import 'package:bhsoft_instagram_clone/ui/widgets/follow_button.dart';
import 'package:bhsoft_instagram_clone/utils/colors.dart';
import 'package:bhsoft_instagram_clone/utils/global_variables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  final String uid;
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ChangeNotifierProvider(
      create: (_) =>
          ProfileProvider(uid: Provider.of<UserProvider>(context).user!.uid)
            ..fetchUserData(),
      child: Consumer<ProfileProvider>(
        builder: (context, profileProvider, _) => profileProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : Scaffold(
                backgroundColor:
                    size.width <= kMobileMaxWidth ? null : kWebBackgroundColor,
                appBar: AppBar(
                  title: Text(profileProvider.data!["username"]),
                ),
                body: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Column(
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(profileProvider
                                    .data!["imageUrl"] as String),
                                radius: 40,
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    buildStatColumn("Followers",
                                        profileProvider.followers!.length),
                                    buildStatColumn("Following",
                                        profileProvider.following!.length),
                                    buildStatColumn(
                                        "Posts", profileProvider.posts!.length),
                                  ],
                                ),
                                widget.uid ==
                                        FirebaseAuth.instance.currentUser!.uid
                                    ? FollowButton(
                                        backgroundColor: kMobileBackgroundColor,
                                        borderColor: kSecondaryColor,
                                        text: "Sign out",
                                        textColor: kPrimaryColor,
                                        function: AuthMethods().logOut,
                                      )
                                    : FollowButton(
                                        backgroundColor:
                                            profileProvider.isFollowing
                                                ? kMobileBackgroundColor
                                                : kBlueColor,
                                        borderColor: kSecondaryColor,
                                        text: profileProvider.isFollowing
                                            ? "Unfollow"
                                            : "Follow",
                                        textColor: kPrimaryColor,
                                        function: profileProvider.toggleFollow),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(profileProvider.data!["bio"] as String),
                    ),
                    const Divider(
                      color: kSecondaryColor,
                    ),
                    GridView.count(
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                      crossAxisCount: 4,
                      shrinkWrap: true,
                      children: [
                        ...profileProvider.posts!.map((e) => Image.network(
                              e["postUrl"],
                              fit: BoxFit.cover,
                            )),
                      ],
                    )
                  ],
                ),
              ),
      ),
    );
  }

  Column buildStatColumn(String label, int num) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "$num",
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            color: kSecondaryColor,
            fontWeight: FontWeight.w400,
          ),
        )
      ],
    );
  }
}
