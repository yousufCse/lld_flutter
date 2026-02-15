import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:niramoy_health_app/core/app/logger/console_app_logger.dart';
import 'package:niramoy_health_app/core/app/navigation/route_names.dart';

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
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(Icons.check_circle, size: 100, color: Colors.green),
              SizedBox(height: 24),
              Text(
                'Registration Successful!',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Text(
                'Welcome, ${completionData.userName}',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                'Patient ID: ${completionData.patientId}',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32),
              if (completionData.credentials.mustChangePassword)
                Card(
                  color: Colors.orange[50],
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.warning_amber, color: Colors.orange),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Temporary Password',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: SelectableText(
                                completionData.credentials.temporaryPassword,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
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
                        SizedBox(height: 8),
                        Text(
                          'Please save this password. You will need to change it on first login.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.orange[900],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => onContinue(context),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Continue to Login',
                    style: TextStyle(fontSize: 16),
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
