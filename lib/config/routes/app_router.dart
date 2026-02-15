import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/posts/presentation/pages/post_detail_page.dart';
import '../../features/posts/presentation/pages/posts_page.dart';

/// Route names as constants
class AppRoutes {
  AppRoutes._();

  static const String home = '/';
  static const String posts = '/posts';
  static const String postDetail = '/posts/:id';

  // Helper to generate post detail path
  static String postDetailPath(int id) => '/posts/$id';
}

/// Application router configuration using go_router
class AppRouter {
  AppRouter._();

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  /// The main router configuration
  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.posts,
    debugLogDiagnostics: true,
    routes: _routes,
    errorBuilder: _errorBuilder,
    redirect: _redirect,
  );

  /// All application routes
  static final List<RouteBase> _routes = [
    // Posts list
    GoRoute(
      path: AppRoutes.posts,
      name: 'posts',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const PostsPage(),
        transitionsBuilder: _fadeTransition,
      ),
      routes: [
        // Post detail
        GoRoute(
          path: ':id',
          name: 'post-detail',
          pageBuilder: (context, state) {
            final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
            return CustomTransitionPage(
              key: state.pageKey,
              child: PostDetailPage(postId: id),
              transitionsBuilder: _slideTransition,
            );
          },
        ),
      ],
    ),

    // Redirect root to posts
    GoRoute(
      path: '/',
      redirect: (context, state) => AppRoutes.posts,
    ),
  ];

  /// Fade transition animation
  static Widget _fadeTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }

  /// Slide transition animation
  static Widget _slideTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOut,
      )),
      child: child,
    );
  }

  /// Error page for unknown routes
  static Widget _errorBuilder(BuildContext context, GoRouterState state) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              state.uri.toString(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                  ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.posts),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }

  /// Global redirect logic
  static String? _redirect(BuildContext context, GoRouterState state) {
    // Add auth redirect logic here if needed
    // final isLoggedIn = getIt<StorageService>().isLoggedIn;
    // final isLoginRoute = state.matchedLocation == AppRoutes.login;
    //
    // if (!isLoggedIn && !isLoginRoute) {
    //   return AppRoutes.login;
    // }
    //
    // if (isLoggedIn && isLoginRoute) {
    //   return AppRoutes.home;
    // }

    return null;
  }
}
