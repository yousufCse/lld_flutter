part of 'auth_cubit.dart';

enum AuthStatus { initial, authenticated, unauthenticated, firstTime, loading }

class AuthState extends Equatable {
  final AuthStatus status;
  final String? errorMessage;
  final LoginEntity? loginEntity;

  const AuthState({required this.status, this.loginEntity, this.errorMessage});

  factory AuthState.initial() {
    return const AuthState(status: AuthStatus.initial);
  }

  AuthState copyWith({
    AuthStatus? status,
    Object? loginEntity = _undefined,
    Object? errorMessage = _undefined,
  }) {
    return AuthState(
      status: status ?? this.status,
      errorMessage: errorMessage == _undefined
          ? this.errorMessage
          : errorMessage as String?,
      loginEntity: loginEntity == _undefined
          ? this.loginEntity
          : loginEntity as LoginEntity?,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, loginEntity];
}

const Object _undefined = Object();
