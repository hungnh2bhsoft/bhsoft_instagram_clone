import 'package:bhsoft_instagram_clone/ui/screens/screens.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

const kMobileMaxWidth = 600;

final homePageItems = [
  const FeedsScreen(),
  const SearchScreen(),
  const AddPostScreen(),
  const Text("Favorite Scren"),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  )
];
