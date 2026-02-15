class LoginEntity {
  final bool success;
  final LoginDataEntity data;
  final String message;
  final LoginLinksEntity links;

  const LoginEntity({
    required this.success,
    required this.data,
    required this.message,
    required this.links,
  });
}

// ------------------------

class LoginDataEntity {
  final UserEntity user;
  final TokenEntity tokens;
  final LoginSessionEntity session;
  final bool passwordChangeRequired;

  const LoginDataEntity({
    required this.user,
    required this.tokens,
    required this.session,
    required this.passwordChangeRequired,
  });
}

// ------------------------

class LoginSessionEntity {
  final String sessionId;
  final bool persistent;

  const LoginSessionEntity({required this.sessionId, required this.persistent});
}

// ------------------------

class TokenEntity {
  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final int expiresIn;

  const TokenEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.expiresIn,
  });
}

// ------------------------

class UserEntity {
  final String id;
  final String patientId;
  final String name;
  final String phone;
  final int age;
  final String gender;
  final String role;
  final String status;
  final DateTime lastLoginAt;

  const UserEntity({
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
}

// ------------------------

class LoginLinksEntity {
  final String dashboard;
  final String profile;

  const LoginLinksEntity({required this.dashboard, required this.profile});
}
