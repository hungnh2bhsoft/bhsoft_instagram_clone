import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
  final String uid;
  final String username;
  final likes;
  final comments;
  final String postId;
  final DateTime datePublished;
  final String postUrl;
  final String profImage;

  const Post({
    required this.description,
    required this.uid,
    required this.username,
    required this.likes,
    required this.comments,
    required this.postId,
    required this.datePublished,
    required this.postUrl,
    required this.profImage,
  });

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
        description: snapshot["description"],
        uid: snapshot["uid"],
        likes: snapshot["likes"],
        comments: snapshot["comments"],
        postId: snapshot["postId"],
        datePublished: (snapshot["datePublished"] as Timestamp).toDate(),
        username: snapshot["username"],
        postUrl: snapshot['postUrl'],
        profImage: snapshot['profImage']);
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      description: json['description'],
      uid: json['uid'],
      likes: json['likes'],
      comments: json['comments'],
      postId: json['postId'],
      datePublished: (json['datePublished'] as Timestamp).toDate(),
      username: json['username'],
      postUrl: json['postUrl'],
      profImage: json['profImage'],
    );
  }

  Map<String, dynamic> toJson() => {
        "description": description,
        "uid": uid,
        "likes": likes,
        "username": username,
        "postId": postId,
        "datePublished": datePublished,
        'postUrl': postUrl,
        'profImage': profImage
      };
}
