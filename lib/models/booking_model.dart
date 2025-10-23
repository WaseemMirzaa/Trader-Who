part of 'models.dart';

class BookingModel {
  final String? id;
  final DateTime? createdAt;
  final List<String> images;
  final double latitude;
  final double longitude;
  final String notes;
  final DateTime? preferredTime;
  final double price;
  final double rating;
  final String review;
  final String status;
  final String traderId;
  final DateTime? updatedAt;
  final String userId;
  final String category;
  final String service;
  final String jobType;
  final List<String>
  completionImages; // Images uploaded by trader on completion
  final String customerComment; // Customer feedback on trader's completion
  final bool customerApproved; // Whether customer approved the completion
  final int? traderRating; // Customer's rating for trader
  final String? traderReview; // Customer's review for trader
  final int? customerRating; // Trader's rating for customer
  final String? customerReview; // Trader's review for customer

  BookingModel({
    this.id,
    this.createdAt,
    this.images = const [],
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.notes = '',
    this.preferredTime,
    this.price = 0.0,
    this.rating = 0.0,
    this.review = '',
    this.status = '',
    this.traderId = '',
    this.updatedAt,
    this.userId = '',
    this.category = '',
    this.service = '',
    this.jobType = '',
    this.completionImages = const [],
    this.customerComment = '',
    this.customerApproved = false,
    this.traderRating,
    this.traderReview,
    this.customerRating,
    this.customerReview,
  });

