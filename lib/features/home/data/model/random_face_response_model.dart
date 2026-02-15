import 'package:flutter_exercise/features/home/domain/entity/random_face_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'random_face_response_model.g.dart';

@JsonSerializable()
class RandomFaceResponseModel {
  final List<RandomFaceModel> results;

  RandomFaceResponseModel({required this.results});

  factory RandomFaceResponseModel.fromJson(Map<String, dynamic> json) =>
      _$RandomFaceResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$RandomFaceResponseModelToJson(this);
}

@JsonSerializable()
class Name {
  final String title;
  final String first;
  final String last;

  Name({required this.title, required this.first, required this.last});

  factory Name.fromJson(Map<String, dynamic> json) => _$NameFromJson(json);

  Map<String, dynamic> toJson() => _$NameToJson(this);
}

@JsonSerializable()
class Picture {
  final String large;
  final String medium;
  final String thumbnail;

  Picture({required this.large, required this.medium, required this.thumbnail});

  factory Picture.fromJson(Map<String, dynamic> json) =>
      _$PictureFromJson(json);

  Map<String, dynamic> toJson() => _$PictureToJson(this);
}

@JsonSerializable()
class RandomFaceModel {
  final Name name;
  final Picture picture;

  RandomFaceModel({required this.name, required this.picture});

  factory RandomFaceModel.fromJson(Map<String, dynamic> json) =>
      _$RandomFaceModelFromJson(json);

  Map<String, dynamic> toJson() => _$RandomFaceModelToJson(this);

  RandomFaceEntity toEntity() {
    return RandomFaceEntity(
      name: '${name.title} ${name.first} ${name.last}',
      imageUrl: picture.large,
    );
  }
}
