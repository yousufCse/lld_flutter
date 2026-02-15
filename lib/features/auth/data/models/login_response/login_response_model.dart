import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:niramoy_health_app/features/auth/domain/entities/login_entity.dart';

part 'login_response_model.g.dart';

@JsonSerializable()
class LoginResponseModel {
  @JsonKey(name: "success")
  bool success;
  @JsonKey(name: "data")
  DataModel data;
  @JsonKey(name: "message")
  String message;
  @JsonKey(name: "links")
  LinksModel links;

  LoginResponseModel({
    required this.success,
    required this.data,
    required this.message,
    required this.links,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseModelToJson(this);

  LoginEntity get toEntity => LoginEntity(
    success: success,
    data: data.toEntity,
    message: message,
    links: links.toEntity,
  );
}

@JsonSerializable()
class DataModel {
  @JsonKey(name: "user")
  UserModel user;
  @JsonKey(name: "tokens")
  TokensModel tokens;
  @JsonKey(name: "session")
  SessionModel session;
  @JsonKey(name: "password_change_required")
  bool passwordChangeRequired;

  DataModel({
    required this.user,
    required this.tokens,
    required this.session,
    required this.passwordChangeRequired,
  });

  factory DataModel.fromJson(Map<String, dynamic> json) =>
      _$DataModelFromJson(json);

  Map<String, dynamic> toJson() => _$DataModelToJson(this);

  LoginDataEntity get toEntity => LoginDataEntity(
    user: user.toEntity,
    tokens: tokens.toEntity,
    session: session.toEntity,
    passwordChangeRequired: passwordChangeRequired,
  );
}

@JsonSerializable()
class SessionModel {
  @JsonKey(name: "session_id")
  String sessionId;
  @JsonKey(name: "persistent")
  bool persistent;

  SessionModel({required this.sessionId, required this.persistent});

  factory SessionModel.fromJson(Map<String, dynamic> json) =>
      _$SessionModelFromJson(json);

  Map<String, dynamic> toJson() => _$SessionModelToJson(this);

  LoginSessionEntity get toEntity =>
      LoginSessionEntity(sessionId: sessionId, persistent: persistent);
}

@JsonSerializable()
class TokensModel {
  @JsonKey(name: "access_token")
  String accessToken;
  @JsonKey(name: "refresh_token")
  String refreshToken;
  @JsonKey(name: "token_type")
  String tokenType;
  @JsonKey(name: "expires_in")
  int expiresIn;

  TokensModel({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.expiresIn,
  });

  factory TokensModel.fromJson(Map<String, dynamic> json) =>
      _$TokensModelFromJson(json);

  Map<String, dynamic> toJson() => _$TokensModelToJson(this);

  TokenEntity get toEntity => TokenEntity(
    accessToken: accessToken,
    refreshToken: refreshToken,
    tokenType: tokenType,
    expiresIn: expiresIn,
  );
}

@JsonSerializable()
class UserModel {
  @JsonKey(name: "id")
  String id;
  @JsonKey(name: "patient_id")
  String patientId;
  @JsonKey(name: "name")
  String name;
  @JsonKey(name: "phone")
  String phone;
  @JsonKey(name: "age")
  int age;
  @JsonKey(name: "gender")
  String gender;
  @JsonKey(name: "role")
  String role;
  @JsonKey(name: "status")
  String status;
  @JsonKey(name: "last_login_at")
  DateTime lastLoginAt;

  UserModel({
    required this.id,
    required this.patientId,
    required this.name,
    required this.phone,
    required this.age,
    required this.gender,
    required this.role,
    required this.status,
    required this.lastLoginAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserEntity get toEntity => UserEntity(
    id: id,
    patientId: patientId,
    name: name,
    phone: phone,
    age: age,
    gender: gender,
    role: role,
    status: status,
    lastLoginAt: lastLoginAt,
  );
}

@JsonSerializable()
class LinksModel {
  @JsonKey(name: "dashboard")
  String dashboard;
  @JsonKey(name: "profile")
  String profile;

  LinksModel({required this.dashboard, required this.profile});

  factory LinksModel.fromJson(Map<String, dynamic> json) =>
      _$LinksModelFromJson(json);

  Map<String, dynamic> toJson() => _$LinksModelToJson(this);

  LoginLinksEntity get toEntity =>
      LoginLinksEntity(dashboard: dashboard, profile: profile);
}
