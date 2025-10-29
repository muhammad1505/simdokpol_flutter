// lib/data/models/document_model.dart
class DocumentModel {
  int? id;
  String type; // Contoh: 'SKCK', 'Surat Kehilangan', 'Surat Tugas'
  String? documentNumber; // Nomor surat, bisa null awalnya
  String title;
  String? content; // Konten utama surat
  DateTime? issuedDate;
  String? applicantName;
  String? applicantAddress;
  String? applicantNik;
  String status; // 'Draft', 'Issued', 'Cancelled'
  int createdBy;
  int updatedBy;
  DateTime createdAt;
  DateTime updatedAt;

  DocumentModel({
    this.id,
    required this.type,
    this.documentNumber,
    required this.title,
    this.content,
    this.issuedDate,
    this.applicantName,
    this.applicantAddress,
    this.applicantNik,
    this.status = 'Draft', // Default status
    required this.createdBy,
    required this.updatedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  factory DocumentModel.fromMap(Map<String, dynamic> map) {
    return DocumentModel(
      id: map['id'],
      type: map['type'],
      documentNumber: map['document_number'],
      title: map['title'],
      content: map['content'],
      issuedDate: map['issued_date'] != null ? DateTime.parse(map['issued_date']) : null,
      applicantName: map['applicant_name'],
      applicantAddress: map['applicant_address'],
      applicantNik: map['applicant_nik'],
      status: map['status'],
      createdBy: map['created_by'],
      updatedBy: map['updated_by'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'document_number': documentNumber,
      'title': title,
      'content': content,
      'issued_date': issuedDate?.toIso8601String(),
      'applicant_name': applicantName,
      'applicant_address': applicantAddress,
      'applicant_nik': applicantNik,
      'status': status,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'DocumentModel(id: $id, type: $type, title: $title, status: $status)';
  }
}

