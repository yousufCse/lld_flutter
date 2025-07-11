import 'package:flutter/foundation.dart' show kIsWeb;
import 'app_navigation_service.dart';
import 'navigation_service.dart';
import 'web_navigation_service.dart';

NavigationService createNavigationService() {
  if (kIsWeb) {
    return WebNavigationService();
  } else {
    return AppNavigationService();
  }
}
