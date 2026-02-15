import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/post_entity.dart';

part 'post_model.freezed.dart';
part 'post_model.g.dart';

/// Post model for data layer with JSON serialization
/// Uses Freezed for immutability and code generation
@freezed
class PostModel with _$PostModel {
  const PostModel._();

  const factory PostModel({
    required int id,
    required int userId,
    required String title,
    required String body,
  }) = _PostModel;

  /// Create PostModel from JSON
  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);

  /// Convert PostModel to PostEntity (domain layer)
  PostEntity toEntity() => PostEntity(
        id: id,
        userId: userId,
        title: title,
        body: body,
      );

  /// Create PostModel from PostEntity
  factory PostModel.fromEntity(PostEntity entity) => PostModel(
        id: entity.id,
        userId: entity.userId,
        title: entity.title,
        body: entity.body,
      );
}

/// Extension for converting list of models to entities
extension PostModelListExtension on List<PostModel> {
  List<PostEntity> toEntities() => map((model) => model.toEntity()).toList();
}
