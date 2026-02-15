import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/usecases/get_post_by_id.dart';
import '../../domain/usecases/get_posts.dart';

part 'posts_event.dart';
part 'posts_state.dart';
part 'posts_bloc.freezed.dart';

/// BLoC for managing posts state
class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final GetPosts _getPosts;
  final GetPostById _getPostById;

  PostsBloc({
    required GetPosts getPosts,
    required GetPostById getPostById,
  })  : _getPosts = getPosts,
        _getPostById = getPostById,
        super(PostsState.initial()) {
    on<GetPostsEvent>(_onGetPosts);
    on<GetPostByIdEvent>(_onGetPostById);
    on<RefreshPostsEvent>(_onRefreshPosts);
    on<ClearSelectedPostEvent>(_onClearSelectedPost);
    on<ResetErrorEvent>(_onResetError);
  }

  /// Handle GetPostsEvent
  Future<void> _onGetPosts(
    GetPostsEvent event,
    Emitter<PostsState> emit,
  ) async {
    emit(state.copyWith(
      status: PostsStatus.loading,
      errorMessage: null,
    ));

    final result = await _getPosts(const NoParams());

    result.fold(
      (failure) => emit(state.copyWith(
        status: PostsStatus.failure,
        errorMessage: failure.message,
      )),
      (posts) => emit(state.copyWith(
        status: PostsStatus.success,
        posts: posts,
      )),
    );
  }

  /// Handle GetPostByIdEvent
  Future<void> _onGetPostById(
    GetPostByIdEvent event,
    Emitter<PostsState> emit,
  ) async {
    emit(state.copyWith(
      isLoadingDetails: true,
      errorMessage: null,
    ));

    final result = await _getPostById(GetPostByIdParams(id: event.id));

    result.fold(
      (failure) => emit(state.copyWith(
        isLoadingDetails: false,
        errorMessage: failure.message,
      )),
      (post) => emit(state.copyWith(
        isLoadingDetails: false,
        selectedPost: post,
      )),
    );
  }

  /// Handle RefreshPostsEvent
  Future<void> _onRefreshPosts(
    RefreshPostsEvent event,
    Emitter<PostsState> emit,
  ) async {
    emit(state.copyWith(
      isRefreshing: true,
      errorMessage: null,
    ));

    final result = await _getPosts(const NoParams());

    result.fold(
      (failure) => emit(state.copyWith(
        isRefreshing: false,
        errorMessage: failure.message,
      )),
      (posts) => emit(state.copyWith(
        isRefreshing: false,
        posts: posts,
        status: PostsStatus.success,
      )),
    );
  }

  /// Handle ClearSelectedPostEvent
  void _onClearSelectedPost(
    ClearSelectedPostEvent event,
    Emitter<PostsState> emit,
  ) {
    emit(state.copyWith(selectedPost: null));
  }

  /// Handle ResetErrorEvent
  void _onResetError(
    ResetErrorEvent event,
    Emitter<PostsState> emit,
  ) {
    emit(state.copyWith(errorMessage: null));
  }
}
