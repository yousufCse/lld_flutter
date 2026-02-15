class LoginResponse {
  final String token;
  final String refreshToken;

  LoginResponse({required this.token, required this.refreshToken});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['accessToken'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
    );
  }

  @override
  String toString() {
    return 'LoginResponse(token: $token, refreshToken: $refreshToken)';
  }
}
