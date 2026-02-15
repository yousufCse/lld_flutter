import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:niramoy_health_app/core/presentation/widgets/index.dart';
import 'package:niramoy_health_app/core/resources/app_sizes.dart';
import 'package:niramoy_health_app/features/registration/presentation/cubit/otp_form/otp_form_cubit.dart';

class OtpTimer extends StatelessWidget {
  const OtpTimer({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildTimerIcon(context),
        Gap.horizontal(AppSizes.space8),
        const _RemainingTime(),
      ],
    );
  }

  Widget _buildTimerIcon(BuildContext context) {
    return Icon(
      Icons.timer_outlined,
      size: 16,
      color: Theme.of(context).colorScheme.secondary,
    );
  }
}

class _RemainingTime extends StatelessWidget {
  const _RemainingTime();

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OtpFormCubit, OtpFormState>(
      builder: (context, state) {
        return Text(
          _formatDuration(state.timerDuration),
          style: Theme.of(context).textTheme.bodyMedium,
        );
      },
    );
  }
}
