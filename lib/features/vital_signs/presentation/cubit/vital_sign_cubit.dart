import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

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
    result.fold(
      (failure) => emit(VitalSignState.error(failure: failure)),
      (vitalSign) => emit(VitalSignState.loaded(vitalSign: vitalSign)),
    );
  }
}
