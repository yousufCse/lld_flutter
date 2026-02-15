import 'package:flutter/material.dart';
import '../../../res/l10n/app_localizations.dart';

/// Main scaffold wrapper for the application
/// Provides consistent layout structure and navigation
class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.child,
    this.showBottomNav = true,
    this.appBar,
    this.floatingActionButton,
  });

  final Widget child;
  final bool showBottomNav;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: child,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: showBottomNav
          ? _buildBottomNavigationBar(context)
          : null,
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.home),
          label: l10n?.home ?? 'Home',
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.dashboard),
          label: l10n?.dashboard ?? 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.favorite),
          label: l10n?.myHealth ?? 'My Health',
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.restaurant),
          label: l10n?.nutrition ?? 'Nutrition',
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.fitness_center),
          label: l10n?.exercise ?? 'Exercise',
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.book),
          label: l10n?.journal ?? 'Journal',
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.person),
          label: l10n?.profile ?? 'Profile',
        ),
      ],
      currentIndex: 0, // This will be managed by a state management solution
      onTap: (index) {
        // Handle navigation
        _navigateToScreen(context, index);
      },
    );
  }

  void _navigateToScreen(BuildContext context, int index) {
    // This will be implemented with proper navigation
    // For now, just print the index
    debugPrint('Navigate to index: $index');
  }
}

/// Extension for easy access to bottom navigation
extension AppScaffoldX on Widget {
  Widget withAppScaffold({
    bool showBottomNav = true,
    PreferredSizeWidget? appBar,
    Widget? floatingActionButton,
  }) {
    return AppScaffold(
      child: this,
      showBottomNav: showBottomNav,
      appBar: appBar,
      floatingActionButton: floatingActionButton,
    );
  }
}
