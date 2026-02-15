import 'package:flutter/material.dart';

class AccountSubtitle extends StatelessWidget {
  const AccountSubtitle({super.key, required this.accountCount});

  final int accountCount;

  @override
  Widget build(BuildContext context) {
    return Text(
      'We found $accountCount existing ${accountCount == 1 ? "account" : "accounts"} with this phone number',
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}
