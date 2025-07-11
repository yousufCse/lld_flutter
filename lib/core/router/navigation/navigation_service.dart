import 'package:flutter/material.dart';

abstract class NavigationService {
  /// Navigate to a named route
  void navigateTo(BuildContext context, String routeName, {Object? arguments});

  /// Navigate and replace the current route
  void navigateAndReplace(
    BuildContext context,
    String routeName, {
    Object? arguments,
  });

  /// Navigate and remove all previous routes
  void navigateAndRemoveUntil(
    BuildContext context,
    String routeName, {
    Object? arguments,
  });

  /// Go back to the previous page
  void goBack(BuildContext context);

  /// Go back to a specific route, removing all routes until that one
  void goBackToRoute(BuildContext context, String routeName);

  /// Go back with result
  void goBackWithResult<T>(BuildContext context, T result);
}
