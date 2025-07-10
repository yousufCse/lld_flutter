import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/utils/usecase.dart';
import '../../data/models/login_request_model.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import 'auth_state.dart';

@injectable
class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;

  AuthCubit({
    required LoginUseCase loginUseCase,
    required LogoutUseCase logoutUseCase,
  }) : _loginUseCase = loginUseCase,
       _logoutUseCase = logoutUseCase,
       super(const AuthState.initial());

  // Login method
  Future<void> login(LoginRequestModel loginRequest) async {
    emit(const AuthState.loading());
    final result = await _loginUseCase(loginRequest);
    result.fold(
      (failure) => emit(AuthState.failure(message: failure.toString())),
      (token) => emit(AuthState.loginSuccess(token: token)),
    );
  }

  // Logout method
  Future<void> logout() async {
    emit(const AuthState.loading());
    final result = await _logoutUseCase(NoParams());
    result.fold(
      (failure) => emit(AuthState.failure(message: failure.toString())),
      (_) => emit(const AuthState.initial()),
    );
  }
}
