// lib/data/repositories/auth_repository_impl.dart
import 'package:sqflite/sqflite.dart';
import 'package:crypto/crypto.dart'; // Untuk hashing password
import 'dart:convert'; // Untuk utf8

import 'package:simdokpol_flutter/data/datasources/database_helper.dart';
import 'package:simdokpol_flutter/data/models/user_model.dart';
import 'package:simdokpol_flutter/data/repositories/auth_repository.dart';
import 'package:simdokpol_flutter/config/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Untuk menyimpan status login

class AuthRepositoryImpl implements AuthRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  // Untuk menyimpan user ID yang sedang login
  final SharedPreferences _prefs;

  AuthRepositoryImpl(this._prefs);

  String _hashPassword(String password) {
    var bytes = utf8.encode(password); // data being hashed
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  @override
  Future<UserModel?> login(String username, String password) async {
    final db = await _dbHelper.database;
    final hashedPassword = _hashPassword(password);

    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'username = ? AND password_hash = ? AND is_active = ?',
      whereArgs: [username, hashedPassword, 1],
    );

    if (maps.isNotEmpty) {
      final user = UserModel.fromMap(maps.first);
      await _prefs.setInt(AppConstants.prefLoggedInUser, user.id!); // Simpan ID user di shared preferences
      return user;
    }
    return null;
  }

  @override
  Future<UserModel> registerSuperAdmin(String username, String password, String fullName) async {
    final db = await _dbHelper.database;
    final hashedPassword = _hashPassword(password);
    final now = DateTime.now();

    final user = UserModel(
      username: username,
      passwordHash: hashedPassword,
      fullName: fullName,
      role: AppConstants.roleSuperAdmin,
      createdAt: now,
      updatedAt: now,
    );

    final id = await db.insert('users', user.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    user.id = id;
    await _prefs.setInt(AppConstants.prefLoggedInUser, id); // Log in Super Admin setelah register
    return user;
  }

  @override
  Future<void> logout() async {
    await _prefs.remove(AppConstants.prefLoggedInUser);
    // Mungkin juga ingin membersihkan sesi lain jika ada
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final userId = _prefs.getInt(AppConstants.prefLoggedInUser);
    if (userId == null) {
      return null;
    }
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'id = ? AND is_active = ?',
      whereArgs: [userId, 1],
    );
    if (maps.isNotEmpty) {
      return UserModel.fromMap(maps.first);
    }
    return null;
  }

  @override
  Future<bool> hasSuperAdmin() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'role = ?',
      whereArgs: [AppConstants.roleSuperAdmin],
      limit: 1,
    );
    return maps.isNotEmpty;
  }
}

