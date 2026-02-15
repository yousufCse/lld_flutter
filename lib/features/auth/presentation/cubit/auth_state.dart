import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/token_entity.dart';

// @freezed
// class AuthState with _$AuthState {
//   const factory AuthState.initial() = AuthInitial;
//   const factory AuthState.loading() = AuthLoading;
//   const factory AuthState.loginSuccess({required TokenEntity token}) =
//       AuthLoginSuccess;
//   const factory AuthState.failure({required Failure failure}) = AuthFailure;
// }

@sealed
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthLoginSuccess extends AuthState {
  final TokenEntity token;
  AuthLoginSuccess({required this.token});
}

final class AuthFailure extends AuthState {
  final Failure failure;
  AuthFailure({required this.failure});
}
