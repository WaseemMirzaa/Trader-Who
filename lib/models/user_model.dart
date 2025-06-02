import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? id;
  final String name;
  final String email;
  final String? phone;
  final String? address;
  final double? lat;
  final double? lon;
  final String? image;
  final String? password;
  final String? userType;
  final List<String>? fcmTokens;
  final String? stripeCustomerId;
  final String? stripeConnectId;
  final DateTime? createdAt;

  // Tradesperson specific fields
  final String? title;
  final String? bio;
  final String? status;
  final bool? availability;
  final DateTime? startTime;
  final DateTime? endTime;

  // Customer specific fields
  final String? username;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    this.phone,
    this.address,
    this.lat,
    this.lon,
    this.image,
    this.password,
    this.userType,
    this.fcmTokens,
    this.stripeCustomerId,
    this.stripeConnectId,
    this.createdAt,
    // Tradesperson fields
    this.title,
    this.bio,
    this.status,
    this.availability,
    this.startTime,
    this.endTime,
    // Customer fields
    this.username,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? address,
    double? lat,
    double? lon,
    String? image,
    String? password,
    String? userType,
    List<String>? fcmTokens,
    String? stripeCustomerId,
    String? stripeConnectId,
    DateTime? createdAt,
    // Tradesperson fields
    String? title,
    String? bio,
    String? status,
    bool? availability,
    DateTime? startTime,
    DateTime? endTime,
    // Customer fields
    String? username,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      image: image ?? this.image,
      password: password ?? this.password,
      userType: userType ?? this.userType,
      fcmTokens: fcmTokens ?? this.fcmTokens,
      stripeCustomerId: stripeCustomerId ?? this.stripeCustomerId,
      stripeConnectId: stripeConnectId ?? this.stripeConnectId,
      createdAt: createdAt ?? this.createdAt,
      // Tradesperson fields
      title: title ?? this.title,
      bio: bio ?? this.bio,
      status: status ?? this.status,
      availability: availability ?? this.availability,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      // Customer fields
      username: username ?? this.username,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      if (id != null) 'id': id,
      'name': name,
      'email': email,
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address,
      if (lat != null) 'lat': lat,
      if (lon != null) 'lon': lon,
      if (image != null) 'image': image,
      if (password != null) 'password': password,
      if (userType != null) 'user_type': userType,
      if (fcmTokens != null) 'fcm_tokens': fcmTokens,
      if (stripeCustomerId != null) 'stripe_customer_id': stripeCustomerId,
      if (stripeConnectId != null) 'stripe_connect_id': stripeConnectId,
      if (createdAt != null) 'created_at': createdAt?.millisecondsSinceEpoch,
      // Tradesperson fields (only include if not null)
      if (title != null) 'title': title,
      if (bio != null) 'bio': bio,
      if (status != null) 'status': status,
      if (availability != null) 'availability': availability,
      if (startTime != null) 'start_time': startTime?.millisecondsSinceEpoch,
      if (endTime != null) 'end_time': endTime?.millisecondsSinceEpoch,
      // Customer fields (only include if not null)
      if (username != null) 'username': username,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String?,
      name: map['name'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String?,
      address: map['address'] as String?,
      lat: (map['lat'] as num?)?.toDouble(),
      lon: (map['lon'] as num?)?.toDouble(),
      image: map['image'] as String?,
      password: map['password'] as String?,
      userType: map['user_type'] as String?,
      fcmTokens:
          map['fcm_tokens'] != null
              ? List<String>.from(map['fcm_tokens'] as List<dynamic>)
              : null,
      stripeCustomerId: map['stripe_customer_id'] as String?,
      stripeConnectId: map['stripe_connect_id'] as String?,
      createdAt:
          map['created_at'] != null
              ? DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int)
              : null,
      // Tradesperson fields
      title: map['title'] as String?,
      bio: map['bio'] as String?,
      status: map['status'] as String?,
      availability: map['availability'] as bool?,
      startTime:
          map['start_time'] != null
              ? DateTime.fromMillisecondsSinceEpoch(map['start_time'] as int)
              : null,
      endTime:
          map['end_time'] != null
              ? DateTime.fromMillisecondsSinceEpoch(map['end_time'] as int)
              : null,
      // Customer fields
      username: map['username'] as String?,
    );
  }

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'],
      address: data['address'],
      lat: (data['lat'] as num?)?.toDouble(),
      lon: (data['lon'] as num?)?.toDouble(),
      image: data['image'],
      password: data['password'],
      userType: data['user_type'],
      fcmTokens:
          data['fcm_tokens'] != null
              ? List<String>.from(data['fcm_tokens'] as List<dynamic>)
              : null,
      stripeCustomerId: data['stripe_customer_id'],
      stripeConnectId: data['stripe_connect_id'],
      createdAt:
          data['created_at'] != null
              ? (data['created_at'] is Timestamp
                  ? (data['created_at'] as Timestamp).toDate()
                  : DateTime.fromMillisecondsSinceEpoch(
                    data['created_at'] as int,
                  ))
              : null,
      // Tradesperson fields
      title: data['title'],
      bio: data['bio'],
      status: data['status'],
      availability: data['availability'],
      startTime:
          data['start_time'] != null
              ? (data['start_time'] is Timestamp
                  ? (data['start_time'] as Timestamp).toDate()
                  : DateTime.fromMillisecondsSinceEpoch(
                    data['start_time'] as int,
                  ))
              : null,
      endTime:
          data['end_time'] != null
              ? (data['end_time'] is Timestamp
                  ? (data['end_time'] as Timestamp).toDate()
                  : DateTime.fromMillisecondsSinceEpoch(
                    data['end_time'] as int,
                  ))
              : null,
      // Customer fields
      username: data['username'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, phone: $phone, address: $address, lat: $lat, lon: $lon, image: $image, password: $password, userType: $userType, fcmTokens: $fcmTokens, stripeCustomerId: $stripeCustomerId, stripeConnectId: $stripeConnectId, createdAt: $createdAt, title: $title, bio: $bio, status: $status, availability: $availability, startTime: $startTime, endTime: $endTime, username: $username)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.email == email &&
        other.phone == phone &&
        other.address == address &&
        other.lat == lat &&
        other.lon == lon &&
        other.image == image &&
        other.password == password &&
        other.userType == userType &&
        other.fcmTokens == fcmTokens &&
        other.stripeCustomerId == stripeCustomerId &&
        other.stripeConnectId == stripeConnectId &&
        other.createdAt == createdAt &&
        other.title == title &&
        other.bio == bio &&
        other.status == status &&
        other.availability == availability &&
        other.startTime == startTime &&
        other.endTime == endTime &&
        other.username == username;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        address.hashCode ^
        lat.hashCode ^
        lon.hashCode ^
        image.hashCode ^
        password.hashCode ^
        userType.hashCode ^
        fcmTokens.hashCode ^
        stripeCustomerId.hashCode ^
        stripeConnectId.hashCode ^
        createdAt.hashCode ^
        title.hashCode ^
        bio.hashCode ^
        status.hashCode ^
        availability.hashCode ^
        startTime.hashCode ^
        endTime.hashCode ^
        username.hashCode;
  }
}
