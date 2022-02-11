import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String email;
  final String imageUrl;
  final String username;
  final String bio;
  final List<dynamic> followers;
  final List<dynamic> following;

  const User({
    required this.uid,
    required this.email,
    required this.imageUrl,
    required this.username,
    required this.bio,
    required this.followers,
    required this.following,
  });

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "username": username,
        "email": email,
        "bio": bio,
        "followers": followers,
        "following": following,
        "imageUrl": imageUrl,
      };

  factory User.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return User(
      uid: snapshot.id,
      username: data["username"],
      email: data["email"],
      bio: data["bio"],
      followers: data["followers"] as List,
      following: data["following"] as List,
      imageUrl: data["imageUrl"],
    );
  }
}
