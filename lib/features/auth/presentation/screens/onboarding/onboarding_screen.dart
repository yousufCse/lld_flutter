import 'package:flutter/material.dart';
import 'package:niramoy_health_app/core/app/logger/app_logger.dart';
import 'package:niramoy_health_app/core/resources/app_sizes.dart';
import 'package:niramoy_health_app/core/resources/strings/app_strings.dart';
import 'package:niramoy_health_app/features/auth/presentation/cubits/auth/auth_cubit.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({
    super.key,
    required this.logger,
    required this.authCubit,
  });

  final AppLogger logger;
  final AuthCubit authCubit;

  void _handleGetStarted() async {
    logger.i('Onboarding completed, navigating to LoginScreen');
    await authCubit.completeOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    logger.i('Building OnboardingScreen');
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.screenPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const FlutterLogo(size: AppSizes.logoSizeLg),
              const SizedBox(height: AppSizes.space48),
              Text(
                AppStrings.onboardingTitle,
                style: theme.textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSizes.space16),
              Text(
                AppStrings.onboardingDescription,
                style: theme.textTheme.bodyLarge!.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSizes.space48),
              ElevatedButton(
                onPressed: _handleGetStarted,
                child: const Text(AppStrings.getStarted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
