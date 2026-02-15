import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/theme/app_theme.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/utils/helpers.dart';
import '../bloc/posts_bloc.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_widget.dart';

/// Post detail page showing full post content
class PostDetailPage extends StatelessWidget {
  final int postId;

  const PostDetailPage({
    super.key,
    required this.postId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<PostsBloc>()..add(GetPostByIdEvent(postId)),
      child: _PostDetailContent(postId: postId),
    );
  }
}

class _PostDetailContent extends StatelessWidget {
  final int postId;

  const _PostDetailContent({required this.postId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Detail'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // TODO: Implement share functionality
              context.showSnackBar('Share functionality coming soon!');
            },
          ),
        ],
      ),
      body: BlocBuilder<PostsBloc, PostsState>(
        builder: (context, state) {
          // Show loading state
          if (state.isLoadingDetails) {
            return const LoadingWidget(message: 'Loading post details...');
          }

          // Show error state
          if (state.hasError && state.selectedPost == null) {
            return AppErrorWidget(
              message: state.errorMessage ?? 'Failed to load post',
              onRetry: () {
                context.read<PostsBloc>().add(GetPostByIdEvent(postId));
              },
            );
          }

          // Show post content
          final post = state.selectedPost;
          if (post == null) {
            return const AppErrorWidget(
              message: 'Post not found',
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Post ID Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: context.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Text(
                    'Post #${post.id}',
                    style: context.textTheme.labelMedium?.copyWith(
                      color: context.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.md),

                // Title
                Text(
                  post.title.capitalize,
                  style: context.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: AppSpacing.sm),

                // Author Info
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: context.colorScheme.secondaryContainer,
                      child: Text(
                        'U${post.userId}',
                        style: context.textTheme.labelMedium?.copyWith(
                          color: context.colorScheme.onSecondaryContainer,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'User ${post.userId}',
                          style: context.textTheme.titleSmall,
                        ),
                        Text(
                          'Author',
                          style: context.textTheme.bodySmall?.copyWith(
                            color: context.colorScheme.outline,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.lg),

                // Divider
                Divider(
                  color: context.colorScheme.outlineVariant,
                ),

                const SizedBox(height: AppSpacing.lg),

                // Body Content
                Text(
                  post.body,
                  style: context.textTheme.bodyLarge?.copyWith(
                    height: 1.6,
                  ),
                ),

                const SizedBox(height: AppSpacing.xl),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          context.showSnackBar('Bookmark feature coming soon!');
                        },
                        icon: const Icon(Icons.bookmark_border),
                        label: const Text('Save'),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          context.showSnackBar('Comments feature coming soon!');
                        },
                        icon: const Icon(Icons.comment),
                        label: const Text('Comments'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
