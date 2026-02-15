class AuthStatusResult {
  final bool isAuthenticated;
  final bool isFirstTime;

  const AuthStatusResult({
    required this.isAuthenticated,
    required this.isFirstTime,
  });
}
