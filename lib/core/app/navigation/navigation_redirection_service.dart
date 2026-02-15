import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

abstract class NavigationRedirectionService {
  FutureOr<String?> redirectTo(BuildContext context, GoRouterState state);
}

@Injectable(as: NavigationRedirectionService)
class NavigationRedirectionServiceImpl implements NavigationRedirectionService {
  @override
  FutureOr<String?> redirectTo(BuildContext context, GoRouterState state) {
    return null;
  }
}
