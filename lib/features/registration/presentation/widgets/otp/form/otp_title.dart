import 'package:flutter/material.dart';
import 'package:niramoy_health_app/core/resources/resources.dart';

import 'form.dart';

class OtpTitle extends StatelessWidget {
  const OtpTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          AppStrings.otpTitle,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        Spacer(),
        OtpTimer(),
      ],
    );
  }
}
