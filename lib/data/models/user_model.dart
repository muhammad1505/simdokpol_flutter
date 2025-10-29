// lib/data/models/user_model.dart
import 'package:simdokpol_flutter/config/app_constants.dart';

class UserModel {
  int? id;
  String username;
  String passwordHash; // Disimpan sebagai hash
  String fullName;
  String role; // 'Super Admin' atau 'Operator'
  bool isActive;
  DateTime createdAt;
  DateTime updatedAt;

  UserModel({
    this.id,
    required this.username,
    required this.passwordHash,
    required this.fullName,
    this.role = AppConstants.roleOperator, // Default role
    this.isActive = true,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  // Konversi dari Map (dari database) ke objek UserModel
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      username: map['username'],
      passwordHash: map['password_hash'],
      fullName: map['full_name'],
      role: map['role'],
      isActive: map['is_active'] == 1, // Konversi int ke bool
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }

  // Konversi dari objek UserModel ke Map (untuk database)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password_hash': passwordHash,
      'full_name': fullName,
      'role': role,
      'is_active': isActive ? 1 : 0, // Konversi bool ke int
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'UserModel(id: $id, username: $username, fullName: $fullName, role: $role, isActive: $isActive)';
  }
}

