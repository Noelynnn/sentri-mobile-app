class AuthUser {
  final int id;
  final String fullName;
  final String email;
  final String createdAt;
  final String? profileImagePath;
  final String role;

  const AuthUser({
    required this.id,
    required this.fullName,
    required this.email,
    required this.createdAt,
    this.profileImagePath,
    required this.role,
  });

  bool get isAdmin => role == 'admin';

  factory AuthUser.fromJson(
    Map<String, dynamic> json,
  ) {
    return AuthUser(
      id: json['id'] as int,
      fullName: json['full_name'] as String,
      email: json['email'] as String,
      createdAt: json['created_at'].toString(),
      profileImagePath: json['profile_image_path']?.toString(),
      role: json['role']?.toString() ?? 'user',
    );
  }
}

class AuthResponse {
  final String message;
  final String accessToken;
  final String tokenType;
  final AuthUser user;

  const AuthResponse({
    required this.message,
    required this.accessToken,
    required this.tokenType,
    required this.user,
  });

  factory AuthResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return AuthResponse(
      message: json['message'] as String,
      accessToken: json['access_token'] as String,
      tokenType: json['token_type'] as String,
      user: AuthUser.fromJson(
        json['user'] as Map<String, dynamic>,
      ),
    );
  }
}
