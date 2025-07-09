import 'package:equatable/equatable.dart';

class Face extends Equatable {
  final String id;
  final String imageUrl;
  final int age;
  final String gender;

  const Face({
    required this.id,
    required this.imageUrl,
    required this.age,
    required this.gender,
  });

  @override
  List<Object?> get props => [id, imageUrl, age, gender];
}
