import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/face.dart';

part 'face_state.freezed.dart';

@freezed
sealed class FaceState with _$FaceState {
  const FaceState._();

  const factory FaceState.initial() = FaceInitial;

  const factory FaceState.loading() = FaceLoading;

  const factory FaceState.loaded({required Face face}) = FaceLoaded;

  const factory FaceState.error({required String message}) = FaceError;
}
