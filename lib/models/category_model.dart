import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  final String id;
  final String name;
  final String? iconUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CategoryModel({
    required this.id,
    required this.name,
    this.iconUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory CategoryModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CategoryModel(
      id: doc.id,
      name: data['name'] ?? '',
      iconUrl: data['iconUrl'],
      createdAt: data['createdAt']?.toDate(),
      updatedAt: data['updatedAt']?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'iconUrl': iconUrl,
      'createdAt':
          createdAt != null
              ? Timestamp.fromDate(createdAt!)
              : FieldValue.serverTimestamp(),
      'updatedAt':
          updatedAt != null
              ? Timestamp.fromDate(updatedAt!)
              : FieldValue.serverTimestamp(),
    };
  }
}
