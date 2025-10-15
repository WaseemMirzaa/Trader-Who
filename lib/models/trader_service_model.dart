import 'package:cloud_firestore/cloud_firestore.dart';

class TraderServiceModel {
  final String id;
  final String traderId;
  final String jobId;
  final String categoryId;
  final String categoryName;
  final String jobTitle;
  final String jobType;
  final double? price;
  final bool isEnabled;
  final bool isCustom;
  final String? customTitle;
  final String? customDescription;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  TraderServiceModel({
    required this.id,
    required this.traderId,
    required this.jobId,
    required this.categoryId,
    required this.categoryName,
    required this.jobTitle,
    required this.jobType,
    this.price,
    this.isEnabled = true,
    this.isCustom = false,
    this.customTitle,
    this.customDescription,
    this.createdAt,
    this.updatedAt,
  });

  factory TraderServiceModel.fromMap(Map<String, dynamic> map, String id) {
    return TraderServiceModel(
      id: id,
      traderId: map['traderId'] ?? '',
      jobId: map['jobId'] ?? '',
      categoryId: map['categoryId'] ?? '',
      categoryName: map['categoryName'] ?? '',
      jobTitle: map['jobTitle'] ?? '',
      jobType: map['jobType'] ?? 'small',
      price: map['price']?.toDouble(),
      isEnabled: map['isEnabled'] ?? true,
      isCustom: map['isCustom'] ?? false,
      customTitle: map['customTitle'],
      customDescription: map['customDescription'],
      createdAt: map['createdAt']?.toDate(),
      updatedAt: map['updatedAt']?.toDate(),
    );
  }

  TraderServiceModel copyWith({
    String? id,
    String? traderId,
    String? jobId,
    String? categoryId,
    String? categoryName,
    String? jobTitle,
    String? jobType,
    double? price,
    bool? isEnabled,
    bool? isCustom,
    String? customTitle,
    String? customDescription,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TraderServiceModel(
      id: id ?? this.id,
      traderId: traderId ?? this.traderId,
      jobId: jobId ?? this.jobId,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      jobTitle: jobTitle ?? this.jobTitle,
      jobType: jobType ?? this.jobType,
      price: price ?? this.price,
      isEnabled: isEnabled ?? this.isEnabled,
      isCustom: isCustom ?? this.isCustom,
      customTitle: customTitle ?? this.customTitle,
      customDescription: customDescription ?? this.customDescription,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'traderId': traderId,
      'jobId': jobId,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'jobTitle': jobTitle,
      'jobType': jobType,
      'price': price,
      'isEnabled': isEnabled,
      'isCustom': isCustom,
      'customTitle': customTitle,
      'customDescription': customDescription,
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
