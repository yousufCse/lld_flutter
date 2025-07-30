// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lld_flutter/core/di/injection_container.dart' as di;
import 'package:lld_flutter/core/utils/validators/validators.dart';

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
  final _formKey = GlobalKey<FormState>();
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

  // Now using the centralized FailureUtils instead

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final printData = di.sl<PrintData>();
      printData.printData();
    });

    return Scaffold(
      backgroundColor: Colors.amber,
      appBar: AppBar(title: const Text('Login')),
      body: BlocConsumer<AuthCubit, AuthState>(
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
        builder: (context, state) {
          bool isLoading = state.maybeWhen(
            loading: () => true,
            orElse: () => false,
          );
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
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
                  TextFormField(
                    // initialValue: formState.email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                    validator: emailValidatorContext.validate,
                    onChanged: _loginFormCubit.emailChanged,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    // initialValue: formState.password,
                    obscureText: !true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _loginFormCubit.state.isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: _loginFormCubit.togglePasswordVisibility,
                      ),
                    ),
                    validator: passwordValidatorContext.validate,
                    onChanged: _loginFormCubit.passwordChanged,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
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
                              }
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
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
