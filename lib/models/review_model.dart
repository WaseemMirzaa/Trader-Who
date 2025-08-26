import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  final String reviewerName;
  final String comment;
  final double rating;
  final DateTime createdAt;

  ReviewModel({
    required this.reviewerName,
    required this.comment,
    required this.rating,
    required this.createdAt,
  });

  factory ReviewModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ReviewModel(
      reviewerName: data['reviewerName'] ?? '',
      comment: data['comment'] ?? '',
      rating: (data['rating'] ?? 0).toDouble(),
      createdAt:
          data['createdAt'] is Timestamp
              ? (data['createdAt'] as Timestamp).toDate()
              : (data['createdAt'] is int
                  ? DateTime.fromMillisecondsSinceEpoch(
                    data['createdAt'] as int,
                  )
                  : DateTime.now()),
    );
  }
}
