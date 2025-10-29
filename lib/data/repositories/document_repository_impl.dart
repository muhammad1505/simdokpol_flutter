// lib/data/repositories/document_repository_impl.dart
import 'package:sqflite/sqflite.dart';
import 'package:simdokpol_flutter/data/datasources/database_helper.dart';
import 'package:simdokpol_flutter/data/models/document_model.dart';
import 'package:simdokpol_flutter/data/models/document_detail_model.dart';
import 'package:simdokpol_flutter/data/repositories/document_repository.dart';

class DocumentRepositoryImpl implements DocumentRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  Future<DocumentModel> createDocument(DocumentModel document, {List<DocumentDetailModel>? details}) async {
    final db = await _dbHelper.database;
    final now = DateTime.now();
    document.createdAt = now;
    document.updatedAt = now;

    int documentId = await db.insert('documents', document.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    document.id = documentId;

    if (details != null && details.isNotEmpty) {
      for (var detail in details) {
        detail.documentId = documentId;
        await db.insert('document_details', detail.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
      }
    }
    return document;
  }

  @override
  Future<DocumentModel?> getDocumentById(int id) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'documents',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return DocumentModel.fromMap(maps.first);
    }
    return null;
  }

  @override
  Future<List<DocumentModel>> getAllDocuments() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('documents', orderBy: 'updated_at DESC');
    return List.generate(maps.length, (i) {
      return DocumentModel.fromMap(maps[i]);
    });
  }

  @override
  Future<List<DocumentModel>> getDocumentsByType(String type) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'documents',
      where: 'type = ?',
      whereArgs: [type],
      orderBy: 'updated_at DESC',
    );
    return List.generate(maps.length, (i) {
      return DocumentModel.fromMap(maps[i]);
    });
  }

  @override
  Future<List<DocumentDetailModel>> getDocumentDetails(int documentId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'document_details',
      where: 'document_id = ?',
      whereArgs: [documentId],
    );
    return List.generate(maps.length, (i) {
      return DocumentDetailModel.fromMap(maps[i]);
    });
  }

  @override
  Future<void> updateDocument(DocumentModel document, {List<DocumentDetailModel>? details}) async {
    final db = await _dbHelper.database;
    document.updatedAt = DateTime.now();

    await db.update(
      'documents',
      document.toMap(),
      where: 'id = ?',
      whereArgs: [document.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    if (details != null) {
      // Hapus detail lama, lalu masukkan yang baru (sederhana untuk saat ini)
      // Pendekatan lebih baik: update jika ada, insert jika baru, delete jika hilang
      await db.delete(
        'document_details',
        where: 'document_id = ?',
        whereArgs: [document.id],
      );
      for (var detail in details) {
        detail.documentId = document.id!;
        await db.insert('document_details', detail.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
      }
    }
  }

  @override
  Future<void> deleteDocument(int id) async {
    final db = await _dbHelper.database;
    // Karena ada ON DELETE CASCADE di FOREIGN KEY, document_details akan ikut terhapus
    await db.delete(
      'documents',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<DocumentModel> duplicateDocument(int originalDocumentId, int createdByUserId) async {
    final originalDocument = await getDocumentById(originalDocumentId);
    if (originalDocument == null) {
      throw Exception('Original document not found');
    }

    // Buat salinan dokumen dengan ID baru dan status draft
    final newDocument = DocumentModel(
      type: originalDocument.type,
      title: originalDocument.title,
      content: originalDocument.content,
      applicantName: originalDocument.applicantName,
      applicantAddress: originalDocument.applicantAddress,
      applicantNik: originalDocument.applicantNik,
      status: 'Draft', // Status harus Draft saat duplikasi
      createdBy: createdByUserId,
      updatedBy: createdByUserId,
    );

    // Ambil detail dokumen asli
    final originalDetails = await getDocumentDetails(originalDocumentId);

    // Buat dokumen baru di database
    final createdDocument = await createDocument(newDocument);

    // Salin detail dokumen asli ke dokumen baru
    if (originalDetails.isNotEmpty) {
      List<DocumentDetailModel> newDetails = originalDetails.map((detail) {
        return DocumentDetailModel(
          documentId: createdDocument.id!,
          fieldName: detail.fieldName,
          fieldValue: detail.fieldValue,
        );
      }).toList();
      // Perbarui dokumen yang baru dibuat dengan detail ini
      await updateDocument(createdDocument, details: newDetails);
    }

    return createdDocument;
  }
}



