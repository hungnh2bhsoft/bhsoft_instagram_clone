import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String content;
  final String profileImage;
  final String name;
  final String id;
  final String uid;
  final List likes;
  final DateTime datePublished;

  const Comment({
    required this.id,
    required this.content,
    required this.profileImage,
    required this.name,
    required this.uid,
    required this.likes,
    required this.datePublished,
  });

  factory Comment.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return Comment(
        id: snapshot.id,
        content: data['content'],
        profileImage: data['profileImage'] as String,
        name: data['name'] as String,
        uid: data['uid'] as String,
        likes: data['likes'] as List,
        datePublished: (data['datePublished'] as Timestamp).toDate());
  }
}
