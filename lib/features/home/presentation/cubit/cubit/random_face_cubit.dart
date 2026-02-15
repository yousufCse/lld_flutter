import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_exercise/core/domain/usecase.dart';
import 'package:flutter_exercise/features/home/domain/entity/random_face_entity.dart';
import 'package:flutter_exercise/features/home/domain/usecase/get_random_face.dart';
import 'package:injectable/injectable.dart';

part 'random_face_state.dart';

@injectable
class RandomFaceCubit extends Cubit<RandomFaceState> {
  final GetRandomFace _getRandomFace;

  RandomFaceCubit({required GetRandomFace getRandomFace})
    : _getRandomFace = getRandomFace,
      super(RandomFaceInitial());

  Future<void> fetchRandomFace() async {
    emit(RandomFaceLoading());

    final res = await _getRandomFace(NoParams());
    res.fold(
      (l) {
        emit(RandomFaceError(message: l.toString()));
      },
      (r) {
        emit(RandomFaceLoaded(entity: r));
      },
    );
  }
}
