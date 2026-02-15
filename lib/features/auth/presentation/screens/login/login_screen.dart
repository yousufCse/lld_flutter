import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:niramoy_health_app/features/auth/domain/usecase/login_usecase.dart';

import '../../cubits/auth/auth_cubit.dart';
import '../../widgets/login/login_content.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().login(
        LoginParams(
          patientId: 'pfh.developer1@gmail.com',
          password: 'TempP@ss123',
          // loginId: _emailController.text,
          // pin: _passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state.status == AuthStatus.loading;

            return LoginContent(
              formKey: _formKey,
              emailController: _emailController,
              passwordController: _passwordController,
              handleLogin: _handleLogin,
              isLoading: isLoading,
            );
          },
        ),
      ),
    );
  }
}
