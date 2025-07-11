import 'package:flutter/material.dart';

/// Service class to handle navigation operations in the app
class NavigationService {
  /// Navigate to a named route
  static void navigateTo(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    Navigator.pushNamed(context, routeName, arguments: arguments);
  }

  /// Navigate and replace the current route
  static void navigateAndReplace(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    Navigator.pushReplacementNamed(context, routeName, arguments: arguments);
  }

  /// Navigate and remove all previous routes
  static void navigateAndRemoveUntil(
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
  static void goBack(BuildContext context) {
    Navigator.pop(context);
  }

  /// Go back to a specific route, removing all routes until that one
  static void goBackToRoute(BuildContext context, String routeName) {
    Navigator.popUntil(context, ModalRoute.withName(routeName));
  }

  /// Go back with result
  static void goBackWithResult<T>(BuildContext context, T result) {
    Navigator.pop(context, result);
  }
}
