import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lld_flutter/core/router/navigation/navigation_service.dart';

/// Service class to handle navigation operations in the app
class AppNavigationService extends NavigationService {
  /// Navigate to a named route
  @override
  void navigateTo(BuildContext context, String routeName, {Object? arguments}) {
    Navigator.pushNamed(context, routeName, arguments: arguments);
  }

  /// Navigate and replace the current route
  @override
  void navigateAndReplace(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    log(
      'Navigating and replacing route: $routeName with arguments: $arguments',
    );
    Navigator.pushReplacementNamed(context, routeName, arguments: arguments);
  }

  /// Navigate and remove all previous routes
  @override
  void navigateAndRemoveUntil(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      routeName,
      (route) => false, // Remove all previous routes
      arguments: arguments,
    );
  }

  /// Go back to the previous page
  @override
  void goBack(BuildContext context) {
    Navigator.pop(context);
  }

  /// Go back to a specific route, removing all routes until that one
  @override
  void goBackToRoute(BuildContext context, String routeName) {
    Navigator.popUntil(context, ModalRoute.withName(routeName));
  }

  /// Go back with result
  @override
  void goBackWithResult<T>(BuildContext context, T result) {
    Navigator.pop(context, result);
  }
}
