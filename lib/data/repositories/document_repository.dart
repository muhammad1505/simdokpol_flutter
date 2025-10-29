// lib/data/repositories/document_repository.dart
import 'package:simdokpol_flutter/data/models/document_model.dart';
import 'package:simdokpol_flutter/data/models/document_detail_model.dart';

abstract class DocumentRepository {
  Future<DocumentModel> createDocument(DocumentModel document, {List<DocumentDetailModel>? details});
  Future<DocumentModel?> getDocumentById(int id);
  Future<List<DocumentModel>> getAllDocuments();
  Future<List<DocumentModel>> getDocumentsByType(String type);
  Future<List<DocumentDetailModel>> getDocumentDetails(int documentId);
  Future<void> updateDocument(DocumentModel document, {List<DocumentDetailModel>? details});
  Future<void> deleteDocument(int id);
  Future<DocumentModel> duplicateDocument(int originalDocumentId, int createdByUserId);
}

