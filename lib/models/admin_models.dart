class AdminDashboardStats {
  final int totalUsers;
  final int totalReports;
  final int totalSecurityChecks;
  final int scamChecks;
  final int phishingChecks;
  final int highRiskChecks;
  final int suspiciousChecks;
  final int pendingReports;

  const AdminDashboardStats({
    required this.totalUsers,
    required this.totalReports,
    required this.totalSecurityChecks,
    required this.scamChecks,
    required this.phishingChecks,
    required this.highRiskChecks,
    required this.suspiciousChecks,
    required this.pendingReports,
  });

  factory AdminDashboardStats.fromJson(
    Map<String, dynamic> json,
  ) {
    return AdminDashboardStats(
      totalUsers: (json['total_users'] as num?)?.toInt() ?? 0,
      totalReports: (json['total_reports'] as num?)?.toInt() ?? 0,
      totalSecurityChecks:
          (json['total_security_checks'] as num?)?.toInt() ?? 0,
      scamChecks: (json['scam_checks'] as num?)?.toInt() ?? 0,
      phishingChecks: (json['phishing_checks'] as num?)?.toInt() ?? 0,
      highRiskChecks: (json['high_risk_checks'] as num?)?.toInt() ?? 0,
      suspiciousChecks: (json['suspicious_checks'] as num?)?.toInt() ?? 0,
      pendingReports: (json['pending_reports'] as num?)?.toInt() ?? 0,
    );
  }
}

class AdminUser {
  final int id;
  final String fullName;
  final String email;
  final String role;
  final String createdAt;
  final String? profileImagePath;

  const AdminUser({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    required this.createdAt,
    this.profileImagePath,
  });

  bool get isAdmin => role == 'admin';

  factory AdminUser.fromJson(
    Map<String, dynamic> json,
  ) {
    return AdminUser(
      id: (json['id'] as num).toInt(),
      fullName: json['full_name']?.toString() ?? 'Unknown user',
      email: json['email']?.toString() ?? '',
      role: json['role']?.toString() ?? 'user',
      createdAt: json['created_at']?.toString() ?? '',
      profileImagePath: json['profile_image_path']?.toString(),
    );
  }
}

class AdminReport {
  final int id;
  final String referenceNumber;
  final String incidentType;
  final String description;
  final String? additionalDetails;
  final String status;
  final String createdAt;
  final int evidenceCount;
  final int userId;
  final String userName;
  final String userEmail;

  const AdminReport({
    required this.id,
    required this.referenceNumber,
    required this.incidentType,
    required this.description,
    this.additionalDetails,
    required this.status,
    required this.createdAt,
    required this.evidenceCount,
    required this.userId,
    required this.userName,
    required this.userEmail,
  });

  factory AdminReport.fromJson(
    Map<String, dynamic> json,
  ) {
    final user = json['user'] as Map<String, dynamic>? ?? {};

    return AdminReport(
      id: (json['id'] as num).toInt(),
      referenceNumber: json['reference_number']?.toString() ?? '',
      incidentType: json['incident_type']?.toString() ?? 'Unknown',
      description: json['description']?.toString() ?? '',
      additionalDetails: json['additional_details']?.toString(),
      status: json['status']?.toString() ?? 'submitted',
      createdAt: json['created_at']?.toString() ?? '',
      evidenceCount: (json['evidence_count'] as num?)?.toInt() ?? 0,
      userId: (user['id'] as num?)?.toInt() ?? 0,
      userName: user['full_name']?.toString() ?? 'Unknown user',
      userEmail: user['email']?.toString() ?? '',
    );
  }

  AdminReport copyWith({
    String? status,
  }) {
    return AdminReport(
      id: id,
      referenceNumber: referenceNumber,
      incidentType: incidentType,
      description: description,
      additionalDetails: additionalDetails,
      status: status ?? this.status,
      createdAt: createdAt,
      evidenceCount: evidenceCount,
      userId: userId,
      userName: userName,
      userEmail: userEmail,
    );
  }
}
