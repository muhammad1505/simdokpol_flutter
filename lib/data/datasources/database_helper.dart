// lib/data/datasources/database_helper.dart
import 'dart:async';
import 'dart:io'; // Digunakan untuk Platform

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // Penting untuk Desktop
import 'package:simdokpol_flutter/config/app_constants.dart'; // Import AppConstants

class DatabaseHelper {
  // Singleton instance untuk memastikan hanya ada satu instance database helper
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  // Getter untuk instance database
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDb();
    return _database!;
  }

  // Inisialisasi database
  Future<Database> _initDb() async {
    // Inisialisasi FFI (Foreign Function Interface) untuk dukungan desktop
    // Ini harus dipanggil sebelum openDatabase jika di platform desktop
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    // Dapatkan path untuk database
    // getDatabasesPath() akan mengembalikan path yang sesuai untuk setiap OS
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, AppConstants.databaseName);

    // Buka database, jika tidak ada akan dibuat
    return await openDatabase(
      path,
      version: AppConstants.databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onConfigure: _onConfigure, // Untuk mengaktifkan Foreign Key
    );
  }

  // Method yang dipanggil saat database pertama kali dibuat
  void _onCreate(Database db, int version) async {
    // === Skema Database Berdasarkan Repositori Go SIMDOKPOL ===
    // Mengadaptasi dari internal/models/ dan migrations/ Anda.

    // 1. users Table (dari internal/models/user.go & migrations)
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE,
        password_hash TEXT NOT NULL,
        full_name TEXT NOT NULL,
        role TEXT NOT NULL, -- 'Super Admin' atau 'Operator'
        is_active INTEGER DEFAULT 1, -- 1 for true, 0 for false
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // 2. documents Table (dari internal/models/document.go & migrations)
    // Ini adalah tabel umum untuk semua jenis surat keterangan.
    await db.execute('''
      CREATE TABLE documents (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT NOT NULL, -- Contoh: 'SKCK', 'Surat Kehilangan', dll.
        document_number TEXT UNIQUE, -- Nomor surat, bisa null awalnya
        title TEXT NOT NULL,
        content TEXT, -- Konten utama surat
        issued_date TEXT,
        applicant_name TEXT,
        applicant_address TEXT,
        applicant_nik TEXT,
        status TEXT NOT NULL DEFAULT 'Draft', -- 'Draft', 'Issued', 'Cancelled'
        created_by INTEGER NOT NULL,
        updated_by INTEGER NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE CASCADE,
        FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE CASCADE
      )
    ''');

    // 3. audit_logs Table (dari internal/models/audit_log.go & migrations)
    await db.execute('''
      CREATE TABLE audit_logs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        action TEXT NOT NULL, -- 'Login', 'Create Document', 'Update User', dll.
        entity_type TEXT, -- 'User', 'Document', dll.
        entity_id INTEGER,
        description TEXT,
        created_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
      )
    ''');

    // 4. document_details Table (untuk detail spesifik per jenis dokumen)
    // Contoh untuk surat kehilangan (disesuaikan dari internal/models/document_loss.go)
    await db.execute('''
      CREATE TABLE document_details (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        document_id INTEGER NOT NULL,
        field_name TEXT NOT NULL,
        field_value TEXT,
        FOREIGN KEY (document_id) REFERENCES documents(id) ON DELETE CASCADE,
        UNIQUE (document_id, field_name)
      )
    ''');

    // 5. configuration Table (untuk KOP surat, nama kantor, dll. dari Go config)
    await db.execute('''
      CREATE TABLE configurations (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        key TEXT NOT NULL UNIQUE,
        value TEXT
      )
    ''');

    // === Tambahkan data awal (jika diperlukan) ===
    // Contoh: super admin pertama pada first launch
    // Ini akan ditangani oleh initial_setup_page
    // Insert initial configurations (KOP surat, nama kantor)
  }

  // Method yang dipanggil saat database di-upgrade (versi berubah)
  void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Logika migrasi database di sini
    // Contoh:
    // if (oldVersion < 2) {
    //   await db.execute("ALTER TABLE users ADD COLUMN email TEXT;");
    // }
    // if (oldVersion < 3) {
    //   await db.execute("CREATE TABLE new_table (...)");
    // }
  }

  // Method yang dipanggil saat database sedang dikonfigurasi
  // Penting untuk mengaktifkan Foreign Key secara manual di SQLite
  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  // Method untuk menutup database
  Future<void> closeDb() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}

