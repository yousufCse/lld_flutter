import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:niramoy_health_app/features/registration/domain/entities/account_completion_entity.dart';
import 'package:niramoy_health_app/features/registration/domain/usecases/account_completion_usecase.dart';

part 'account_completion_cubit.freezed.dart';
part 'account_completion_state.dart';

@injectable
class AccountCompletionCubit extends Cubit<AccountCompletionState> {
  AccountCompletionCubit(this.accountCompletionUsecase)
    : super(AccountCompletionState.initial());

  final AccountCompletionUsecase accountCompletionUsecase;

  void completeAccount(String registrationId) async {
    emit(AccountCompletionState.loading());

    final result = await accountCompletionUsecase(
      CompleteRegistrationParams(registrationId: registrationId),
    );

    result.fold(
      (error) {
        emit(AccountCompletionState.error(error.code, error.message));
      },
      (entity) {
        emit(AccountCompletionState.success(entity));
      },
    );
  }
}
