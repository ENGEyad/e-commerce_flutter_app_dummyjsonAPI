// lib/models/post_models.dart
class Post {
  final int id;
  final String title;
  final String body;
  final int userId;
  final List<String> tags;
  final int likes;
  final int dislikes;

  Post({
    required this.id,
    required this.title,
    required this.body,
    required this.userId,
    required this.tags,
    required this.likes,
    required this.dislikes,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    final reactions = json['reactions'] ?? {};
    return Post(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      userId: json['userId'] ?? 0,
      tags: List<String>.from(json['tags'] ?? const []),
      likes: reactions['likes'] ?? 0,
      dislikes: reactions['dislikes'] ?? 0,
    );
  }
}