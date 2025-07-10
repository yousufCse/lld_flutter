import 'package:freezed_annotation/freezed_annotation.dart';

part 'token_model.g.dart';

@JsonSerializable()
class TokenModel {
  final String? accessToken;
  final String? refreshToken;

  TokenModel({required this.accessToken, required this.refreshToken});

  factory TokenModel.fromJson(Map<String, dynamic> json) =>
      _$TokenModelFromJson(json);

  Map<String, dynamic> toJson() => _$TokenModelToJson(this);
}
