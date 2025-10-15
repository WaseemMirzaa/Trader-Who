part of 'models.dart';

class JobModel {
  final String id;
  final String title;
  final String categoryId;
  final String categoryName;
  final String jobType; // 'small' or 'large'
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isCustom;
  final double? price;
  final bool isEnabled;

  JobModel({
    required this.id,
    required this.title,
    required this.categoryId,
    required this.categoryName,
    required this.jobType,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.isCustom = false,
    this.price,
    this.isEnabled = false,
  });

  factory JobModel.fromMap(Map<String, dynamic> map, String id) {
    return JobModel(
      id: id,
      title: map['title'] ?? '',
      categoryId: map['categoryId'] ?? '',
      categoryName: map['categoryName'] ?? '',
      jobType: map['jobType'] ?? 'small',
      description: map['description'],
      createdAt: map['createdAt']?.toDate(),
      updatedAt: map['updatedAt']?.toDate(),
      isCustom: map['isCustom'] ?? false,
      price: map['price'] != null ? (map['price'] as num).toDouble() : null,
      isEnabled: map['isEnabled'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'jobType': jobType,
      'description': description,
      'createdAt':
          createdAt != null
              ? Timestamp.fromDate(createdAt!)
              : FieldValue.serverTimestamp(),
      'updatedAt':
          updatedAt != null
              ? Timestamp.fromDate(updatedAt!)
              : FieldValue.serverTimestamp(),
      'isCustom': isCustom,
      'isEnabled': isEnabled,
      if (price != null) 'price': price,
    };
  }

  JobModel copyWith({
    String? id,
    String? title,
    String? categoryId,
    String? categoryName,
    String? jobType,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isCustom,
    double? price,
    bool? isEnabled,
  }) {
    return JobModel(
      id: id ?? this.id,
      title: title ?? this.title,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      jobType: jobType ?? this.jobType,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isCustom: isCustom ?? this.isCustom,
      price: price ?? this.price,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }
}
