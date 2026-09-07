class Report {
  final int id;
  final String incidentType;
  final String description;
  final String? additionalDetails;
  final String referenceNumber;
  final String status;
  final String createdAt;

  const Report({
    required this.id,
    required this.incidentType,
    required this.description,
    required this.additionalDetails,
    required this.referenceNumber,
    required this.status,
    required this.createdAt,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['id'] as int,
      incidentType: json['incident_type'] as String,
      description: json['description'] as String,
      additionalDetails: json['additional_details'] as String?,
      referenceNumber: json['reference_number'] as String,
      status: json['status'] as String,
      createdAt: json['created_at'].toString(),
    );
  }
}
