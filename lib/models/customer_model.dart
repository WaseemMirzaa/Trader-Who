import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerModel {
  final String? id;
  final String? username;
  final DateTime? createdAt;
  final String? userId;

  CustomerModel({this.id, this.username, this.createdAt, this.userId});

  CustomerModel copyWith({
    String? id,
    String? username,
    DateTime? createdAt,
    String? userId,
  }) {
    return CustomerModel(
      id: id ?? this.id,
      username: username ?? this.username,
      createdAt: createdAt ?? this.createdAt,
      userId: userId ?? this.userId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      if (id != null) 'id': id,
      'username': username,
      'created_at': createdAt?.millisecondsSinceEpoch,
      'user_id': userId,
    };
  }

  factory CustomerModel.fromMap(Map<String, dynamic> map) {
    return CustomerModel(
      id: map['id'] as String?,
      username: map['username'] as String?,
      createdAt:
          map['created_at'] != null
              ? DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int)
              : null,
      userId: map['user_id'] as String?,
    );
  }

  factory CustomerModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CustomerModel(
      id: doc.id,
      username: data['username'],
      createdAt:
          data['created_at'] != null
              ? (data['created_at'] as Timestamp).toDate()
              : null,
      userId: data['user_id'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CustomerModel.fromJson(String source) =>
      CustomerModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CustomerModel(id: $id, username: $username, createdAt: $createdAt, userId: $userId)';
  }

  @override
  bool operator ==(covariant CustomerModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.username == username &&
        other.createdAt == createdAt &&
        other.userId == userId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        username.hashCode ^
        createdAt.hashCode ^
        userId.hashCode;
  }
}
