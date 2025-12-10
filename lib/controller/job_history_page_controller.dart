import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:traderou/controller/quote_controller.dart';
import 'package:traderou/core/services/notification_service.dart';
import 'package:traderou/core/utils/location_utils.dart';
import 'package:traderou/models/models.dart';
import 'package:traderou/models/user_model.dart';

class JobHistoryPageController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  RxBool isLoading = false.obs;
  RxList<BookingModel> userBookings = <BookingModel>[].obs;
  RxList<BookingModel> traderBookings = <BookingModel>[].obs;
  RxList<JobHistory> jobHistoryItems = <JobHistory>[].obs;
  RxString selectedTab = 'New Jobs'.obs;

  // Date filtering
  Rx<DateTime?> selectedDate = Rx<DateTime?>(DateTime.now());

  @override
  void onInit() {
    super.onInit();
    fetchBookings();
  }

  /// Set selected date for filtering
  void setSelectedDate(DateTime date) {
    selectedDate.value = date;
  }

  /// Get jobs filtered by selected date
  List<JobHistory> getJobsForSelectedDate() {
    if (selectedDate.value == null) {
      return jobHistoryItems.toList();
    }

    final selectedDay = selectedDate.value!;
    return jobHistoryItems.where((job) {
      // Parse the preferredTime string back to DateTime
      return _isJobScheduledOnDate(job, selectedDay);
    }).toList();
  }

  /// Check if a job is scheduled on a specific date
  bool _isJobScheduledOnDate(JobHistory job, DateTime date) {
    // Get the original booking to access preferredTime
    final booking = _findBookingForJob(job);
    if (booking?.preferredTime == null) {
      return false;
    }

    final jobDate = booking!.preferredTime!;
    return jobDate.year == date.year &&
        jobDate.month == date.month &&
        jobDate.day == date.day;
  }

  /// Find booking for a given job
  BookingModel? _findBookingForJob(JobHistory job) {
    // Try user bookings first
    for (final booking in userBookings) {
      if (booking.category == job.category && booking.price == job.price) {
        return booking;
      }
    }

    // Then try trader bookings
    for (final booking in traderBookings) {
      if (booking.category == job.category && booking.price == job.price) {
        return booking;
      }
    }

    return null;
  }

  /// Get dates that have jobs scheduled
  List<DateTime> getJobDates() {
    List<DateTime> dates = [];

    for (final booking in [...userBookings, ...traderBookings]) {
      if (booking.preferredTime != null) {
        dates.add(booking.preferredTime!);
      }
    }

    return dates;
  }

  /// Fetch all bookings for current user
  Future<void> fetchBookings() async {
    try {
      isLoading.value = true;

      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        print('❌ No authenticated user found');
        return;
      }

      print('📥 Fetching bookings for user: ${currentUser.uid}');

      // Check user type to determine what bookings to show
      final isCustomer = await _checkIfUserIsCustomer(currentUser.uid);

      if (isCustomer) {
        // For customers: Show bookings they created
        await _fetchUserBookings(currentUser.uid);
        print(
          '✅ Successfully fetched ${userBookings.length} customer bookings',
        );
      } else {
        // For traders: Show bookings they received
        await _fetchTraderBookings(currentUser.uid);
        print(
          '✅ Successfully fetched ${traderBookings.length} trader bookings',
        );
      }

      // Convert bookings to JobHistory format for UI compatibility
      await _convertBookingsToJobHistory();
    } catch (e) {
      print('❌ Error fetching bookings: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch bookings created by the user
  Future<void> _fetchUserBookings(String userId) async {
    try {
      final querySnapshot =
          await _firestore
              .collection('bookings')
              .where('userId', isEqualTo: userId)
              .orderBy('createdAt', descending: true)
              .get();

      userBookings.value =
          querySnapshot.docs
              .map((doc) => BookingModel.fromFirestore(doc))
              .toList();

      print('📊 Found ${userBookings.length} user bookings');
    } catch (e) {
      print('❌ Error fetching user bookings: $e');
      userBookings.value = [];
    }
  }

  /// Fetch bookings received by the user (if they are a trader)
  Future<void> _fetchTraderBookings(String traderId) async {
    try {
      // Fetch bookings assigned to this trader
      final assignedQuery =
          await _firestore
              .collection('bookings')
              .where('traderId', isEqualTo: traderId)
              .orderBy('createdAt', descending: true)
              .get();

      // Fetch custom jobs (empty traderId) that are not marked as notInterested by this trader
      final customJobsQuery =
          await _firestore
              .collection('bookings')
              .where('traderId', isEqualTo: '')
              .where(
                'status',
                whereIn: [
                  'pending',
                  'quoted',
                  'accepted',
                  'inProgress',
                  'awaiting_verification',
                ],
              )
              .orderBy('createdAt', descending: true)
              .get();

      // Combine both lists
      final allDocs = [...assignedQuery.docs, ...customJobsQuery.docs];

      // Convert to BookingModel and filter out jobs marked as notInterested
      final allBookings =
          allDocs.map((doc) => BookingModel.fromFirestore(doc)).where((
            booking,
          ) {
            // Filter out jobs this trader marked as not interested
            if (booking.notInterestedTraders != null &&
                booking.notInterestedTraders!.contains(traderId)) {
              return false;
            }
            return true;
          }).toList();

      traderBookings.value = allBookings;

      print(
        '📊 Found ${traderBookings.length} trader bookings (including custom jobs)',
      );
    } catch (e) {
      print('❌ Error fetching trader bookings: $e');
      traderBookings.value = [];
    }
  }

  /// Convert BookingModel objects to JobHistory for UI compatibility
  Future<void> _convertBookingsToJobHistory() async {
    List<JobHistory> historyItems = [];

    // Convert user bookings (jobs the user posted as a customer)
    for (BookingModel booking in userBookings) {
      historyItems.add(
        await _bookingToJobHistory(booking, isUserBooking: true),
      );
    }

    // Convert trader bookings (jobs received as a trader)
    for (BookingModel booking in traderBookings) {
      historyItems.add(
        await _bookingToJobHistory(booking, isUserBooking: false),
      );
    }

    // Sort by creation date (newest first)
    historyItems.sort((a, b) => b.preferredTime.compareTo(a.preferredTime));

    jobHistoryItems.value = historyItems;
  }

  /// Convert a single BookingModel to JobHistory
  Future<JobHistory> _bookingToJobHistory(
    BookingModel booking, {
    required bool isUserBooking,
  }) async {
    UserModel? customer;
    final userDetails =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(booking.userId)
            .get();

    if (userDetails.exists) {
      customer = UserModel.fromFirestore(userDetails);
    }

    // Fetch trader details if available
    TradesPerson? traderData;
    if (booking.traderId.isNotEmpty) {
      try {
        final traderDoc =
            await _firestore.collection('users').doc(booking.traderId).get();
        if (traderDoc.exists) {
          traderData = TradesPerson.fromDocumentSnapshot(traderDoc);
        }
      } catch (e) {
        print('❌ Error fetching trader details: $e');
      }
    }

    TradesPerson defaultTrader =
        traderData ??
        TradesPerson(
          id: booking.traderId,
          name: isUserBooking ? 'Trader' : 'Customer',
          bio: 'Professional service provider',
          expertise: booking.category,
          description:
              booking.notes.isNotEmpty ? booking.notes : 'Service booking',
          imageUrl: 'assets/images/chat-avatar.png',
          price: booking.price.toString(),
          rating: booking.rating,
          largeJobs: [],
          smallJobs: [],
          latitude: booking.latitude,
          longitude: booking.longitude,
        );

    // Get address from coordinates
    final address = await LocationUtils.getAddressFromCoordinates(
      booking.latitude,
      booking.longitude,
    );

    return JobHistory(
      title: booking.category.isNotEmpty ? booking.category : 'Service',
      svgIcon: _getCategoryIcon(booking.category),
      jobType: booking.jobType,
      category: booking.category,
      service: booking.service,
      price: booking.price,
      preferredTime: _formatDateTime(booking.preferredTime!),
      address: address,
      status: booking.status,
      tradesPerson: defaultTrader,
      showQuoteButtons: booking.status == 'pending',
      images: booking.images,
      notes: booking.notes,
      location: LatLng(booking.latitude, booking.longitude),
      bookingId: booking.id ?? "-",
      userId: booking.userId,
      customer: customer,
    );
  }

  /// Get appropriate icon for category
  String _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'plumbing':
        return 'assets/images/plumber.png';
      case 'electrical':
        return 'assets/images/electricity.png';
      case 'cleaning':
        return 'assets/svgs/cleaning.svg';
      case 'carpentry':
        return 'assets/svgs/carpentry.svg';
      case 'painting':
        return 'assets/svgs/painting.svg';
      case 'roofing':
        return 'assets/svgs/roofing.svg';
      case 'flooring':
        return 'assets/svgs/flooring.svg';
      case 'heating':
        return 'assets/svgs/heating.svg';
      case 'landscaping':
        return 'assets/svgs/landscaping.svg';
      default:
        return 'assets/svgs/general.svg';
    }
  }

  /// Format DateTime for display
  String _formatDateTime(DateTime dateTime) {
    // Format: DD/MM/YYYY, HH:MM AM/PM
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final year = dateTime.year;

    // Convert to 12-hour format
    final hour =
        dateTime.hour == 0
            ? 12
            : (dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour);
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';

    final formattedTime = '$day/$month/$year, $hour:$minute $period';
    print('📅 Formatted DateTime: $dateTime -> $formattedTime');
    return formattedTime;
  }

  /// Public method for UI to convert booking to job history
  Future<JobHistory> bookingToJobHistoryForUI(
    BookingModel booking, {
    required bool isUserBooking,
  }) async {
    return await _bookingToJobHistory(booking, isUserBooking: isUserBooking);
  }

  /// Filter bookings by status
  List<JobHistory> getFilteredJobs(String filter) {
    switch (filter) {
      case 'New Jobs':
        return jobHistoryItems
            .where(
              (job) => job.status != 'completed' || job.status == 'cancelled',
            )
            .toList();
      case 'Completed':
        return jobHistoryItems
            .where((job) => job.status == 'completed')
            .toList();
      case 'cancelled':
        return jobHistoryItems
            .where((job) => job.status == 'cancelled')
            .toList();
      default:
        return jobHistoryItems.toList();
    }
  }

  /// Update booking status
  Future<void> updateBookingStatus(String bookingId, String newStatus) async {
    try {
      // Get booking data before updating for notification
      final bookingDoc =
          await _firestore.collection('bookings').doc(bookingId).get();
      if (!bookingDoc.exists) {
        print('❌ Booking not found');
        return;
      }

      final bookingData = bookingDoc.data()!;
      final customerId = bookingData['userId'] as String;
      final jobTitle =
          bookingData['service'] ?? bookingData['category'] ?? 'Job';

      // Update booking status
      await _firestore.collection('bookings').doc(bookingId).update({
        'status': newStatus,
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      });

      // Create notifications for booking acceptance/rejection
      if (newStatus == 'accepted') {
        await NotificationService.createBookingAcceptedNotification(
          customerId: customerId,
          bookingId: bookingId,
          jobTitle: jobTitle,
        );
      } else if (newStatus == 'rejected') {
        await NotificationService.createBookingRejectedNotification(
          customerId: customerId,
          bookingId: bookingId,
          jobTitle: jobTitle,
        );
      }

      // Refresh the bookings
      await fetchBookings();

      print('✅ Booking status updated to: $newStatus');
    } catch (e) {
      print('❌ Error updating booking status: $e');
    }
  }

  /// Set selected tab
  void setSelectedTab(String tab) {
    selectedTab.value = tab;
  }

  /// Refresh bookings
  Future<void> refreshBookings() async {
    await fetchBookings();
  }

  /// Submit a quote for a booking
  Future<bool> submitQuote({
    required String bookingId,
    required String customerId,
    required double quotedPrice,
    required String details,
  }) async {
    try {
      final quoteController = Get.find<QuoteController>();
      final success = await quoteController.submitQuote(
        bookingId: bookingId,
        customerId: customerId,
        quotedPrice: quotedPrice,
        details: details,
      );

      if (success) {
        // Refresh bookings to update status
        await fetchBookings();
      }

      return success;
    } catch (e) {
      print('❌ Error submitting quote: $e');
      return false;
    }
  }

  /// Get existing quote for a booking (if any)
  Future<QuoteModel?> getExistingQuote(String bookingId) async {
    try {
      final quoteController = Get.find<QuoteController>();
      return await quoteController.getExistingQuote(bookingId);
    } catch (e) {
      print('❌ Error getting existing quote: $e');
      return null;
    }
  }

  /// Get quote status for a booking by current trader
  Future<String?> getQuoteStatusForJob(String bookingId) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return null;

      final quoteQuery =
          await _firestore
              .collection('quotes')
              .where('bookingId', isEqualTo: bookingId)
              .where('traderId', isEqualTo: currentUser.uid)
              .limit(1)
              .get();

      if (quoteQuery.docs.isNotEmpty) {
        final quote = QuoteModel.fromFirestore(quoteQuery.docs.first);
        return quote.status;
      }

      return null; // No quote found
    } catch (e) {
      print('❌ Error getting quote status: $e');
      return null;
    }
  }

  /// Get quote details for a booking by current trader
  Future<QuoteModel?> getQuoteForJob(String bookingId) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return null;

      final quoteQuery =
          await _firestore
              .collection('quotes')
              .where('bookingId', isEqualTo: bookingId)
              .where('traderId', isEqualTo: currentUser.uid)
              .limit(1)
              .get();

      if (quoteQuery.docs.isNotEmpty) {
        return QuoteModel.fromFirestore(quoteQuery.docs.first);
      }

      return null; // No quote found
    } catch (e) {
      print('❌ Error getting quote: $e');
      return null;
    }
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

  sendQuote(String jobId, double price, String details) {}
}
