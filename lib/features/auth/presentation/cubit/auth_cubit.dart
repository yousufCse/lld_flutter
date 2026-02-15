import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_exercise/core/domain/usecase.dart';
import 'package:injectable/injectable.dart';

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
       super(AuthInitial());

  // Login method
  Future<void> login(LoginRequestModel loginRequest) async {
    emit(AuthLoading());
    final result = await _loginUseCase(loginRequest);
    result.fold(
      (failure) => emit(AuthFailure(failure: failure)),
      (token) => emit(AuthLoginSuccess(token: token)),
    );
  }

  // Logout method
  Future<void> logout() async {
    emit(AuthLoading());
    final result = await _logoutUseCase(NoParams());
    result.fold(
      (failure) => emit(AuthFailure(failure: failure)),
      (_) => emit(AuthInitial()),
    );
  }
}
