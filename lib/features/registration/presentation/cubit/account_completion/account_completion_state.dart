part of 'account_completion_cubit.dart';

@freezed
class AccountCompletionState with _$AccountCompletionState {
  const factory AccountCompletionState.initial() = _Initial;

  const factory AccountCompletionState.loading() = _Loading;

  const factory AccountCompletionState.success(AccountCompletionEntity entity) =
      _Success;

  const factory AccountCompletionState.error(String? code, String message) =
      _Failure;
}
