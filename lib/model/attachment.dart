class Attachment {
  final String id;
  final String fileName;
  final String fileUrl;
  final DateTime uploadedAt;

  Attachment({
    required this.id,
    required this.fileName,
    required this.fileUrl,
    required this.uploadedAt,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) {
    return Attachment(
      id: json['id'],
      fileName: json['fileName'],
      fileUrl: json['fileUrl'],
      uploadedAt: DateTime.parse(json['uploadedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fileName': fileName,
      'fileUrl': fileUrl,
      'uploadedAt': uploadedAt.toLocal(),
    };
  }
}
