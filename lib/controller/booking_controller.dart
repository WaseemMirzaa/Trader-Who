import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:traderwho/controller/chat_controller.dart';
import 'package:traderwho/controller/job_history_page_controller.dart';
import 'package:traderwho/controller/job_post_controller.dart';
import 'package:traderwho/controller/navigation_controller.dart';
import 'package:traderwho/core/services/notification_service.dart';
import 'package:traderwho/core/theme/app_color.dart';
import 'package:traderwho/models/models.dart';

class BookingController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  RxBool isLoading = false.obs;
  RxBool isBookingCreated = false.obs;
  RxString bookingStatus = ''.obs;

  // Preferred time selection variables
  Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  Rx<TimeOfDay?> selectedTime = Rx<TimeOfDay?>(null);
  RxString preferredTimeDisplay = ''.obs;

  // Trader's available time range
  Rx<TimeOfDay?> traderStartTime = Rx<TimeOfDay?>(null);
  Rx<TimeOfDay?> traderEndTime = Rx<TimeOfDay?>(null);

  // Image selection variables
  final ImagePicker _imagePicker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  RxList<XFile> selectedImages = <XFile>[].obs;
  RxBool isUploadingImages = false.obs;

  /// Select preferred date for booking
  Future<void> selectPreferredDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(
        const Duration(days: 1),
      ), // Tomorrow as minimum
      firstDate: DateTime.now().add(
        const Duration(days: 1),
      ), // Can't book for today
      lastDate: DateTime.now().add(
        const Duration(days: 90),
      ), // 3 months in advance
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColor.orangeCustomColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColor.primaryText,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      selectedDate.value = pickedDate;
      _updatePreferredTimeDisplay();
    }
  }

  /// Select preferred time for booking
  Future<void> selectPreferredTime(BuildContext context) async {
    if (selectedDate.value == null) {
      Get.snackbar(
        'Select Date First',
        'Please select a preferred date before choosing time',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary:
                  AppColor.orangeCustomColor, // Clock circle and selected time
              onPrimary: Colors.white, // Text on primary color
              surface: Colors.white, // Dialog background
              onSurface: AppColor.primaryText, // Unselected text
              secondary: AppColor.orangeCustomColor, // AM/PM toggle selected
              onSecondary: Colors.white, // Text on secondary
              tertiary: AppColor.orangeCustomColor.withValues(
                alpha: 0.2,
              ), // AM/PM toggle background
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      // Validate that the selected time is in the future
      final selectedDateTime = DateTime(
        selectedDate.value!.year,
        selectedDate.value!.month,
        selectedDate.value!.day,
        pickedTime.hour,
        pickedTime.minute,
      );

      if (selectedDateTime.isBefore(DateTime.now())) {
        Get.snackbar(
          'Invalid Time',
          'Please select a time in the future',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Validate against trader's available hours
      if (traderStartTime.value != null && traderEndTime.value != null) {
        final selectedMinutes = pickedTime.hour * 60 + pickedTime.minute;
        final startMinutes =
            traderStartTime.value!.hour * 60 + traderStartTime.value!.minute;
        final endMinutes =
            traderEndTime.value!.hour * 60 + traderEndTime.value!.minute;

        if (selectedMinutes < startMinutes || selectedMinutes > endMinutes) {
          final startTimeStr = traderStartTime.value!.format(context);
          final endTimeStr = traderEndTime.value!.format(context);

          Get.snackbar(
            'Outside Available Hours',
            'Trader is only available between $startTimeStr and $endTimeStr',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 4),
          );
          return;
        }
      }

      selectedTime.value = pickedTime;
      _updatePreferredTimeDisplay();
    }
  }

  /// Update the preferred time display string
  void _updatePreferredTimeDisplay() {
    if (selectedDate.value != null && selectedTime.value != null) {
      final dateFormat = DateFormat('MMM dd, yyyy');
      final timeFormat = selectedTime.value!.format(Get.context!);
      preferredTimeDisplay.value =
          '${dateFormat.format(selectedDate.value!)} at $timeFormat';
    } else if (selectedDate.value != null) {
      final dateFormat = DateFormat('MMM dd, yyyy');
      preferredTimeDisplay.value =
          '${dateFormat.format(selectedDate.value!)} (Select time)';
    } else {
      preferredTimeDisplay.value = '';
    }
  }

  /// Get the combined preferred DateTime
  DateTime? get preferredDateTime {
    if (selectedDate.value != null && selectedTime.value != null) {
      return DateTime(
        selectedDate.value!.year,
        selectedDate.value!.month,
        selectedDate.value!.day,
        selectedTime.value!.hour,
        selectedTime.value!.minute,
      );
    }
    return null;
  }

  /// Validate preferred time selection
  bool validatePreferredTime() {
    if (selectedDate.value == null) {
      Get.snackbar(
        'Missing Date',
        'Please select a preferred date for your booking',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (selectedTime.value == null) {
      Get.snackbar(
        'Missing Time',
        'Please select a preferred time for your booking',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    final preferredDateTime = this.preferredDateTime;
    if (preferredDateTime == null ||
        preferredDateTime.isBefore(DateTime.now())) {
      Get.snackbar(
        'Invalid Time',
        'Please select a time in the future',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    return true;
  }

  /// Reset preferred time selection
  void resetPreferredTime() {
    selectedDate.value = null;
    selectedTime.value = null;
    preferredTimeDisplay.value = '';
  }

  /// Select images for booking
  Future<void> selectImages() async {
    try {
      final List<XFile> images = await _imagePicker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (images.isNotEmpty) {
        // Limit to maximum 5 images
        if (selectedImages.length + images.length > 5) {
          Get.snackbar(
            'Too Many Images',
            'You can upload maximum 5 images per booking',
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );

          // Take only the images that fit within the limit
          final availableSlots = 5 - selectedImages.length;
          if (availableSlots > 0) {
            selectedImages.addAll(images.take(availableSlots));
          }
        } else {
          selectedImages.addAll(images);
        }
      }
    } catch (e) {
      print('❌ Error selecting images: $e');
      Get.snackbar(
        'Error',
        'Failed to select images. Please try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Remove an image from selection
  void removeImage(int index) {
    if (index >= 0 && index < selectedImages.length) {
      selectedImages.removeAt(index);
    }
  }

  /// Upload images to Firebase Storage
  Future<List<String>> uploadImages(String bookingId) async {
    if (selectedImages.isEmpty) return [];

    isUploadingImages.value = true;
    List<String> imageUrls = [];

    try {
      for (int i = 0; i < selectedImages.length; i++) {
        final XFile image = selectedImages[i];
        final String fileName =
            'booking_${bookingId}_image_${i + 1}_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final Reference ref = _storage.ref().child(
          'bookings/$bookingId/$fileName',
        );

        final UploadTask uploadTask = ref.putFile(File(image.path));
        final TaskSnapshot taskSnapshot = await uploadTask;
        final String downloadUrl = await taskSnapshot.ref.getDownloadURL();

        imageUrls.add(downloadUrl);
      }
    } catch (e) {
      print('❌ Error uploading images: $e');
      Get.snackbar(
        'Upload Error',
        'Failed to upload some images. Please try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isUploadingImages.value = false;
    }

    return imageUrls;
  }

  /// Reset image selection
  void resetImageSelection() {
    selectedImages.clear();
    isUploadingImages.value = false;
  }

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

        isBookingCreated.value = true;
        bookingStatus.value = 'Booking created successfully!';

        print('✅ Booking created with ID: ${docRef.id}');
        print(
          '📊 Booking details: Category: $category, Service: $service, JobType: $jobType',
        );

        if (imageUrls.isNotEmpty) {
          print('📸 Uploaded ${imageUrls.length} images');
        }

        // Show success snackbar after a delay to avoid interfering with dialog close
        Future.delayed(const Duration(milliseconds: 800), () {
          Get.snackbar(
            'Success',
            'Booking created successfully! The trader will be notified.',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
          );
        });

        ChatController chatController = Get.put(ChatController());
        await chatController.createChatIfNotExists(
          FirebaseAuth.instance.currentUser!.uid,
          traderId,
          true,
          docRef.id,
          orderCategory: category,
          orderService: service,
        );

        // Navigate to job history tab after successful booking
        Future.delayed(const Duration(milliseconds: 500), () async {
          try {
            final navController = Get.find<NavigationController>();

            // Navigate back to main page with navbar and switch to job history tab (index 1)
            Get.until((route) => route.isFirst); // Go back to root
            navController.changePage(1); // Switch to job history tab

            print('✅ Navigated to job history tab');

            // Refresh job history data after navigation
            await Future.delayed(const Duration(milliseconds: 500));
            try {
              // Try to find existing controller, if not found it will be created by the page
              if (Get.isRegistered<JobHistoryPageController>()) {
                final jobHistoryController =
                    Get.find<JobHistoryPageController>();
                await jobHistoryController.fetchBookings();
                print('✅ Job history refreshed with new booking');
              } else {
                print('ℹ️ Job history controller will load data on page init');
              }
            } catch (e) {
              print('⚠️ Could not refresh job history: $e');
            }
          } catch (e) {
            print('⚠️ Navigation controller not found: $e');
          }
        });

        return true;
      }

      print('⚠️ docRef.id is empty, returning false');
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
      // Get booking data before updating for notification
      final bookingDoc =
          await _firestore.collection('bookings').doc(bookingId).get();
      if (!bookingDoc.exists) {
        Get.snackbar(
          'Error',
          'Booking not found',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }

      final bookingData = bookingDoc.data()!;
      final customerId = bookingData['userId'] as String;
      final jobTitle =
          bookingData['service'] ?? bookingData['category'] ?? 'Job';

      // Update booking status
      await _firestore.collection('bookings').doc(bookingId).update({
        'status': status,
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      });

      // Create notifications for booking acceptance/rejection
      if (status == 'accepted') {
        await NotificationService.createBookingAcceptedNotification(
          customerId: customerId,
          bookingId: bookingId,
          jobTitle: jobTitle,
        );
      } else if (status == 'rejected') {
        await NotificationService.createBookingRejectedNotification(
          customerId: customerId,
          bookingId: bookingId,
          jobTitle: jobTitle,
        );
      }

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
    DateTime? traderStartTime,
    DateTime? traderEndTime,
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

    // Set trader's available time range
    if (traderStartTime != null) {
      this.traderStartTime.value = TimeOfDay.fromDateTime(traderStartTime);
    } else {
      this.traderStartTime.value = null;
    }

    if (traderEndTime != null) {
      this.traderEndTime.value = TimeOfDay.fromDateTime(traderEndTime);
    } else {
      this.traderEndTime.value = null;
    }

    // Reset preferred time selection when opening dialog
    resetPreferredTime();
    resetImageSelection();

    final TextEditingController notesController = TextEditingController();

    // Format job type for display
    String formattedJobType = _formatJobType(jobType);

    await Get.dialog(
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
              Text('Job Type: $formattedJobType'),
              const SizedBox(height: 8),
              Text("Price: $price"),

              // Display trader's available hours if available
              if (this.traderStartTime.value != null &&
                  this.traderEndTime.value != null) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: Colors.blue.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Available: ${this.traderStartTime.value!.format(Get.context!)} - ${this.traderEndTime.value!.format(Get.context!)}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColor.primaryText,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 16),

              // Preferred Date Selection
              const Text(
                'Preferred Date & Time*',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColor.primaryText,
                ),
              ),
              const SizedBox(height: 8),

              Row(
                children: [
                  Expanded(
                    child: Obx(
                      () => OutlinedButton.icon(
                        onPressed: () => selectPreferredDate(Get.context!),
                        icon: const Icon(Icons.calendar_today, size: 18),
                        label: Text(
                          selectedDate.value != null
                              ? DateFormat(
                                'MMM dd, yyyy',
                              ).format(selectedDate.value!)
                              : 'Select Date',
                          style: const TextStyle(fontSize: 14),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColor.primaryText,
                          side: BorderSide(
                            color:
                                selectedDate.value == null
                                    ? Colors.red
                                    : AppColor.primaryText,
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 8,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Obx(
                      () => OutlinedButton.icon(
                        onPressed: () => selectPreferredTime(Get.context!),
                        icon: const Icon(Icons.access_time, size: 18),
                        label: Text(
                          selectedTime.value != null
                              ? selectedTime.value!.format(Get.context!)
                              : 'Select Time',
                          style: const TextStyle(fontSize: 14),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColor.primaryText,
                          side: BorderSide(
                            color:
                                selectedTime.value == null
                                    ? Colors.red
                                    : AppColor.primaryText,
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 8,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Display selected date and time
              Obx(
                () =>
                    preferredTimeDisplay.value.isNotEmpty
                        ? Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColor.orangeCustomColor.withValues(
                              alpha: 0.1,
                            ),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: AppColor.orangeCustomColor.withValues(
                                alpha: 0.3,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.schedule,
                                size: 16,
                                color: AppColor.orangeCustomColor,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  'Preferred: ${preferredTimeDisplay.value}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppColor.primaryText,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                        : const SizedBox.shrink(),
              ),

              const SizedBox(height: 16),

              // Image Selection Section
              const Text(
                'Images (Optional)',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColor.primaryText,
                ),
              ),
              const SizedBox(height: 8),

              // Add Images Button
              OutlinedButton.icon(
                onPressed: () => selectImages(),
                icon: const Icon(Icons.add_photo_alternate, size: 18),
                label: const Text('Add Images', style: TextStyle(fontSize: 14)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColor.primaryText,
                  side: const BorderSide(color: AppColor.primaryText),
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Display selected images
              Obx(
                () =>
                    selectedImages.isNotEmpty
                        ? SizedBox(
                          height: 100,
                          width: Get.width,
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: selectedImages.length,
                            itemBuilder: (context, index) {
                              return Container(
                                height: 80,
                                width: 80,
                                margin: const EdgeInsets.only(right: 8),
                                child: Stack(
                                  children: [
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(7),
                                        child: Image.file(
                                          File(selectedImages[index].path),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      right: -5,
                                      top: -5,
                                      child: IconButton(
                                        onPressed: () => removeImage(index),
                                        icon: Container(
                                          padding: const EdgeInsets.all(2),
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: 14,
                                          ),
                                        ),
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        )
                        : const SizedBox.shrink(),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: notesController,
                decoration: const InputDecoration(
                  labelText: 'Additional Notes (Optional)',
                  labelStyle: TextStyle(color: AppColor.primaryText),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.primaryText),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.primaryText),
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
            onPressed: () {
              resetPreferredTime();
              resetImageSelection();
              Get.back();
            },
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
                        // Validate preferred time before proceeding
                        if (!validatePreferredTime()) {
                          return;
                        }

                        JobPostController controller = Get.find();
                        final success = await createBooking(
                          traderId: traderId,
                          category: category,
                          service: service,
                          jobType: jobType,
                          notes: notesController.text.trim(),
                          preferredTime:
                              preferredDateTime, // Pass the preferred time
                          latitude: controller.selectedLat.value,
                          longitude: controller.selectedLon.value,
                          price: price,
                        );

                        print('🔍 Booking creation result: $success');

                        if (success) {
                          resetPreferredTime();
                          resetImageSelection();
                          // Close the dialog immediately
                          Get.back();
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

  /// Format job type for display
  String _formatJobType(String jobType) {
    switch (jobType.toLowerCase()) {
      case 'small':
      case 'smalljob':
        return 'Small Job';
      case 'large':
      case 'largejob':
        return 'Large Job';
      default:
        // Capitalize first letter if it's a custom format
        return jobType.isNotEmpty
            ? '${jobType[0].toUpperCase()}${jobType.substring(1)}'
            : jobType;
    }
  }

  /// Reset controller state
  void resetState() {
    isLoading.value = false;
    isBookingCreated.value = false;
    bookingStatus.value = '';
    resetPreferredTime();
    resetImageSelection();
  }

  Future<BookingModel?> getBookingFromId(String? orderId) async {
    if (orderId == null) return null;

    // Fetch booking details from Firestore
    return await _firestore
        .collection('bookings')
        .doc(orderId)
        .get()
        .then((doc) {
          if (doc.exists) {
            return BookingModel.fromFirestore(doc);
          }

          return null;
        })
        .catchError((error) {
          print('❌ Error fetching booking: $error');
          return null;
        });
  }
}
