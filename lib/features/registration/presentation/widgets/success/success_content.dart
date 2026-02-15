import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:niramoy_health_app/core/app/navigation/route_names.dart';
import 'package:niramoy_health_app/core/presentation/widgets/app_button.dart';
import 'package:niramoy_health_app/core/resources/app_sizes.dart';
import 'package:niramoy_health_app/core/resources/strings/app_strings.dart';

class CongratulationaContent extends StatelessWidget {
  const CongratulationaContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.contentPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppStrings.congratsTitle,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          SizedBox(height: 20),
          Text(
            AppStrings.congratsMessage,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          SizedBox(height: AppSizes.space24),
          AppButton.filled(
            onPressed: () {
              context.go(RouteNames.login);
            },
            title: AppStrings.loginNow,
          ),
        ],
      ),
    );
  }
}
