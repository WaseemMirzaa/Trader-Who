import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:traderou/models/models.dart';

class CustomJobPostController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  RxBool isLoading = false.obs;
  RxBool isCreatingPost = false.obs;
  RxString postStatus = ''.obs;

  // Image selection variables
  final ImagePicker _imagePicker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  RxList<XFile> selectedImages = <XFile>[].obs;
  RxBool isUploadingImages = false.obs;

  // Preferred time selection variables
  Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  Rx<TimeOfDay?> selectedTime = Rx<TimeOfDay?>(null);
  RxString preferredTimeDisplay = ''.obs;

  /// Select images for custom job post
  Future<void> selectImages() async {
    try {
      final pickedFiles = await _imagePicker.pickMultiImage(
        imageQuality: 80,
        maxWidth: 1920,
        maxHeight: 1080,
      );

      if (pickedFiles.isNotEmpty) {
        selectedImages.addAll(pickedFiles);
        print('✅ Selected ${pickedFiles.length} images');
      }
    } catch (e) {
      print('❌ Error selecting images: $e');
    }
  }

  /// Remove an image from selected images
  void removeImage(int index) {
    if (index >= 0 && index < selectedImages.length) {
      selectedImages.removeAt(index);
      print('✅ Removed image at index $index');
    }
  }

  /// Clear all selected images
  void clearImages() {
    selectedImages.clear();
  }

  /// Upload images to Firebase Storage
  Future<List<String>> uploadImages(String postId) async {
    final imageUrls = <String>[];

    try {
      isUploadingImages.value = true;

      for (int i = 0; i < selectedImages.length; i++) {
        final file = File(selectedImages[i].path);
        final fileName = 'custom_job_$postId/image_$i.jpg';
        final ref = _storage.ref().child(fileName);

        final uploadTask = await ref.putFile(file);
        final url = await uploadTask.ref.getDownloadURL();
        imageUrls.add(url);

        print('✅ Uploaded image ${i + 1}/${selectedImages.length}');
      }
    } catch (e) {
      print('❌ Error uploading images: $e');
    } finally {
      isUploadingImages.value = false;
    }

    return imageUrls;
  }

  /// Select preferred date for custom job
  Future<void> selectPreferredDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );

    if (pickedDate != null) {
      selectedDate.value = pickedDate;
      // Automatically open time picker after date is selected
      _selectPreferredTime(context);
    }
  }

  /// Select preferred time for custom job
  Future<void> _selectPreferredTime(BuildContext context) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      selectedTime.value = pickedTime;
      _updatePreferredTimeDisplay();
    }
  }

  /// Update the display of preferred time
  void _updatePreferredTimeDisplay() {
    if (selectedDate.value != null && selectedTime.value != null) {
      final formattedDate = DateFormat(
        'dd/MM/yyyy',
      ).format(selectedDate.value!);
      final formattedTime = selectedTime.value!.format(Get.context!);
      preferredTimeDisplay.value = '$formattedDate, $formattedTime';
      print('📅 Preferred time set: ${preferredTimeDisplay.value}');
    }
  }

  /// Create a custom job post
  /// This creates a booking with empty traderId so any trader can quote
  Future<bool> createCustomJobPost({
    required String category,
    required String service,
    required String jobType,
    required double price,
    required String notes,
    required double latitude,
    required double longitude,
  }) async {
    try {
      isCreatingPost.value = true;

      // Get current user
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        return false;
      }

      // Create booking model with empty traderId
      final booking = BookingModel(
        createdAt: DateTime.now(),
        userId: currentUser.uid,
        traderId: '', // Empty for custom jobs - any trader can quote
        category: category,
        service: service,
        jobType: jobType,
        notes: notes,
        preferredTime:
            selectedDate.value != null && selectedTime.value != null
                ? DateTime(
                  selectedDate.value!.year,
                  selectedDate.value!.month,
                  selectedDate.value!.day,
                  selectedTime.value!.hour,
                  selectedTime.value!.minute,
                )
                : null,
        price: price,
        latitude: latitude,
        longitude: longitude,
        status: 'pending', // Waiting for quotes
        rating: 0.0,
        review: '',
        images: [],
      );

      // Save to Firestore
      final docRef = await _firestore
          .collection('bookings')
          .add(booking.toFirestore());

      if (docRef.id.isNotEmpty) {
        // Upload images if any are selected
        List<String> imageUrls = [];
        if (selectedImages.isNotEmpty) {
          print('📸 Uploading ${selectedImages.length} images...');
          imageUrls = await uploadImages(docRef.id);

          // Update the booking document with image URLs
          if (imageUrls.isNotEmpty) {
            await docRef.update({'images': imageUrls});
            print('✅ Images uploaded and booking updated with URLs');
          }
        }

        postStatus.value = 'Custom job posted successfully!';
        print('✅ Custom job post created with ID: ${docRef.id}');
        print(
          '📊 Post details: Category: $category, Service: $service, JobType: $jobType',
        );

        // Reset form
        clearImages();
        selectedDate.value = null;
        selectedTime.value = null;
        preferredTimeDisplay.value = '';

        return true;
      }

      return false;
    } catch (e) {
      print('❌ Error creating custom job post: $e');

      return false;
    } finally {
      isCreatingPost.value = false;
    }
  }

  /// Get quotes for a custom job post
  Stream<List<QuoteModel>> getQuotesForPost(String postId) {
    return _firestore
        .collection('quotes')
        .where('bookingId', isEqualTo: postId)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => QuoteModel.fromFirestore(doc))
              .toList();
        });
  }

  /// Accept a quote and update the booking with the trader ID
  Future<bool> acceptQuote(
    String quoteId,
    String postId,
    String traderId,
  ) async {
    try {
      isLoading.value = true;

      // Update the quote to accepted
      await _firestore.collection('quotes').doc(quoteId).update({
        'status': 'accepted',
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      });

      // Update the booking with the trader ID
      await _firestore.collection('bookings').doc(postId).update({
        'traderId': traderId,
        'status': 'accepted', // Quote accepted, now it's a confirmed booking
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      });

      // Reject all other quotes for this post
      final otherQuotes =
          await _firestore
              .collection('quotes')
              .where('bookingId', isEqualTo: postId)
              .where('status', isEqualTo: 'pending')
              .get();

      for (final quote in otherQuotes.docs) {
        if (quote.id != quoteId) {
          await quote.reference.update({
            'status': 'rejected',
            'updatedAt': DateTime.now().millisecondsSinceEpoch,
          });
        }
      }

      return true;
    } catch (e) {
      print('❌ Error accepting quote: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Reject a quote
  Future<bool> rejectQuote(String quoteId) async {
    try {
      isLoading.value = true;

      await _firestore.collection('quotes').doc(quoteId).update({
        'status': 'rejected',
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      });

      return true;
    } catch (e) {
      print('❌ Error rejecting quote: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Get custom job posts created by current user
  Stream<List<BookingModel>> getMyCustomJobPosts() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return Stream.value([]);

    return _firestore
        .collection('bookings')
        .where('userId', isEqualTo: userId)
        .where(
          'traderId',
          isEqualTo: '',
        ) // Only custom posts (no trader assigned yet)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => BookingModel.fromFirestore(doc))
              .toList();
        });
  }

  /// Get all available custom job posts for traders to quote on
  Stream<List<BookingModel>> getAvailableCustomJobPosts() {
    return _firestore
        .collection('bookings')
        .where('traderId', isEqualTo: '') // Only custom posts without trader
        .where('status', isEqualTo: 'pending') // Only pending posts
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => BookingModel.fromFirestore(doc))
              .toList();
        });
  }

  /// Submit a quote for a custom job post
  Future<bool> submitQuote({
    required String postId,
    required double quotedPrice,
    required String details,
  }) async {
    try {
      isLoading.value = true;

      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        return false;
      }

      // Get the booking to find customer ID
      final bookingDoc =
          await _firestore.collection('bookings').doc(postId).get();
      if (!bookingDoc.exists) {
        return false;
      }

      final booking = BookingModel.fromFirestore(bookingDoc);

      // Create quote
      final quote = QuoteModel(
        bookingId: postId,
        traderId: currentUser.uid,
        customerId: booking.userId,
        quotedPrice: quotedPrice,
        details: details,
        status: 'pending',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        expiresAt: DateTime.now().add(const Duration(days: 7)), // 7-day expiry
      );

      // Save to Firestore
      await _firestore.collection('quotes').add(quote.toFirestore());

      Get.snackbar(
        'Success',
        'Quote submitted successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      return true;
    } catch (e) {
      print('❌ Error submitting quote: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
