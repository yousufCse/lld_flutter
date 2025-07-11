// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lld_flutter/core/di/injection_container.dart' as di;
import 'package:lld_flutter/core/utils/validators/validators.dart';

import '../../../../core/router/router.dart';
import '../../../../core/utils/failure_utils.dart';
import '../../data/models/login_request_model.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  String? _deviceId;
  String? _deviceName;
  String? _osVersion;
  String? _osPlatform;
  Position? _position;

  late ValidatorContext emailValidatorContext;
  late ValidatorContext passwordValidatorContext;

  @override
  void initState() {
    _getDeviceInfo();
    _getCurrentPosition();
    emailValidatorContext = ValidatorContext(EmailValidator());
    passwordValidatorContext = ValidatorContext(PasswordValidator());

    super.initState();
  }

  Future<void> _getDeviceInfo() async {
    try {
      if (Theme.of(context).platform == TargetPlatform.iOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        setState(() {
          _deviceId = iosInfo.identifierForVendor;
          _deviceName = iosInfo.name;
          _osVersion = iosInfo.systemVersion;
          _osPlatform = 'iOS';
        });
      } else if (Theme.of(context).platform == TargetPlatform.android) {
        final androidInfo = await _deviceInfo.androidInfo;
        setState(() {
          _deviceId = androidInfo.id;
          _deviceName = androidInfo.model;
          _osVersion = androidInfo.version.release;
          _osPlatform = 'Android';
        });
      }
    } catch (e) {
      print('Failed to get device info: $e');
    }
  }

  Future<void> _getCurrentPosition() async {
    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        await Geolocator.requestPermission();
      }

      final position = await Geolocator.getCurrentPosition();
      setState(() {
        _position = position;
      });
    } catch (e) {
      print('Failed to get location: $e');
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Now using the centralized FailureUtils instead

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                    validator: emailValidatorContext.validate,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                    validator: passwordValidatorContext.validate,
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
                                  loginId: _emailController.text.trim(),
                                  pin: _passwordController.text,
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
