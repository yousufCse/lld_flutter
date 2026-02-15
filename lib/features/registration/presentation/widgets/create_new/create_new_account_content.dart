import 'package:flutter/material.dart';
import 'package:niramoy_health_app/core/presentation/widgets/index.dart';
import 'package:niramoy_health_app/core/resources/app_sizes.dart';

class CreateNewAccountContent extends StatelessWidget {
  const CreateNewAccountContent({
    super.key,
    required this.onConfirmed,
    required this.onCancelled,
  });

  final VoidCallback onConfirmed;
  final VoidCallback onCancelled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.contentPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Creating New Account',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Gap.vertical(AppSizes.space16),

          Text(
            'A new account associate with 0155774053 mobile number will be created for Wakib Hasan',
            style: Theme.of(context).textTheme.bodyMedium,
          ),

          Gap.vertical(AppSizes.space32),

          Row(
            children: [
              Expanded(
                child: AppButton.outlined(
                  title: 'Cancel',
                  onPressed: onCancelled,
                ),
              ),
              Gap.horizontal(AppSizes.space16),
              Expanded(
                child: AppButton.filled(
                  title: 'Confirm',
                  onPressed: onConfirmed,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
