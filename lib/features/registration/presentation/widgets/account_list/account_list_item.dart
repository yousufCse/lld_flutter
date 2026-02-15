import 'package:flutter/material.dart';
import 'package:niramoy_health_app/core/resources/index.dart';

import '../../../domain/entities/account_verification_entity.dart';

class AccountListItem extends StatelessWidget {
  const AccountListItem({
    super.key,
    required this.account,
    required this.onTap,
  });

  final ExistingAccount account;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.space16),
          child: Row(
            children: [
              CircleAvatar(
                radius: AppSizes.space24,
                child: Text(
                  account.fullName.substring(0, 1).toUpperCase(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: AppSizes.space16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      account.fullName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSizes.space4),
                    Text(
                      'Username: ${account.userName}',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    Text(
                      'Patient ID: ${account.patientId}',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    Text(
                      '${account.age} years • ${account.gender}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
