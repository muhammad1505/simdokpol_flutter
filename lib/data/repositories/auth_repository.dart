// lib/data/repositories/auth_repository.dart
import 'package:simdokpol_flutter/data/models/user_model.dart';

abstract class AuthRepository {
  Future<UserModel?> login(String username, String password);
  Future<UserModel> registerSuperAdmin(String username, String password, String fullName);
  Future<void> logout();
  Future<UserModel?> getCurrentUser();
  Future<bool> hasSuperAdmin(); // Untuk cek apakah sudah ada Super Admin terdaftar
}

