import 'package:equatable/equatable.dart';

class LoginFormState extends Equatable {
  final String email;
  final String password;
  final bool isPasswordVisible;

  const LoginFormState({
    this.email = '',
    this.password = '',
    this.isPasswordVisible = false,
  });

  LoginFormState copyWith({
    String? email,
    String? password,
    bool? isPasswordVisible,
  }) {
    return LoginFormState(
      email: email ?? this.email,
      password: password ?? this.password,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
    );
  }

  @override
  List<Object?> get props => [email, password, isPasswordVisible];
}
