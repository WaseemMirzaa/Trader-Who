import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class TradePeopleModel {
  final String? id;
  final String? title;
  final String? bio;
  final String userId;
  final String? status;
  final DateTime? createdAt;
  final bool? availability;
  final DateTime? startTime;
  final DateTime? endTime;

  TradePeopleModel({
    this.id,
    this.title,
    this.bio,
    required this.userId,
    this.status,
    this.createdAt,
    this.availability,
    this.startTime,
    this.endTime,
  });

  TradePeopleModel copyWith({
    String? id,
    String? title,
    String? bio,
    String? userId,
    String? status,
    DateTime? createdAt,
    bool? availability,
    DateTime? startTime,
    DateTime? endTime,
  }) {
    return TradePeopleModel(
      id: id ?? this.id,
      title: title ?? this.title,
      bio: bio ?? this.bio,
      userId: userId ?? this.userId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      availability: availability ?? this.availability,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      if (id != null) 'id': id,
      'title': title,
      'bio': bio,
      'user_id': userId,
      'status': status,
      'created_at': createdAt?.millisecondsSinceEpoch,
      'availability': availability,
      'start_time': startTime?.millisecondsSinceEpoch,
      'end_time': endTime?.millisecondsSinceEpoch,
    };
  }

  factory TradePeopleModel.fromMap(Map<String, dynamic> map) {
    return TradePeopleModel(
      id: map['id'] as String?,
      title: map['title'] as String?,
      bio: map['bio'] as String?,
      userId: map['user_id'] as String,
      status: map['status'] as String?,
      createdAt:
          map['created_at'] != null
              ? DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int)
              : null,
      availability: map['availability'] as bool?,
      startTime:
          map['start_time'] != null
              ? DateTime.fromMillisecondsSinceEpoch(map['start_time'] as int)
              : null,
      endTime:
          map['end_time'] != null
              ? DateTime.fromMillisecondsSinceEpoch(map['end_time'] as int)
              : null,
    );
  }

  factory TradePeopleModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TradePeopleModel(
      id: doc.id,
      title: data['title'],
      bio: data['bio'],
      userId: data['user_id'] ?? '',
      status: data['status'],
      createdAt:
          data['created_at'] != null
              ? (data['created_at'] is Timestamp
                  ? (data['created_at'] as Timestamp).toDate()
                  : (data['created_at'] is int
                      ? DateTime.fromMillisecondsSinceEpoch(
                        data['created_at'] as int,
                      )
                      : DateTime.now()))
              : null,
      availability: data['availability'],
      startTime:
          data['start_time'] != null
              ? (data['start_time'] is Timestamp
                  ? (data['start_time'] as Timestamp).toDate()
                  : (data['start_time'] is int
                      ? DateTime.fromMillisecondsSinceEpoch(
                        data['start_time'] as int,
                      )
                      : null))
              : null,
      endTime:
          data['end_time'] != null
              ? (data['end_time'] is Timestamp
                  ? (data['end_time'] as Timestamp).toDate()
                  : (data['end_time'] is int
                      ? DateTime.fromMillisecondsSinceEpoch(
                        data['end_time'] as int,
                      )
                      : null))
              : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory TradePeopleModel.fromJson(String source) =>
      TradePeopleModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TradePeopleModel(id: $id, title: $title, bio: $bio, userId: $userId, status: $status, createdAt: $createdAt, availability: $availability, startTime: $startTime, endTime: $endTime)';
  }

  @override
  bool operator ==(covariant TradePeopleModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.bio == bio &&
        other.userId == userId &&
        other.status == status &&
        other.createdAt == createdAt &&
        other.availability == availability &&
        other.startTime == startTime &&
        other.endTime == endTime;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        bio.hashCode ^
        userId.hashCode ^
        status.hashCode ^
        createdAt.hashCode ^
        availability.hashCode ^
        startTime.hashCode ^
        endTime.hashCode;
  }
}

class OccupationModel {
  final String? id;
  final String? title;
  final double? price;
  final int? tradePeopleId;
  final DateTime? createdAt;

  OccupationModel({
    this.id,
    this.title,
    this.price,
    this.tradePeopleId,
    this.createdAt,
  });

  OccupationModel copyWith({
    String? id,
    String? title,
    double? price,
    int? tradePeopleId,
    DateTime? createdAt,
  }) {
    return OccupationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      tradePeopleId: tradePeopleId ?? this.tradePeopleId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      if (id != null) 'id': id,
      'title': title,
      'price': price,
      'trade_people_id': tradePeopleId,
      'created_at': createdAt?.millisecondsSinceEpoch,
    };
  }

  factory OccupationModel.fromMap(Map<String, dynamic> map) {
    return OccupationModel(
      id: map['id'] as String?,
      title: map['title'] as String?,
      price: (map['price'] as num?)?.toDouble(),
      tradePeopleId: map['trade_people_id'] as int?,
      createdAt:
          map['created_at'] != null
              ? DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int)
              : null,
    );
  }

  factory OccupationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return OccupationModel(
      id: doc.id,
      title: data['title'],
      price: (data['price'] as num?)?.toDouble(),
      tradePeopleId: data['trade_people_id'],
      createdAt:
          data['created_at'] != null
              ? (data['created_at'] is Timestamp
                  ? (data['created_at'] as Timestamp).toDate()
                  : (data['created_at'] is int
                      ? DateTime.fromMillisecondsSinceEpoch(
                        data['created_at'] as int,
                      )
                      : DateTime.now()))
              : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory OccupationModel.fromJson(String source) =>
      OccupationModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'OccupationModel(id: $id, title: $title, price: $price, tradePeopleId: $tradePeopleId, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant OccupationModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.price == price &&
        other.tradePeopleId == tradePeopleId &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        price.hashCode ^
        tradePeopleId.hashCode ^
        createdAt.hashCode;
  }
}
