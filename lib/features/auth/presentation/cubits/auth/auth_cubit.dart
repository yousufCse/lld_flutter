import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:niramoy_health_app/core/domain/usecase.dart';
import 'package:niramoy_health_app/features/auth/domain/entities/login_entity.dart';
import 'package:niramoy_health_app/features/auth/domain/usecase/check_auth_state_usecase.dart';
import 'package:niramoy_health_app/features/auth/domain/usecase/complete_onboarding_usecase.dart';
import 'package:niramoy_health_app/features/auth/domain/usecase/login_usecase.dart';
import 'package:niramoy_health_app/features/auth/domain/usecase/logout_usecase.dart';

part 'auth_state.dart';

@lazySingleton
class AuthCubit extends Cubit<AuthState> {
  final CheckAuthStatusUsecase _checkAuthStatus;
  final CompleteOnboardingUsecase _completeOnboardingUsecase;
  final LoginUsecase _loginUsecase;
  final LogoutUsecase _logoutUsecase;

  AuthCubit({
    required CheckAuthStatusUsecase checkAuthStatusUsecase,
    required LoginUsecase loginUsecase,
    required LogoutUsecase logoutUsecase,
    required CompleteOnboardingUsecase completeOnboardingUsecase,
  }) : _checkAuthStatus = checkAuthStatusUsecase,
       _loginUsecase = loginUsecase,
       _logoutUsecase = logoutUsecase,
       _completeOnboardingUsecase = completeOnboardingUsecase,
       super(AuthState.initial());

  Future<void> checkAuthentication() async {
    _emitLoading();

    final result = await _checkAuthStatus(NoParams());
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: AuthStatus.unauthenticated,
            errorMessage: failure.toString(),
          ),
        );
      },
      (authStatusResult) {
        if (authStatusResult.isFirstTime) {
          emit(state.copyWith(status: AuthStatus.firstTime));
        } else if (authStatusResult.isAuthenticated) {
          emit(state.copyWith(status: AuthStatus.authenticated));
        } else {
          emit(state.copyWith(status: AuthStatus.unauthenticated));
        }
      },
    );
  }

  Future<void> login(LoginParams params) async {
    _emitLoading();

    final result = await _loginUsecase.call(params);
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: AuthStatus.unauthenticated,
            errorMessage: failure.toString(),
          ),
        );
      },
      (loginEntity) async {
        emit(
          state.copyWith(
            status: AuthStatus.authenticated,
            loginEntity: loginEntity,
          ),
        );
      },
    );
  }

  Future<void> completeOnboarding() async {
    _emitLoading();

    final result = await _completeOnboardingUsecase(NoParams());
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: AuthStatus.firstTime,
            errorMessage: failure.toString(),
          ),
        );
      },
      (_) {
        emit(
          state.copyWith(
            status: AuthStatus.unauthenticated,
            errorMessage: null,
            loginEntity: null,
          ),
        );
      },
    );
  }

  Future<void> logout() async {
    _emitLoading();
    final result = await _logoutUsecase(NoParams());
    result.fold((failure) => _emitLogout(), (_) => _emitLogout());
  }

  void _emitLogout() {
    return emit(
      state.copyWith(
        status: AuthStatus.unauthenticated,
        loginEntity: null,
        errorMessage: null,
      ),
    );
  }

  void _emitLoading() {
    emit(state.copyWith(status: AuthStatus.loading));
  }
}
