import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:niramoy_health_app/core/app/logger/app_logger.dart';
import 'package:niramoy_health_app/core/presentation/widgets/app_dialog.dart';
import 'package:niramoy_health_app/core/resources/app_sizes.dart';
import 'package:niramoy_health_app/core/resources/strings/app_strings.dart';
import 'package:niramoy_health_app/features/auth/presentation/cubits/auth/auth_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.logger, required this.authState});

  final AppLogger logger;
  final AuthState authState;

  @override
  Widget build(BuildContext context) {
    logger.i(
      'Building HomeScreen: Email=${authState.loginEntity?.data.user.phone} | Name=${authState.loginEntity?.data.user.name}',
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.home),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final confirmed = await AppDialog.confirm(
                context,
                title: AppStrings.logout,
                message: AppStrings.logoutConfirmation,
                confirmText: AppStrings.logout,
                isDestructive: true,
              );
              if (confirmed && context.mounted) {
                context.read<AuthCubit>().logout();
              }
            },
          ),
        ],
      ),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          final theme = Theme.of(context);
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.home, size: 100, color: Colors.blue),
                const SizedBox(height: AppSizes.space24),
                Text(
                  AppStrings.loginWelcome,
                  style: theme.textTheme.headlineSmall,
                ),
                const SizedBox(height: AppSizes.space8),
                Text(
                  authState.loginEntity?.data.user.name ?? 'John Doe',
                  style: theme.textTheme.bodyLarge!.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSizes.space8),
                Text(
                  authState.loginEntity?.data.user.phone ?? 'dummy@example.com',
                  style: theme.textTheme.bodyLarge!.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
