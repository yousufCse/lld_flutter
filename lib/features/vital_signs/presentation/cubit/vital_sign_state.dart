import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/vital_sign.dart';

part 'vital_sign_state.freezed.dart';

@freezed
class VitalSignState with _$VitalSignState {
  const factory VitalSignState.initial() = VitalSignInitial;
  const factory VitalSignState.loading() = VitalSignLoading;
  const factory VitalSignState.loaded({required VitalSign vitalSign}) =
      VitalSignLoaded;
  const factory VitalSignState.error({required String message}) =
      VitalSignError;
}
