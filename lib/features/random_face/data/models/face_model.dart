import '../../domain/entities/face.dart';

// We need to change our approach because Freezed doesn't work well with Equatable
// Instead of using @freezed, let's create a regular class that extends our entity
class FaceModel extends Face {
  const FaceModel({
    required super.id,
    required super.imageUrl,
    required super.age,
    required super.gender,
  });

  factory FaceModel.fromJson(Map<String, dynamic> json) {
    return FaceModel(
      id: json['id'] as String,
      imageUrl: json['image_url'] as String,
      age: (json['age'] as num).toInt(),
      gender: json['gender'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'image_url': imageUrl, 'age': age, 'gender': gender};
  }
}
