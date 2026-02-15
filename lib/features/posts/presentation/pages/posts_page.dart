import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/app_router.dart';
import '../../../../config/theme/app_theme.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/utils/helpers.dart';
import '../bloc/posts_bloc.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/post_card.dart';

/// Posts list page
class PostsPage extends StatelessWidget {
  const PostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<PostsBloc>()..add(const GetPostsEvent()),
      child: const _PostsPageContent(),
    );
  }
}

class _PostsPageContent extends StatelessWidget {
  const _PostsPageContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<PostsBloc>().add(const RefreshPostsEvent());
            },
          ),
        ],
      ),
      body: BlocConsumer<PostsBloc, PostsState>(
        listenWhen: (previous, current) =>
            previous.errorMessage != current.errorMessage &&
            current.errorMessage != null,
        listener: (context, state) {
          if (state.errorMessage != null) {
            context.showErrorSnackBar(state.errorMessage!);
          }
        },
        builder: (context, state) {
          // Show loading state
          if (state.status.isLoading) {
            return const LoadingWidget(message: 'Loading posts...');
          }

          // Show error state with retry
          if (state.status.isFailure && !state.hasPosts) {
            return AppErrorWidget(
              message: state.errorMessage ?? 'Failed to load posts',
              onRetry: () {
                context.read<PostsBloc>().add(const GetPostsEvent());
              },
            );
          }

          // Show empty state
          if (state.status.isSuccess && !state.hasPosts) {
            return const _EmptyPostsWidget();
          }

          // Show posts list
          return RefreshIndicator(
            onRefresh: () async {
              context.read<PostsBloc>().add(const RefreshPostsEvent());
              // Wait for the refresh to complete
              await context.read<PostsBloc>().stream.firstWhere(
                    (state) => !state.isRefreshing,
                  );
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: state.posts.length,
              separatorBuilder: (context, index) => const SizedBox(
                height: AppSpacing.md,
              ),
              itemBuilder: (context, index) {
                final post = state.posts[index];
                return PostCard(
                  post: post,
                  onTap: () {
                    context.push(AppRoutes.postDetailPath(post.id));
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _EmptyPostsWidget extends StatelessWidget {
  const _EmptyPostsWidget();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.article_outlined,
            size: 80,
            color: context.colorScheme.outline,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'No posts found',
            style: context.textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Pull down to refresh',
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }
}
