import 'package:flutter_exercise/features/auth/domain/entities/token_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'token_model.g.dart';

@JsonSerializable()
class TokenModel {
  const TokenModel({required this.accessToken, required this.refreshToken});

  final String accessToken;
  final String refreshToken;

  factory TokenModel.fromJson(Map<String, dynamic> json) =>
      _$TokenModelFromJson(json);

  Map<String, dynamic> toJson() => _$TokenModelToJson(this);

  TokenEntity get toEntity {
    return TokenEntity(accessToken: accessToken, refreshToken: refreshToken);
  }
}
