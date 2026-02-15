import 'package:flutter/material.dart';

class LeadingBack extends StatelessWidget {
  const LeadingBack({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed ?? () => Navigator.of(context).pop(),
      icon: const Icon(Icons.arrow_back),
    );
  }
}
