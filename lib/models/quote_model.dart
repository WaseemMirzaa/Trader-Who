part of 'models.dart';

class QuoteModel {
  final String? id;
  final String bookingId;
  final String traderId;
  final String customerId;
  final double quotedPrice;
  final String details;
  final String status; // 'pending', 'accepted', 'rejected', 'expired'
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? expiresAt;

  QuoteModel({
    this.id,
    required this.bookingId,
    required this.traderId,
    required this.customerId,
    required this.quotedPrice,
    required this.details,
    this.status = 'pending',
    this.createdAt,
    this.updatedAt,
    this.expiresAt,
  });

  QuoteModel copyWith({
    String? id,
    String? bookingId,
    String? traderId,
    String? customerId,
    double? quotedPrice,
    String? details,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? expiresAt,
  }) {
    return QuoteModel(
      id: id ?? this.id,
      bookingId: bookingId ?? this.bookingId,
      traderId: traderId ?? this.traderId,
      customerId: customerId ?? this.customerId,
      quotedPrice: quotedPrice ?? this.quotedPrice,
      details: details ?? this.details,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'bookingId': bookingId,
      'traderId': traderId,
      'customerId': customerId,
      'quotedPrice': quotedPrice,
      'details': details,
      'status': status,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
      'expiresAt': expiresAt?.millisecondsSinceEpoch,
    };
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (id != null) 'id': id,
      'bookingId': bookingId,
      'traderId': traderId,
      'customerId': customerId,
      'quotedPrice': quotedPrice,
      'details': details,
      'status': status,
      'createdAt':
          createdAt != null
              ? createdAt!.millisecondsSinceEpoch
              : DateTime.now().millisecondsSinceEpoch,
      'updatedAt':
          updatedAt != null
              ? updatedAt!.millisecondsSinceEpoch
              : DateTime.now().millisecondsSinceEpoch,
      'expiresAt': expiresAt?.millisecondsSinceEpoch,
    };
  }

  factory QuoteModel.fromMap(Map<String, dynamic> map) {
    return QuoteModel(
      id: map['id'] as String?,
      bookingId: map['bookingId'] as String,
      traderId: map['traderId'] as String,
      customerId: map['customerId'] as String,
      quotedPrice: (map['quotedPrice'] as num).toDouble(),
      details: map['details'] as String,
      status: map['status'] as String? ?? 'pending',
      createdAt:
          map['createdAt'] != null
              ? (map['createdAt'] is Timestamp
                  ? (map['createdAt'] as Timestamp).toDate()
                  : (map['createdAt'] is int
                      ? DateTime.fromMillisecondsSinceEpoch(
                        map['createdAt'] as int,
                      )
                      : DateTime.now()))
              : null,
      updatedAt:
          map['updatedAt'] != null
              ? (map['updatedAt'] is Timestamp
                  ? (map['updatedAt'] as Timestamp).toDate()
                  : (map['updatedAt'] is int
                      ? DateTime.fromMillisecondsSinceEpoch(
                        map['updatedAt'] as int,
                      )
                      : DateTime.now()))
              : null,
      expiresAt:
          map['expiresAt'] != null
              ? (map['expiresAt'] is Timestamp
                  ? (map['expiresAt'] as Timestamp).toDate()
                  : (map['expiresAt'] is int
                      ? DateTime.fromMillisecondsSinceEpoch(
                        map['expiresAt'] as int,
                      )
                      : null))
              : null,
    );
  }

  factory QuoteModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return QuoteModel.fromMap({...data, 'id': doc.id});
  }

  @override
  String toString() {
    return 'QuoteModel(id: $id, bookingId: $bookingId, traderId: $traderId, customerId: $customerId, quotedPrice: $quotedPrice, details: $details, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, expiresAt: $expiresAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is QuoteModel &&
        other.id == id &&
        other.bookingId == bookingId &&
        other.traderId == traderId &&
        other.customerId == customerId &&
        other.quotedPrice == quotedPrice &&
        other.details == details &&
        other.status == status;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        bookingId.hashCode ^
        traderId.hashCode ^
        customerId.hashCode ^
        quotedPrice.hashCode ^
        details.hashCode ^
        status.hashCode;
  }
}
