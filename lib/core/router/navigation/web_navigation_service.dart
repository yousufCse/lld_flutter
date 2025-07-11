import 'package:flutter/material.dart';

import 'navigation_service.dart';

class WebNavigationService extends NavigationService {
  /// Web-specific navigation logic can be implemented here
  @override
  void navigateTo(BuildContext context, String routeName, {Object? arguments}) {
    // Implement web navigation logic if needed
    throw UnimplementedError('Web navigation not implemented');
  }

  @override
  void goBack(BuildContext context) {}

  @override
  void goBackToRoute(BuildContext context, String routeName) {}

  @override
  void goBackWithResult<T>(BuildContext context, T result) {}

  @override
  void navigateAndRemoveUntil(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {}

  @override
  void navigateAndReplace(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {}

  // Other methods can be overridden similarly if needed
}
