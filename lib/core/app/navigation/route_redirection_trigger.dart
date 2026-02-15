import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class RouteRedirectionTrigger extends ChangeNotifier {
  void triggerRedirection() {
    notifyListeners();
  }

  void onAppLifecycleChanged(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      triggerRedirection();
    }
  }
}
