import 'package:cloud_firestore/cloud_firestore.dart';

/// Service to calculate and update user ratings from bookings
class RatingService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Calculate average trader rating from all bookings
  /// Returns the average rating and total number of ratings
  static Future<(double rating, int count)> calculateTraderRating(
    String traderId,
  ) async {
    try {
      final bookingsQuery =
          await _firestore
              .collection('bookings')
              .where('traderId', isEqualTo: traderId)
              .where('traderRating', isNotEqualTo: null)
              .get();

      if (bookingsQuery.docs.isEmpty) {
        return (0.0, 0);
      }

      int totalRatings = 0;
      double sumRatings = 0.0;

      for (var doc in bookingsQuery.docs) {
        final rating = doc.data()['traderRating'];
        if (rating != null && rating > 0) {
          sumRatings += (rating as int).toDouble();
          totalRatings++;
        }
      }

      if (totalRatings == 0) {
        return (0.0, 0);
      }

      final averageRating = sumRatings / totalRatings;
      return (averageRating, totalRatings);
    } catch (e) {
      print('❌ Error calculating trader rating: $e');
      return (0.0, 0);
    }
  }

  /// Calculate average customer rating from all bookings
  /// Returns the average rating and total number of ratings
  static Future<(double rating, int count)> calculateCustomerRating(
    String customerId,
  ) async {
    try {
      final bookingsQuery =
          await _firestore
              .collection('bookings')
              .where('userId', isEqualTo: customerId)
              .where('customerRating', isNotEqualTo: null)
              .get();

      if (bookingsQuery.docs.isEmpty) {
        return (0.0, 0);
      }

      int totalRatings = 0;
      double sumRatings = 0.0;

      for (var doc in bookingsQuery.docs) {
        final rating = doc.data()['customerRating'];
        if (rating != null && rating > 0) {
          sumRatings += (rating as int).toDouble();
          totalRatings++;
        }
      }

      if (totalRatings == 0) {
        return (0.0, 0);
      }

      final averageRating = sumRatings / totalRatings;
      return (averageRating, totalRatings);
    } catch (e) {
      print('❌ Error calculating customer rating: $e');
      return (0.0, 0);
    }
  }

  /// Update trader's rating in users collection
  static Future<void> updateTraderRating(String traderId) async {
    try {
      final (rating, count) = await calculateTraderRating(traderId);

      await _firestore.collection('users').doc(traderId).update({
        'rating': rating,
        'totalRatings': count,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      print('✅ Updated trader rating: $rating ($count ratings)');
    } catch (e) {
      print('❌ Error updating trader rating: $e');
    }
  }

  /// Update customer's rating in users collection
  static Future<void> updateCustomerRating(String customerId) async {
    try {
      final (rating, count) = await calculateCustomerRating(customerId);

      await _firestore.collection('users').doc(customerId).update({
        'customerRating': rating,
        'totalCustomerRatings': count,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      print('✅ Updated customer rating: $rating ($count ratings)');
    } catch (e) {
      print('❌ Error updating customer rating: $e');
    }
  }

  /// Update both trader and customer ratings after a review is submitted
  static Future<void> updateRatingsAfterReview({
    required String traderId,
    required String customerId,
  }) async {
    await Future.wait([
      updateTraderRating(traderId),
      updateCustomerRating(customerId),
    ]);
  }
}
