import 'package:bhsoft_instagram_clone/models/models.dart';
import 'package:bhsoft_instagram_clone/resources/firestore_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class FeedProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Post>? _posts;

  List<Post>? get posts => _posts;

  FeedProvider() {
    _firestore.collection('posts').snapshots().listen((snapshot) {
      final List<Post> posts = snapshot.docs
          .map(
            (doc) => Post.fromSnap(doc),
          )
          .toList();
      _posts = posts;
      notifyListeners();
    });
  }

  Future<void> likePost(Post post) async {
    await FirestoreMethods().likePost(
      post,
    );
  }

  Future<void> deletePost(Post post) async {
    await FirestoreMethods().deletePost(post);
  }
}
