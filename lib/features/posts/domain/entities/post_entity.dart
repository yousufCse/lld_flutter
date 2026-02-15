import 'package:equatable/equatable.dart';

/// Post entity representing a post in the domain layer
/// This is the core business object used throughout the application
class PostEntity extends Equatable {
  final int id;
  final int userId;
  final String title;
  final String body;

  const PostEntity({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
  });

  /// Create an empty post
  static const empty = PostEntity(
    id: 0,
    userId: 0,
    title: '',
    body: '',
  );

  /// Check if post is empty
  bool get isEmpty => this == empty;

  /// Check if post is not empty
  bool get isNotEmpty => this != empty;

  /// Get a short preview of the body (first 100 characters)
  String get bodyPreview {
    if (body.length <= 100) return body;
    return '${body.substring(0, 100)}...';
  }

  /// Copy with method for creating modified copies
  PostEntity copyWith({
    int? id,
    int? userId,
    String? title,
    String? body,
  }) {
    return PostEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      body: body ?? this.body,
    );
  }

  @override
  List<Object?> get props => [id, userId, title, body];

  @override
  String toString() => 'PostEntity(id: $id, title: $title)';
}
