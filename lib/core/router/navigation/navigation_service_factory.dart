import 'package:flutter/foundation.dart' show kIsWeb;
import 'app_navigation_service.dart';
import 'navigation_service.dart';
import 'web_navigation_service.dart';

class NavigationServiceFactory {
  static NavigationService create() {
    if (kIsWeb) {
      return WebNavigationService();
    } else {
      return AppNavigationService();
    }
  }
}
