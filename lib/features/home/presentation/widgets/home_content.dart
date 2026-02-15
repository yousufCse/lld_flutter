import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:niramoy_health_app/core/app/navigation/route_names.dart';
import 'package:niramoy_health_app/core/presentation/widgets/app_button.dart';
import 'package:niramoy_health_app/core/resources/strings/app_strings.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Welcome to the Home Screen!',
          style: Theme.of(context).textTheme.headlineSmall,
        ),

        AppButton.filled(
          onPressed: () {
            context.go(RouteNames.login);
          },
          title: AppStrings.logout,
        ),
      ],
    );
  }
}
