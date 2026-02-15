import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:niramoy_health_app/core/app/logger/console_app_logger.dart';
import 'package:niramoy_health_app/core/app/navigation/route_names.dart';
import 'package:niramoy_health_app/core/presentation/widgets/gap.dart';
import 'package:niramoy_health_app/core/resources/app_sizes.dart';
import 'package:niramoy_health_app/core/responsive/responsive.dart';

import '../../../domain/entities/account_completion_entity.dart';

class CongratulationScreen extends StatelessWidget {
  const CongratulationScreen({super.key, required this.completionData});

  final AccountCompletionEntity completionData;

  void onContinue(BuildContext context) {
    context.go(RouteNames.login);
  }

  @override
  Widget build(BuildContext context) {
    logger.i(
      'Congratulation Screen build: with userName: ${completionData.userName}',
    );
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(context.scaled(AppSizes.screenPadding)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.check_circle,
                size: context.scaled(AppSizes.space100),
                color: Colors.green,
              ),
              Gap.vertical(context.scaled(AppSizes.space24)),
              Text(
                'Registration Successful!',
                style: theme.textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              Gap.vertical(context.scaled(AppSizes.space16)),
              Text(
                'Welcome, ${completionData.userName}',
                style: theme.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              Gap.vertical(context.scaled(AppSizes.space8)),
              Text(
                'Patient ID: ${completionData.patientId}',
                style: theme.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              Gap.vertical(context.scaled(AppSizes.space32)),
              if (completionData.credentials.mustChangePassword)
                Card(
                  color: Colors.orange[50],
                  child: Padding(
                    padding: EdgeInsets.all(
                      context.scaled(AppSizes.space16),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.warning_amber, color: Colors.orange),
                            Gap.horizontal(context.scaled(AppSizes.space8)),
                            Expanded(
                              child: Text(
                                'Temporary Password',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Gap.vertical(context.scaled(AppSizes.space12)),
                        Row(
                          children: [
                            Expanded(
                              child: SelectableText(
                                completionData.credentials.temporaryPassword,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.copy),
                              onPressed: () {
                                Clipboard.setData(
                                  ClipboardData(
                                    text: completionData
                                        .credentials
                                        .temporaryPassword,
                                  ),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Password copied to clipboard',
                                    ),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        Gap.vertical(context.scaled(AppSizes.space8)),
                        Text(
                          'Please save this password. You will need to change it on first login.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.orange[900],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              Gap.vertical(context.scaled(AppSizes.space32)),
              ElevatedButton(
                onPressed: () => onContinue(context),
                child: Padding(
                  padding: EdgeInsets.all(
                    context.scaled(AppSizes.space16),
                  ),
                  child: Text(
                    'Continue to Login',
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
