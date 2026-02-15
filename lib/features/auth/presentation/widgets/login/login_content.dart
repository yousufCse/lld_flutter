import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/app/navigation/route_names.dart';
import '../../../../../core/presentation/widgets/index.dart';
import '../../../../../core/resources/app_sizes.dart';
import '../../../../../core/resources/strings/app_strings.dart';

class LoginContent extends StatelessWidget {
  const LoginContent({
    required Key formKey,
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required VoidCallback handleLogin,
    required this.isLoading,

    super.key,
  }) : _formKey = formKey,
       _emailController = emailController,
       _passwordController = passwordController,
       _handleLogin = handleLogin;

  final bool isLoading;
  final Key _formKey;
  final TextEditingController _emailController;
  final TextEditingController _passwordController;
  final VoidCallback _handleLogin;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.screenPadding),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppSizes.space48),
            const FlutterLogo(size: AppSizes.logoSizeSm),
            const SizedBox(height: AppSizes.space48),
            Text(
              AppStrings.loginWelcome,
              style: theme.textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.space8),
            Text(
              AppStrings.loginSubtitle,
              style: theme.textTheme.bodyLarge!.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.space48),

            AppTextField.email(
              labelText: AppStrings.email,
              controller: _emailController,
              enabled: !isLoading,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppStrings.emailHint;
                }
                if (!value.contains('@')) {
                  return AppStrings.emailInvalid;
                }
                return null;
              },
            ),
            const SizedBox(height: AppSizes.space16),

            AppTextField.password(
              labelText: AppStrings.password,
              controller: _passwordController,
              enabled: !isLoading,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppStrings.passwordHint;
                }
                if (value.length < 6) {
                  return AppStrings.passwordMinLength;
                }
                return null;
              },
            ),

            // TextFormField(
            //   controller: _passwordController,
            //   obscureText: _obscurePassword,
            //   decoration: InputDecoration(
            //     labelText: AppStrings.loginPassword,
            //     prefixIcon: const Icon(Icons.lock),
            //     suffixIcon: IconButton(
            //       icon: Icon(
            //         _obscurePassword
            //             ? Icons.visibility
            //             : Icons.visibility_off,
            //       ),
            //       onPressed: () {
            //         setState(() {
            //           _obscurePassword = !_obscurePassword;
            //         });
            //       },
            //     ),
            //   ),
            //   validator: (value) {
            //     if (value == null || value.isEmpty) {
            //       return AppStrings.loginPasswordHint;
            //     }
            //     if (value.length < 6) {
            //       return AppStrings.loginPasswordMinLength;
            //     }
            //     return null;
            //   },
            //   enabled: !isLoading,
            // ),
            const SizedBox(height: AppSizes.space24),

            AppButton.filled(
              title: AppStrings.loginButton,
              onPressed: isLoading ? null : _handleLogin,
            ),
            const SizedBox(height: 20.0),

            AppButton.text(
              onPressed: () {
                context.push(RouteNames.forgotPassword);
              },
              title: AppStrings.loginForgot,
            ),

            AppButton.outlined(
              title: AppStrings.loginRegister,
              onPressed: () {
                context.push(RouteNames.registration);
              },
            ),
          ],
        ),
      ),
    );
  }
}
