class User {
  final String uid;
  final String email;
  final String imageUrl;
  final String username;
  final String bio;
  final List<String> followers;
  final List<String> following;

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
}
