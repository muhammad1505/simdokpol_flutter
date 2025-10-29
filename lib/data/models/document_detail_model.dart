// lib/data/models/document_detail_model.dart
class DocumentDetailModel {
  int? id;
  int documentId;
  String fieldName; // Nama field spesifik (misalnya 'lost_item_description', 'police_report_number')
  String? fieldValue; // Nilai dari field tersebut

  DocumentDetailModel({
    this.id,
    required this.documentId,
    required this.fieldName,
    this.fieldValue,
  });

  factory DocumentDetailModel.fromMap(Map<String, dynamic> map) {
    return DocumentDetailModel(
      id: map['id'],
      documentId: map['document_id'],
      fieldName: map['field_name'],
      fieldValue: map['field_value'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'document_id': documentId,
      'field_name': fieldName,
      'field_value': fieldValue,
    };
  }

  @override
  String toString() {
    return 'DocumentDetailModel(id: $id, documentId: $documentId, fieldName: $fieldName, fieldValue: $fieldValue)';
  }
}

