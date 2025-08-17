import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:traderwho/models/models.dart';

class JobHistoryPageController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  RxBool isLoading = false.obs;
  RxList<BookingModel> userBookings = <BookingModel>[].obs;
  RxList<BookingModel> traderBookings = <BookingModel>[].obs;
  RxList<JobHistory> jobHistoryItems = <JobHistory>[].obs;
  RxString selectedTab = 'New Jobs'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBookings();
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
      _convertBookingsToJobHistory();
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
      final querySnapshot =
          await _firestore
              .collection('bookings')
              .where('traderId', isEqualTo: traderId)
              .orderBy('createdAt', descending: true)
              .get();

      traderBookings.value =
          querySnapshot.docs
              .map((doc) => BookingModel.fromFirestore(doc))
              .toList();

      print('📊 Found ${traderBookings.length} trader bookings');
    } catch (e) {
      print('❌ Error fetching trader bookings: $e');
      traderBookings.value = [];
    }
  }

  /// Convert BookingModel objects to JobHistory for UI compatibility
  void _convertBookingsToJobHistory() {
    List<JobHistory> historyItems = [];

    // Convert user bookings (jobs the user posted as a customer)
    for (BookingModel booking in userBookings) {
      historyItems.add(_bookingToJobHistory(booking, isUserBooking: true));
    }

    // Convert trader bookings (jobs received as a trader)
    for (BookingModel booking in traderBookings) {
      historyItems.add(_bookingToJobHistory(booking, isUserBooking: false));
    }

    // Sort by creation date (newest first)
    historyItems.sort((a, b) => b.preferredTime.compareTo(a.preferredTime));

    jobHistoryItems.value = historyItems;
  }

  /// Convert a single BookingModel to JobHistory
  JobHistory _bookingToJobHistory(
    BookingModel booking, {
    required bool isUserBooking,
  }) {
    // Create a default TradesPerson if not available
    TradesPerson defaultTrader = TradesPerson(
      id: booking.traderId,
      name: isUserBooking ? 'Trader' : 'Customer',
      bio: 'Professional service provider',
      expertise: booking.category,
      description: booking.notes.isNotEmpty ? booking.notes : 'Service booking',
      imageUrl: 'assets/images/chat-avatar.png',
      price: booking.price.toString(),
      rating: booking.rating,
      largeJobs: [],
      smallJobs: [],
      latitude: booking.latitude,
      longitude: booking.longitude,
    );

    return JobHistory(
      title: booking.category.isNotEmpty ? booking.category : 'Service',
      svgIcon: _getCategoryIcon(booking.category),
      jobType: booking.category,
      price: booking.price,
      preferredTime:
          booking.preferredTime != null
              ? _formatDateTime(booking.preferredTime!)
              : _formatDateTime(booking.createdAt ?? DateTime.now()),
      address: _formatLocation(booking.latitude, booking.longitude),
      status: booking.status,
      tradesPerson: defaultTrader,
      showQuoteButtons: booking.status == 'pending',
      images: booking.images,
      notes: booking.notes,
      location: LatLng(booking.latitude, booking.longitude),
      bookingId: booking.id ?? "-",
    );
  }

  /// Get appropriate icon for category
  String _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'plumbing':
        return 'assets/svgs/plumbing.svg';
      case 'electrical':
        return 'assets/svgs/electric.svg';
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
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      return 'Today, ${_formatTime(dateTime)}';
    } else if (difference.inDays == 1) {
      return 'Yesterday, ${_formatTime(dateTime)}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  /// Format time portion
  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:$minute $period';
  }

  /// Format location coordinates
  String _formatLocation(double latitude, double longitude) {
    if (latitude == 0.0 && longitude == 0.0) {
      return 'Location not specified';
    }
    return 'Lat: ${latitude.toStringAsFixed(4)}, Lon: ${longitude.toStringAsFixed(4)}';
  }

  /// Format booking status for display

  /// Filter bookings by status
  List<JobHistory> getFilteredJobs(String filter) {
    switch (filter) {
      case 'pending':
        return jobHistoryItems
            .where((job) => job.status == 'pending' || job.status == 'accepted')
            .toList();
      case 'completed':
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
      await _firestore.collection('bookings').doc(bookingId).update({
        'status': newStatus,
        'updatedAt': FieldValue.serverTimestamp(),
      });

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
}
