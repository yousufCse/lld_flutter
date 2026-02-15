import 'package:flutter/material.dart';

class OtpInstruction extends StatelessWidget {
  const OtpInstruction({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'We’ve sent a one-time password (OTP) to your registered mobile number. Use this code to verify your identity',
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}
