import 'dart:developer';

import 'package:bhsoft_instagram_clone/resources/auth_methods.dart';
import 'package:bhsoft_instagram_clone/resources/firestore_methods.dart';
import 'package:bhsoft_instagram_clone/ui/widgets/follow_button.dart';
import 'package:bhsoft_instagram_clone/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  final String uid;
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isLoading = true;
  late bool isFollowing = false;
  late Map<String, dynamic> data;
  late int followers;
  late int following;
  late List<dynamic> posts;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void fetchUserData() async {
    final snapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.uid)
        .get();
    final postSnapshot = await FirebaseFirestore.instance
        .collection("posts")
        .where("uid", isEqualTo: widget.uid)
        .get();

    setState(() {
      data = snapshot.data()!;
      posts = postSnapshot.docs.map((e) => e.data()).toList();
      isFollowing = (data["followers"] as List)
          .contains(FirebaseAuth.instance.currentUser!.uid);
      followers = data["followers"]?.length ?? 0;
      following = data["following"]?.length ?? 0;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kMobileBackgroundColor,
        title: const Text("username"),
        actions: [
          IconButton(
            onPressed: () async {
              await AuthMethods().logOut();
            },
            icon: const Icon(
              Icons.logout_outlined,
            ),
          )
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          CircleAvatar(
                            backgroundImage:
                                NetworkImage(data["imageUrl"] as String),
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                buildStatColumn("Followers", followers),
                                buildStatColumn("Following", following),
                                buildStatColumn("Posts", posts.length),
                              ],
                            ),
                            widget.uid == FirebaseAuth.instance.currentUser!.uid
                                ? FollowButton(
                                    backgroundColor: kMobileBackgroundColor,
                                    borderColor: kSecondaryColor,
                                    text: "Sign out",
                                    textColor: kprimaryColor,
                                    function: () async {
                                      log(
                                          FirebaseAuth.instance.currentUser
                                              .toString(),
                                          name: "Before logout");
                                      await AuthMethods().logOut();
                                    },
                                  )
                                : FollowButton(
                                    backgroundColor: isFollowing
                                        ? kMobileBackgroundColor
                                        : kBlueColor,
                                    borderColor: kSecondaryColor,
                                    text: isFollowing ? "Unfollow" : "Follow",
                                    textColor: kprimaryColor,
                                    function: () async {
                                      final follow = await FirestoreMethods()
                                          .toggleFollowing(
                                              widget.uid, isFollowing);
                                      setState(() {
                                        followers += follow ? 1 : -1;
                                        isFollowing = follow;
                                      });
                                    },
                                  ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(data["bio"] as String),
                ),
                Divider(
                  color: kSecondaryColor,
                ),
                GridView.count(
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                  crossAxisCount: 4,
                  shrinkWrap: true,
                  children: [
                    ...posts.map((e) => Image.network(
                          e["postUrl"],
                          fit: BoxFit.cover,
                        )),
                  ],
                )
              ],
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