  BookingModel copyWith({
    String? id,
    DateTime? createdAt,
    List<String>? images,
    double? latitude,
    double? longitude,
    String? notes,
    DateTime? preferredTime,
    double? price,
    double? rating,
    String? review,
    String? status,
    String? traderId,
    DateTime? updatedAt,
    String? userId,
    String? category,
    String? service,
    String? jobType,
    List<String>? completionImages,
    String? customerComment,
    bool? customerApproved,
    int? traderRating,
    String? traderReview,
    int? customerRating,
    String? customerReview,
  }) {
    return BookingModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      images: images ?? this.images,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      notes: notes ?? this.notes,
      preferredTime: preferredTime ?? this.preferredTime,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      review: review ?? this.review,
      status: status ?? this.status,
      traderId: traderId ?? this.traderId,
      updatedAt: updatedAt ?? this.updatedAt,
      userId: userId ?? this.userId,
      category: category ?? this.category,
      service: service ?? this.service,
      jobType: jobType ?? this.jobType,
      completionImages: completionImages ?? this.completionImages,
      customerComment: customerComment ?? this.customerComment,
      customerApproved: customerApproved ?? this.customerApproved,
      traderRating: traderRating ?? this.traderRating,
      traderReview: traderReview ?? this.traderReview,
      customerRating: customerRating ?? this.customerRating,
      customerReview: customerReview ?? this.customerReview,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'images': images,
      'location': [latitude, longitude], // GeoPoint format: [lat, lon]
      'notes': notes,
      'preferredTime': preferredTime?.millisecondsSinceEpoch,
      'price': price,
      'rating': rating,
      'review': review,
      'status': status,
      'traderId': traderId,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
      'userId': userId,
      'category': category,
      'service': service,
      'jobType': jobType,
    };
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (id != null) 'id': id,
      'createdAt':
          createdAt != null
              ? createdAt!.millisecondsSinceEpoch
              : DateTime.now().millisecondsSinceEpoch,
      'images': images,
      'location': GeoPoint(latitude, longitude), // Firestore GeoPoint
      'notes': notes,
      'preferredTime': preferredTime?.millisecondsSinceEpoch,
      'price': price,
      'rating': rating,
      'review': review,
      'status': status,
      'traderId': traderId,
      'updatedAt':
          updatedAt != null
              ? updatedAt!.millisecondsSinceEpoch
              : DateTime.now().millisecondsSinceEpoch,
      'userId': userId,
      'category': category,
      'service': service,
      'jobType': jobType,
      'completionImages': completionImages,
      'customerComment': customerComment,
      'customerApproved': customerApproved,
      if (traderRating != null) 'traderRating': traderRating,
      if (traderReview != null) 'traderReview': traderReview,
      if (customerRating != null) 'customerRating': customerRating,
      if (customerReview != null) 'customerReview': customerReview,
    };
  }

  factory BookingModel.fromMap(Map<String, dynamic> map) {
    // Handle location field which can be either GeoPoint or List
    double lat = 0.0;
    double lon = 0.0;

    if (map['location'] != null) {
      if (map['location'] is GeoPoint) {
        final geoPoint = map['location'] as GeoPoint;
        lat = geoPoint.latitude;
        lon = geoPoint.longitude;
      } else if (map['location'] is List &&
          (map['location'] as List).length >= 2) {
        final locationList = map['location'] as List;
        lat = (locationList[0] as num?)?.toDouble() ?? 0.0;
        lon = (locationList[1] as num?)?.toDouble() ?? 0.0;
      }
    }

    return BookingModel(
      id: map['id'] as String,
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
      images:
          map['images'] != null
              ? List<String>.from(map['images'] as List<dynamic>)
              : [],
      latitude: lat,
      longitude: lon,
      notes: map['notes'] as String? ?? '',
      preferredTime:
          map['preferredTime'] != null
              ? (map['preferredTime'] is Timestamp
                  ? (map['preferredTime'] as Timestamp).toDate()
                  : (map['preferredTime'] is int
                      ? DateTime.fromMillisecondsSinceEpoch(
                        map['preferredTime'],
                      )
                      : null))
              : null,
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      review: map['review'] as String? ?? '',
      status: map['status'] as String? ?? '',
      traderId: map['traderId'] as String? ?? '',
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
      userId: map['userId'] as String? ?? '',
      category: map['category'] as String? ?? '',
      service: map['service'] as String? ?? '',
      jobType: map['jobType'] as String? ?? '',
      completionImages:
          map['completionImages'] != null
              ? List<String>.from(map['completionImages'] as List<dynamic>)
              : [],
      customerComment: map['customerComment'] as String? ?? '',
      customerApproved: map['customerApproved'] as bool? ?? false,
      traderRating: map['traderRating'] as int?,
      traderReview: map['traderReview'] as String?,
      customerRating: map['customerRating'] as int?,
      customerReview: map['customerReview'] as String?,
    );
  }

  factory BookingModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BookingModel.fromMap({
      ...data,
      'id': doc.id, // Ensure Firestore doc id is used
    });
  }

  String toJson() => json.encode(toMap());

  factory BookingModel.fromJson(String source) =>
      BookingModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BookingModel(id: $id, createdAt: $createdAt, images: $images, latitude: $latitude, longitude: $longitude, notes: $notes, preferredTime: $preferredTime, price: $price, rating: $rating, review: $review, status: $status, traderId: $traderId, updatedAt: $updatedAt, userId: $userId, category: $category, service: $service, jobType: $jobType)';
  }

  @override
  bool operator ==(covariant BookingModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.createdAt == createdAt &&
        other.images == images &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.notes == notes &&
        other.preferredTime == preferredTime &&
        other.price == price &&
        other.rating == rating &&
        other.review == review &&
        other.status == status &&
        other.traderId == traderId &&
        other.updatedAt == updatedAt &&
        other.userId == userId &&
        other.category == category &&
        other.service == service &&
        other.jobType == jobType;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        createdAt.hashCode ^
        images.hashCode ^
        latitude.hashCode ^
        longitude.hashCode ^
        notes.hashCode ^
        preferredTime.hashCode ^
        price.hashCode ^
        rating.hashCode ^
        review.hashCode ^
        status.hashCode ^
        traderId.hashCode ^
        updatedAt.hashCode ^
        userId.hashCode ^
        category.hashCode ^
        service.hashCode ^
        jobType.hashCode;
  }
}
