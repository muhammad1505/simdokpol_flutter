// lib/data/models/audit_log_model.dart
class AuditLogModel {
  int? id;
  int userId;
  String action; // 'Login', 'Create Document', 'Update User', dll.
  String? entityType; // 'User', 'Document', 'Configuration'
  int? entityId; // ID dari entitas yang terpengaruh
  String? description; // Deskripsi lebih detail tentang aksi
  DateTime createdAt;

  AuditLogModel({
    this.id,
    required this.userId,
    required this.action,
    this.entityType,
    this.entityId,
    this.description,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory AuditLogModel.fromMap(Map<String, dynamic> map) {
    return AuditLogModel(
      id: map['id'],
      userId: map['user_id'],
      action: map['action'],
      entityType: map['entity_type'],
      entityId: map['entity_id'],
      description: map['description'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'action': action,
      'entity_type': entityType,
      'entity_id': entityId,
      'description': description,
      'created_at': createdAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'AuditLogModel(id: $id, userId: $userId, action: $action, entityType: $entityType, entityId: $entityId)';
  }
}

