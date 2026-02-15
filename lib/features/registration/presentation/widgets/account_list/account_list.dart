import 'package:flutter/material.dart';
import 'package:niramoy_health_app/core/presentation/widgets/widgets.dart';
import 'package:niramoy_health_app/core/resources/resources.dart';

import '../../../domain/entities/account_verification_entity.dart';
import 'account_list_item.dart';

class AccountList extends StatelessWidget {
  const AccountList({
    super.key,
    required this.accounts,
    required this.onAccountSelected,
  });

  final List<ExistingAccount> accounts;
  final Function(ExistingAccount) onAccountSelected;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        itemCount: accounts.length,
        separatorBuilder: (context, index) => Gap.vertical(AppSizes.space12),
        itemBuilder: (context, index) {
          final account = accounts[index];
          return AccountListItem(
            account: account,
            onTap: () => onAccountSelected(account),
          );
        },
      ),
    );
  }
}
