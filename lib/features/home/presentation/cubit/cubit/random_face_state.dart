part of 'random_face_cubit.dart';

sealed class RandomFaceState {}

final class RandomFaceInitial extends RandomFaceState {}

final class RandomFaceLoading extends RandomFaceState {}

final class RandomFaceLoaded extends RandomFaceState {
  final RandomFaceEntity entity;

  RandomFaceLoaded({required this.entity});
}

final class RandomFaceError extends RandomFaceState {
  final String message;

  RandomFaceError({required this.message});
}
