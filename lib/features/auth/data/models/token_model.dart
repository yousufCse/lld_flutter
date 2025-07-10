import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/token.dart';

part 'token_model.g.dart';

@JsonSerializable()
class TokenModel extends Token {
  const TokenModel({required super.accessToken, required super.refreshToken});

  factory TokenModel.fromJson(Map<String, dynamic> json) =>
      _$TokenModelFromJson(json);

  Map<String, dynamic> toJson() => _$TokenModelToJson(this);
}
