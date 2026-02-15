import 'package:json_annotation/json_annotation.dart';

part 'refresh_token_response_model.g.dart';

@JsonSerializable(createToJson: false)
class RefreshTokenResponseModel {
  @JsonKey(name: "success")
  final bool success;
  @JsonKey(name: "data")
  final RefreshTokenDataModel data;

  RefreshTokenResponseModel({required this.success, required this.data});

  factory RefreshTokenResponseModel.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenResponseModelFromJson(json);
}

@JsonSerializable(createToJson: false)
class RefreshTokenDataModel {
  @JsonKey(name: "tokens")
  final TokensModel tokens;

  RefreshTokenDataModel({required this.tokens});

  factory RefreshTokenDataModel.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenDataModelFromJson(json);
}

@JsonSerializable(createToJson: false)
class TokensModel {
  @JsonKey(name: "access_token")
  final String accessToken;
  @JsonKey(name: "refresh_token")
  final String refreshToken;
  @JsonKey(name: "token_type")
  final String tokenType;
  @JsonKey(name: "expires_in")
  final int expiresIn;

  TokensModel({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.expiresIn,
  });

  factory TokensModel.fromJson(Map<String, dynamic> json) =>
      _$TokensModelFromJson(json);
}
