import 'package:equatable/equatable.dart';

/// Entity class representing authentication tokens in the domain layer
class TokenEntity extends Equatable {
  final String? accessToken;
  final String? refreshToken;

  const TokenEntity({this.accessToken, this.refreshToken});

  /// Creates a copy of this token with the specified fields replaced with new values
  TokenEntity copyWith({String? accessToken, String? refreshToken}) {
    return TokenEntity(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }

  factory TokenEntity.empty() {
    return const TokenEntity(accessToken: null, refreshToken: null);
  }

  @override
  List<Object?> get props => [accessToken, refreshToken];
}
