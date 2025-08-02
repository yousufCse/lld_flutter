// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lld_flutter/core/di/injection_container.dart' as di;
import 'package:lld_flutter/core/utils/validators/validators.dart';
import 'package:lld_flutter/features/auth/presentation/cubit/login_form_state.dart';
import 'package:lld_flutter/features/auth/presentation/pages/user_view_model.dart';

import '../../../../core/router/router.dart';
import '../../../../core/utils/failure_utils.dart';
import '../../data/models/login_request_model.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../cubit/login_form_cubit.dart';
import 'print_data.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginFormCubit>(
      create: (_) => di.sl<LoginFormCubit>(),
      child: const LoginPageBody(),
    );
  }
}

class LoginPageBody extends StatefulWidget {
  const LoginPageBody({super.key});

  @override
  State<LoginPageBody> createState() => _LoginPageBodyState();
}

class _LoginPageBodyState extends State<LoginPageBody> {
  String? _deviceId;
  String? _deviceName;
  String? _osVersion;
  String? _osPlatform;
  Position? _position;

  late ValidatorContext emailValidatorContext;
  late ValidatorContext passwordValidatorContext;
  late LoginFormCubit _loginFormCubit;

  @override
  void initState() {
    emailValidatorContext = ValidatorContext(EmailValidator());
    passwordValidatorContext = ValidatorContext(PasswordValidator());

    _loginFormCubit = context.read<LoginFormCubit>();

    super.initState();
  }

  @override
  void dispose() {
    // No need to dispose controllers
    super.dispose();
  }

  final _userViewModel = UserViewModel();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final printData = di.sl<PrintData>();
      printData.printData();
    });

    return Scaffold(
      backgroundColor: Colors.amber,
      appBar: AppBar(title: const Text('Login')),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          state.when(
            initial: () {
              // No action needed for initial state
            },
            loading: () {
              // No action needed for loading state
            },
            loginSuccess: (token) {
              // Navigate to dashboard with token using the router
              di.sl<NavigationService>().navigateAndRemoveUntil(
                context,
                AppRoutes.dashboard,
                arguments: token,
              );
            },
            failure: (failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(FailureUtils.getFailureMessage(failure)),
                  backgroundColor: Colors.red,
                ),
              );
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Welcome Back',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              TextButton(
                onPressed: () {
                  _userViewModel.fetchTestUser();
                },
                child: Text('Fetch Test User'),
              ),
              const SizedBox(height: 40),

              ValueListenableBuilder(
                valueListenable: _userViewModel.user,
                builder: (context, value, child) {
                  if (value == null) {
                    return Center(child: const CircularProgressIndicator());
                  }
                  return Text('${value.name} ${value.age}');
                },
              ),

              const SizedBox(height: 40),
              _buildFormField(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormField() {
    return Column(
      children: [
        EmailTextField(
          vailidatorContext: emailValidatorContext,
          loginFormCubit: _loginFormCubit,
        ),
        const SizedBox(height: 16),
        PasswordTextField(
          vailidatorContext: passwordValidatorContext,
          loginFormCubit: _loginFormCubit,
        ),

        const SizedBox(height: 24),

        BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            final isLoading = state is AuthLoading;
            return SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () {
                        final loginRequest = LoginRequestModel(
                          loginId: '',
                          pin: '',
                          latitude: _position?.latitude.toString(),
                          longitude: _position?.longitude.toString(),
                          deviceId: _deviceId,
                          deviceName: _deviceName,
                          osversion: _osVersion,
                          osplatform: _osPlatform,
                        );
                        context.read<AuthCubit>().login(loginRequest);
                      },

                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'LOGIN',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class EmailTextField extends StatelessWidget {
  const EmailTextField({
    super.key,

    required ValidatorContext vailidatorContext,
    required LoginFormCubit loginFormCubit,
  }) : _validatorContext = vailidatorContext,
       _loginFormCubit = loginFormCubit;

  final ValidatorContext _validatorContext;
  final LoginFormCubit _loginFormCubit;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<LoginFormCubit, LoginFormState, String>(
      selector: (state) {
        return state.email;
      },
      builder: (context, email) {
        log('EmailTextField: email: $email');
        return TextFormField(
          initialValue: email,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.email),
          ),
          validator: _validatorContext.validate,
          onChanged: _loginFormCubit.emailChanged,
        );
      },
    );
  }
}

class PasswordTextField extends StatelessWidget {
  const PasswordTextField({
    super.key,
    required ValidatorContext vailidatorContext,
    required LoginFormCubit loginFormCubit,
  }) : _validatorContext = vailidatorContext,
       _loginFormCubit = loginFormCubit;

  final ValidatorContext _validatorContext;
  final LoginFormCubit _loginFormCubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginFormCubit, LoginFormState>(
      buildWhen: (previous, current) {
        return previous.password != current.password ||
            previous.isPasswordVisible != current.isPasswordVisible;
      },
      builder: (context, state) {
        log('PasswordTextField: state password: ${state.password}');
        log('PasswordTextField: isPasswordVisible: ${state.isPasswordVisible}');
        return TextFormField(
          initialValue: state.password,
          obscureText: !state.isPasswordVisible,
          decoration: InputDecoration(
            labelText: 'Password',
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.lock),
            suffixIcon: IconButton(
              icon: Icon(
                state.isPasswordVisible
                    ? Icons.visibility
                    : Icons.visibility_off,
              ),
              onPressed: _loginFormCubit.togglePasswordVisibility,
            ),
          ),
          validator: _validatorContext.validate,
          onChanged: _loginFormCubit.passwordChanged,
        );
      },
    );
  }
}
