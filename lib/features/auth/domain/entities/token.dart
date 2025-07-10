import 'package:equatable/equatable.dart';

/// Entity class representing authentication tokens in the domain layer
class Token extends Equatable {
  final String? accessToken;
  final String? refreshToken;

  const Token({this.accessToken, this.refreshToken});

  @override
  List<Object?> get props => [accessToken, refreshToken];
}
