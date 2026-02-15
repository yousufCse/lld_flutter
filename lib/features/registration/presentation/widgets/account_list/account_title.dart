import 'package:flutter/material.dart';

class AccountTitle extends StatelessWidget {
  const AccountTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Account List',
      style: Theme.of(context).textTheme.headlineSmall,
    );
  }
}
