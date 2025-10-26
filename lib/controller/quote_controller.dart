import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:traderwho/core/services/notification_service.dart';
import 'package:traderwho/models/models.dart';

class QuoteController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  RxBool isLoading = false.obs;
  RxList<QuoteModel> quotes = <QuoteModel>[].obs;

  /// Submit a quote for a booking
  Future<bool> submitQuote({
    required String bookingId,
    required String customerId,
    required double quotedPrice,
    required String details,
  }) async {
    try {
      isLoading.value = true;

      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        Get.snackbar('Error', 'Please login to submit a quote');
        return false;
      }

      final quote = QuoteModel(
        bookingId: bookingId,
        traderId: currentUser.uid,
        customerId: customerId,
        quotedPrice: quotedPrice,
        details: details,
        status: 'pending',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Add quote to Firestore
      final docRef = await _firestore
          .collection('quotes')
          .add(quote.toFirestore());

      // Update quote with generated ID
      await docRef.update({'id': docRef.id});

      // DO NOT update booking status - keep it as 'pending' to allow multiple quotes
      // Booking status will be updated to 'accepted' only when customer accepts a quote
      print(
        '✅ Quote submitted for booking $bookingId, booking remains open for other quotes',
      );

      // Get booking info for job title
      String jobTitle = 'Job';
      try {
        final bookingDoc =
            await _firestore.collection('bookings').doc(bookingId).get();
        if (bookingDoc.exists) {
          final bookingData = bookingDoc.data();
          jobTitle =
              bookingData?['service'] ?? bookingData?['category'] ?? 'Job';
        }
      } catch (e) {
        print('⚠️ Warning: Could not fetch booking details for notification');
      }

      // Create notification for quote submission
      await NotificationService.createQuoteSubmittedNotification(
        customerId: customerId,
        bookingId: bookingId,
        quoteId: docRef.id,
        quotedPrice: quotedPrice,
        jobTitle: jobTitle,
      );

      Get.snackbar('Success', 'Quote submitted successfully');
      return true;
    } catch (e) {
      print('❌ Error submitting quote: $e');
      Get.snackbar('Error', 'Failed to submit quote');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Accept a quote
  Future<bool> acceptQuote(String quoteId) async {
    try {
      isLoading.value = true;

      // Get quote data for notification
      final quoteDoc = await _firestore.collection('quotes').doc(quoteId).get();
      if (!quoteDoc.exists) {
        Get.snackbar('Error', 'Quote not found');
        return false;
      }

      final quote = QuoteModel.fromFirestore(quoteDoc);

      // Update accepted quote status
      await _firestore.collection('quotes').doc(quoteId).update({
        'status': 'accepted',
        'updatedAt': DateTime.now(),
      });

      // Reject all other quotes for this booking
      try {
        final otherQuotesQuery =
            await _firestore
                .collection('quotes')
                .where('bookingId', isEqualTo: quote.bookingId)
                .where('status', isEqualTo: 'pending')
                .get();

        // Batch update all other pending quotes to rejected
        final batch = _firestore.batch();
        for (var doc in otherQuotesQuery.docs) {
          if (doc.id != quoteId) {
            // Don't reject the accepted quote
            batch.update(doc.reference, {
              'status': 'rejected',
              'updatedAt': DateTime.now(),
            });

            // Create rejection notification for other traders
            final otherQuote = QuoteModel.fromFirestore(doc);
            try {
              await NotificationService.createQuoteRejectedNotification(
                traderId: otherQuote.traderId,
                bookingId: otherQuote.bookingId,
                quoteId: doc.id,
                jobTitle: quote.details.isNotEmpty ? quote.details : 'Job',
              );
            } catch (e) {
              print('⚠️ Warning: Could not send rejection notification: $e');
            }
          }
        }
        await batch.commit();
        print('✅ Rejected ${otherQuotesQuery.docs.length - 1} other quotes');
      } catch (e) {
        print('❌ Error rejecting other quotes: $e');
        // Continue even if other quotes rejection fails
      }

      // Update booking with quoted price, assign trader, and mark as accepted
      try {
        await _firestore.collection('bookings').doc(quote.bookingId).update({
          'price': quote.quotedPrice,
          'status': 'accepted',
          'traderId': quote.traderId, // Assign the trader to the booking
          'updatedAt': DateTime.now().millisecondsSinceEpoch,
        });
        print(
          '✅ Updated booking ${quote.bookingId}: price=£${quote.quotedPrice}, status=accepted, traderId=${quote.traderId}',
        );
      } catch (e) {
        print('❌ Error updating booking: $e');
        // Continue with the process even if booking update fails
      }

      // Get booking info for job title
      String jobTitle = 'Job';
      try {
        final bookingDoc =
            await _firestore.collection('bookings').doc(quote.bookingId).get();
        if (bookingDoc.exists) {
          final bookingData = bookingDoc.data();
          jobTitle =
              bookingData?['service'] ?? bookingData?['category'] ?? 'Job';
        }
      } catch (e) {
        print('⚠️ Warning: Could not fetch booking details for notification');
      }

      // Create notification for accepted trader
      await NotificationService.createQuoteAcceptedNotification(
        traderId: quote.traderId,
        bookingId: quote.bookingId,
        quoteId: quoteId,
        jobTitle: jobTitle,
      );

      Get.snackbar(
        'Success',
        'Quote accepted! Price updated to £${quote.quotedPrice}',
      );
      return true;
    } catch (e) {
      print('❌ Error accepting quote: $e');
      Get.snackbar('Error', 'Failed to accept quote');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Reject a quote
  Future<bool> rejectQuote(String quoteId) async {
    try {
      isLoading.value = true;

      // Get quote data for notification
      final quoteDoc = await _firestore.collection('quotes').doc(quoteId).get();
      if (!quoteDoc.exists) {
        Get.snackbar('Error', 'Quote not found');
        return false;
      }

      final quote = QuoteModel.fromFirestore(quoteDoc);

      // Update quote status
      await _firestore.collection('quotes').doc(quoteId).update({
        'status': 'rejected',
        'updatedAt': DateTime.now(),
      });

      // Get booking info for job title
      String jobTitle = 'Job';
      try {
        final bookingDoc =
            await _firestore.collection('bookings').doc(quote.bookingId).get();
        if (bookingDoc.exists) {
          final bookingData = bookingDoc.data();
          jobTitle =
              bookingData?['service'] ?? bookingData?['category'] ?? 'Job';
        }
      } catch (e) {
        print('⚠️ Warning: Could not fetch booking details for notification');
      }

      // Create notification
      await NotificationService.createQuoteRejectedNotification(
        traderId: quote.traderId,
        bookingId: quote.bookingId,
        quoteId: quoteId,
        jobTitle: jobTitle,
      );

      Get.snackbar('Success', 'Quote rejected');
      return true;
    } catch (e) {
      print('❌ Error rejecting quote: $e');
      Get.snackbar('Error', 'Failed to reject quote');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Get existing quote for a booking by current trader
  Future<QuoteModel?> getExistingQuote(String bookingId) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return null;

      final querySnapshot =
          await _firestore
              .collection('quotes')
              .where('bookingId', isEqualTo: bookingId)
              .where('traderId', isEqualTo: currentUser.uid)
              .limit(1)
              .get();

      if (querySnapshot.docs.isNotEmpty) {
        return QuoteModel.fromFirestore(querySnapshot.docs.first);
      }

      return null;
    } catch (e) {
      print('❌ Error getting existing quote: $e');
      return null;
    }
  }

  /// Fetch quotes for current user
  Future<void> fetchQuotes() async {
    try {
      isLoading.value = true;

      final currentUser = _auth.currentUser;
      if (currentUser == null) return;

      // Fetch quotes where current user is either trader or customer
      final querySnapshot =
          await _firestore
              .collection('quotes')
              .where('traderId', isEqualTo: currentUser.uid)
              .orderBy('createdAt', descending: true)
              .get();

      quotes.value =
          querySnapshot.docs
              .map((doc) => QuoteModel.fromFirestore(doc))
              .toList();
    } catch (e) {
      print('❌ Error fetching quotes: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Get all quotes for a specific booking (for customer to view)
  Future<List<QuoteModel>> getQuotesForBooking(String bookingId) async {
    try {
      final querySnapshot =
          await _firestore
              .collection('quotes')
              .where('bookingId', isEqualTo: bookingId)
              .where('status', isEqualTo: 'pending') // Only show pending quotes
              .orderBy('createdAt', descending: false) // Oldest first
              .get();

      return querySnapshot.docs
          .map((doc) => QuoteModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('❌ Error getting quotes for booking: $e');
      return [];
    }
  }

  /// Get count of pending quotes for a booking
  Future<int> getQuoteCountForBooking(String bookingId) async {
    try {
      final querySnapshot =
          await _firestore
              .collection('quotes')
              .where('bookingId', isEqualTo: bookingId)
              .where('status', isEqualTo: 'pending')
              .get();

      return querySnapshot.docs.length;
    } catch (e) {
      print('❌ Error getting quote count: $e');
      return 0;
    }
  }
}
