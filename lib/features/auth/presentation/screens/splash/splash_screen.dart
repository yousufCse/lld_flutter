import 'package:flutter/material.dart';
import 'package:niramoy_health_app/core/resources/app_sizes.dart';
import 'package:niramoy_health_app/core/resources/strings/app_strings.dart';

import '../../cubits/auth/auth_cubit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({required this.authCubit, super.key});

  final AuthCubit authCubit;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Check auth status when splash screen loads
    Future.delayed(Duration(seconds: 1), () {
      widget.authCubit.checkAuthentication();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlutterLogo(size: AppSizes.logoSizeMd),
            SizedBox(height: AppSizes.space24),
            CircularProgressIndicator(),
            SizedBox(height: AppSizes.space16),
            Text(AppStrings.loading, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
