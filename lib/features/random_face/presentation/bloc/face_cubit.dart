import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/utils/usecase.dart';
import '../../domain/usecases/get_random_face.dart';
import 'face_state.dart';

@injectable
class FaceCubit extends Cubit<FaceState> {
  final GetRandomFace getRandomFace;

  FaceCubit(this.getRandomFace) : super(const FaceState.initial());

  Future<void> fetchRandomFace() async {
    emit(const FaceState.loading());

    final result = await getRandomFace(NoParams());

    result.fold(
      (failure) => emit(FaceState.error(message: failure.toString())),
      (face) => emit(FaceState.loaded(face: face)),
    );
  }
}
