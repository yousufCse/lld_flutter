import 'package:flutter/material.dart';
import 'package:niramoy_health_app/core/presentation/widgets/index.dart';
import 'package:niramoy_health_app/core/resources/index.dart';
import 'package:niramoy_health_app/features/registration/domain/entities/account_verification_entity.dart';
import 'package:niramoy_health_app/features/registration/presentation/widgets/account_list/account_subtitle.dart';
import 'package:niramoy_health_app/features/registration/presentation/widgets/account_list/account_title.dart';

import 'account_list.dart';

class AccountListContent extends StatelessWidget {
  const AccountListContent({
    super.key,
    required this.accounts,
    required this.onAddNewAccount,
    required this.onAccountSelected,
  });

  final List<ExistingAccount> accounts;
  final VoidCallback onAddNewAccount;
  final Function(ExistingAccount) onAccountSelected;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AccountTitle(),
            Gap.vertical(AppSizes.space16),
            AccountSubtitle(accountCount: accounts.length),
            Gap.vertical(AppSizes.space24),
            AccountList(
              accounts: accounts,
              onAccountSelected: onAccountSelected,
            ),
            Gap.vertical(AppSizes.space16),
            AppButton.outlined(
              title: 'Add New Account',
              onPressed: onAddNewAccount,
            ),
          ],
        ),
      ),
    );
  }
}
