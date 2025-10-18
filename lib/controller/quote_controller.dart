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

      // Update booking status to 'quoted' after quote submission
      try {
        await _firestore.collection('bookings').doc(bookingId).update({
          'status': 'quoted',
          'updatedAt': DateTime.now().millisecondsSinceEpoch,
        });
        print('✅ Updated booking $bookingId status to quoted');
      } catch (e) {
        print('❌ Error updating booking status: $e');
        // Continue with the process even if booking update fails
      }

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

      // Update quote status
      await _firestore.collection('quotes').doc(quoteId).update({
        'status': 'accepted',
        'updatedAt': DateTime.now(),
      });

      // Update booking price with the quoted price
      try {
        await _firestore.collection('bookings').doc(quote.bookingId).update({
          'price': quote.quotedPrice,
          'status': 'accepted',
          'updatedAt': DateTime.now().millisecondsSinceEpoch,
        });
        print(
          '✅ Updated booking ${quote.bookingId} price to £${quote.quotedPrice} and status to accepted',
        );
      } catch (e) {
        print('❌ Error updating booking price: $e');
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

      // Create notification
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
}
