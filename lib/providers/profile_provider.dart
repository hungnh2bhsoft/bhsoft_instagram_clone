import 'package:bhsoft_instagram_clone/resources/firestore_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfileProvider extends ChangeNotifier {
  String? error;
  bool isLoading = true;
  bool isFollowing = false;
  String uid;
  List<dynamic>? followers;
  List<dynamic>? following;
  List<dynamic>? posts;
  Map<String, dynamic>? data;

  ProfileProvider({required this.uid});

  void fetchUserData() async {
    isLoading = true;
    notifyListeners();
    final snapshot =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();
    final postSnapshot = await FirebaseFirestore.instance
        .collection("posts")
        .where("uid", isEqualTo: uid)
        .get();
    data = snapshot.data()!;
    posts = postSnapshot.docs.map((e) => e.data()).toList();
    isFollowing = (data!["followers"] as List).contains(uid);
    followers = data!["followers"] ?? [];
    following = data!["following"] ?? [];
    isLoading = false;
    notifyListeners();
  }

  Future<void> toggleFollow() async {
    await FirestoreMethods().toggleFollowing(uid, isFollowing);
  }
}
