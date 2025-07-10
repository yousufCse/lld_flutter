import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/models/token_model.dart';
import '../../../dashboard/data/models/user_model.dart';

part 'auth_state.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = AuthInitial;
  const factory AuthState.loading() = AuthLoading;
  const factory AuthState.loginSuccess({required TokenModel token}) =
      AuthLoginSuccess;
  const factory AuthState.failure({required String message}) = AuthFailure;
}
