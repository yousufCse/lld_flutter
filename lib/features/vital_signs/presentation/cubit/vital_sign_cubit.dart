import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../domain/usecases/get_latest_vital_sign_usecase.dart';
import 'vital_sign_state.dart';

@injectable
class VitalSignCubit extends Cubit<VitalSignState> {
  final GetLatestVitalSignUseCase getLatestVitalSignUseCase;

  VitalSignCubit({required this.getLatestVitalSignUseCase})
    : super(const VitalSignState.initial());

  Future<void> getLatestVitalSign(String userId) async {
    emit(const VitalSignState.loading());
    final result = await getLatestVitalSignUseCase(
      GetLatestVitalSignParams(userId: userId),
    );
    result.fold((failure) {
      // Handle different types of failures
      if (failure is ServerFailure) {
        emit(VitalSignState.error(message: failure.message));
      } else if (failure is NetworkFailure) {
        emit(VitalSignState.error(message: failure.message));
      } else if (failure is CacheFailure) {
        emit(VitalSignState.error(message: failure.message));
      } else {
        emit(const VitalSignState.error(message: 'Unknown error'));
      }
    }, (vitalSign) => emit(VitalSignState.loaded(vitalSign: vitalSign)));
  }
}
