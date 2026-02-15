import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:niramoy_health_app/core/validation/app_validators.dart';
import 'package:niramoy_health_app/features/registration/domain/usecases/register_initiate_usecase.dart';

import '../../../domain/entities/register_entity.dart';

part 'registration_form_state.dart';

@injectable
class RegistrationFormCubit extends Cubit<RegistrationFormState> {
  RegistrationFormCubit(this._registerInitiateUsecase)
    : super(const RegistrationFormState.initial());

  final RegisterInitiateUsecase _registerInitiateUsecase;

  void onFirstNameChanged(String value) {
    emit(state.copyWith(firstName: value));
  }

  void onLastNameChanged(String value) {
    emit(state.copyWith(lastName: value));
  }

  void onMobileChanged(String value) {
    emit(state.copyWith(mobile: value));
  }

  void onDobChanged(DateTime value) {
    emit(state.copyWith(dob: value));
  }

  void onGenderChanged(String? value) {
    emit(state.copyWith(gender: value));
  }

  /// Validates all fields and returns `true` if the form is valid.
  bool validate() {
    emit(state.copyWith(submitted: true));
    return state.isValid;
  }

  Future<void> registerInitial(RegisterParams params) async {
    if (!validate()) return;

    emit(state.copyWith(registerState: const RegisterInitiateLoading()));
    final result = await _registerInitiateUsecase.call(params);
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            registerState: RegisterInitiateFailure(
              failure.message,
              code: failure.code,
            ),
          ),
        );
      },
      (registerEntity) {
        emit(
          state.copyWith(
            registerState: RegisterInitiateSuccess(registerEntity),
          ),
        );
      },
    );
  }
}
