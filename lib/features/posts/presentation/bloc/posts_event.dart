part of 'posts_bloc.dart';

/// Base class for all post events
sealed class PostsEvent extends Equatable {
  const PostsEvent();

  @override
  List<Object?> get props => [];
}

/// Event to fetch all posts
class GetPostsEvent extends PostsEvent {
  const GetPostsEvent();
}

/// Event to fetch a single post by ID
class GetPostByIdEvent extends PostsEvent {
  final int id;

  const GetPostByIdEvent(this.id);

  @override
  List<Object?> get props => [id];
}

/// Event to refresh posts
class RefreshPostsEvent extends PostsEvent {
  const RefreshPostsEvent();
}

/// Event to clear selected post
class ClearSelectedPostEvent extends PostsEvent {
  const ClearSelectedPostEvent();
}

/// Event to reset error state
class ResetErrorEvent extends PostsEvent {
  const ResetErrorEvent();
}
