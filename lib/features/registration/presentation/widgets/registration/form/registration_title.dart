import 'package:flutter/material.dart';
import 'package:niramoy_health_app/core/resources/index.dart';

class RegistrationTitle extends StatelessWidget {
  const RegistrationTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        RegistrationStrings.registration,
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}
