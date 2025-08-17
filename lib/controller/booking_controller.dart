import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traderwho/controller/user_controller.dart';
import 'package:traderwho/core/theme/app_color.dart';
import 'package:traderwho/models/models.dart';

class BookingController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  RxBool isLoading = false.obs;
  RxBool isBookingCreated = false.obs;
  RxString bookingStatus = ''.obs;

  /// Create a new booking
  Future<bool> createBooking({
    required String traderId,
    required String category,
    required String service,
    required String jobType,
    String notes = '',
    DateTime? preferredTime,
    required double price,
    required double latitude,
    required double longitude,
  }) async {
    try {
      isLoading.value = true;

      // Get current user
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        Get.snackbar(
          'Error',
          'Please login to create a booking',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }

      // Check if user is a customer (only customers can create bookings)
      final isCustomer = await _checkIfUserIsCustomer(currentUser.uid);
      if (!isCustomer) {
        Get.snackbar(
          'Access Denied',
          'Only customers can create bookings. Traders cannot book services.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );
        return false;
      }

      // Create booking model
      final booking = BookingModel(
        createdAt: DateTime.now(),
        userId: currentUser.uid,
        traderId: traderId,
        category: category,
        service: service,
        jobType: jobType,
        notes: notes,
        preferredTime: preferredTime,
        price: price,
        latitude: latitude,
        longitude: longitude,
        status: 'pending', // Initial status
        rating: 0.0,
        review: '',
        images: [],
      );

      // Save to Firestore
      final docRef = await _firestore
          .collection('bookings')
          .add(booking.toFirestore());

      if (docRef.id.isNotEmpty) {
        isBookingCreated.value = true;
        bookingStatus.value = 'Booking created successfully!';

        Get.snackbar(
          'Success',
          'Booking created successfully! The trader will be notified.',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );

        print('✅ Booking created with ID: ${docRef.id}');
        print(
          '📊 Booking details: Category: $category, Service: $service, JobType: $jobType',
        );

        return true;
      }

      return false;
    } catch (e) {
      print('❌ Error creating booking: $e');

      Get.snackbar(
        'Error',
        'Failed to create booking. Please try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Get user's bookings
  Future<List<BookingModel>> getUserBookings() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return [];

      final querySnapshot =
          await _firestore
              .collection('bookings')
              .where('userId', isEqualTo: currentUser.uid)
              .orderBy('createdAt', descending: true)
              .get();

      return querySnapshot.docs
          .map((doc) => BookingModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('❌ Error fetching user bookings: $e');
      return [];
    }
  }

  /// Get trader's bookings
  Future<List<BookingModel>> getTraderBookings() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return [];

      final querySnapshot =
          await _firestore
              .collection('bookings')
              .where('traderId', isEqualTo: currentUser.uid)
              .orderBy('createdAt', descending: true)
              .get();

      return querySnapshot.docs
          .map((doc) => BookingModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('❌ Error fetching trader bookings: $e');
      return [];
    }
  }

  /// Update booking status
  Future<bool> updateBookingStatus(String bookingId, String status) async {
    try {
      await _firestore.collection('bookings').doc(bookingId).update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      Get.snackbar(
        'Success',
        'Booking status updated to $status',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      return true;
    } catch (e) {
      print('❌ Error updating booking status: $e');

      Get.snackbar(
        'Error',
        'Failed to update booking status',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

      return false;
    }
  }

  /// Show booking confirmation dialog
  Future<void> showBookingDialog({
    required String traderName,
    required String traderId,
    required String category,
    required String service,
    required String jobType,
    required double price,
  }) async {
    // Check if current user is a customer before showing dialog
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      Get.snackbar(
        'Error',
        'Please login to create a booking',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final isCustomer = await _checkIfUserIsCustomer(currentUser.uid);
    if (!isCustomer) {
      Get.snackbar(
        'Access Denied',
        'Only customers can create bookings. Traders cannot book services.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
      return;
    }

    final TextEditingController notesController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: Text('Book $traderName'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Category: $category'),
              const SizedBox(height: 8),
              Text('Service: $service'),
              const SizedBox(height: 8),
              Text('Job Type: $jobType'),

              const SizedBox(height: 8),
              Text("Price: $price"),
              const SizedBox(height: 8),
              TextField(
                controller: notesController,
                decoration: const InputDecoration(
                  labelText: 'Additional Notes (Optional)',
                  labelStyle: TextStyle(color: AppColor.primaryText),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.orangeCustomColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.orangeCustomColor),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.primaryText),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.primaryText),
                  ),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColor.primaryText),
            ),
          ),
          Obx(
            () => ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isLoading.value ? Colors.grey : AppColor.orangeCustomColor,
              ),
              onPressed:
                  isLoading.value
                      ? null
                      : () async {
                        UserController userController = Get.find();
                        final success = await createBooking(
                          traderId: traderId,
                          category: category,
                          service: service,
                          jobType: jobType,
                          notes: notesController.text.trim(),
                          latitude: userController.latitude.value,
                          longitude: userController.longitude.value,
                          price: price,
                        );

                        if (success) {
                          Get.back();
                          Get.back();
                          // Close dialog
                        }
                      },
              child:
                  isLoading.value
                      ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                      : const Text('Confirm Booking'),
            ),
          ),
        ],
      ),
    );
  }

  /// Check if the current user is a customer (not a trader)
  Future<bool> _checkIfUserIsCustomer(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();

      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;
        final userType = userData['user_type'] as String?;

        // Only customers can create bookings
        // If user_type is null, assume customer for backward compatibility
        return userType == null || userType == 'customer';
      }

      // If document doesn't exist, assume customer for backward compatibility
      return true;
    } catch (e) {
      print('❌ Error checking user type: $e');
      // In case of error, assume customer to not block functionality
      return true;
    }
  }

  /// Reset controller state
  void resetState() {
    isLoading.value = false;
    isBookingCreated.value = false;
    bookingStatus.value = '';
  }
}
