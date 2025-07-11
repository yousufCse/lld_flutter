import 'package:equatable/equatable.dart';

/// Entity class representing authentication tokens in the domain layer
class Token extends Equatable {
  final String? accessToken;
  final String? refreshToken;

  const Token({this.accessToken, this.refreshToken});

  /// Creates a copy of this token with the specified fields replaced with new values
  Token copyWith({String? accessToken, String? refreshToken}) {
    return Token(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }

  @override
  List<Object?> get props => [accessToken, refreshToken];
}
