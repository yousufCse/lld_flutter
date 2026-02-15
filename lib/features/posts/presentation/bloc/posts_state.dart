part of 'posts_bloc.dart';

/// Enum to represent the status of the posts state
enum PostsStatus {
  initial,
  loading,
  success,
  failure,
}

/// Extension for PostsStatus to add helper getters
extension PostsStatusExtension on PostsStatus {
  bool get isInitial => this == PostsStatus.initial;
  bool get isLoading => this == PostsStatus.loading;
  bool get isSuccess => this == PostsStatus.success;
  bool get isFailure => this == PostsStatus.failure;
}

/// State class for posts using Freezed
@freezed
class PostsState with _$PostsState {
  const PostsState._();

  const factory PostsState({
    @Default(PostsStatus.initial) PostsStatus status,
    @Default([]) List<PostEntity> posts,
    PostEntity? selectedPost,
    String? errorMessage,
    @Default(false) bool isRefreshing,
    @Default(false) bool isLoadingDetails,
  }) = _PostsState;

  /// Check if there are any posts
  bool get hasPosts => posts.isNotEmpty;

  /// Check if there's an error
  bool get hasError => errorMessage != null;

  /// Initial state factory
  factory PostsState.initial() => const PostsState();
}
