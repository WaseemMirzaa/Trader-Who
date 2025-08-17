import 'package:get/get.dart';
import 'package:traderwho/controller/job_history_page_controller.dart';
import 'package:traderwho/models/models.dart';

class TradeHomeController extends GetxController {
  late JobHistoryPageController _jobHistoryController;

  @override
  void onInit() {
    super.onInit();
    // Initialize job history controller if not already registered
    if (!Get.isRegistered<JobHistoryPageController>()) {
      Get.put(JobHistoryPageController());
    }
    _jobHistoryController = Get.find<JobHistoryPageController>();
  }

  /// Get new jobs for the home page (non-completed, limited to 5)
  List<JobHistory> get newJobs {
    return _jobHistoryController.jobHistoryItems
        .where((job) => job.status != 'Completed' && job.status != 'Cancelled')
        .take(5)
        .toList();
  }

  /// Get loading state
  bool get isLoading => _jobHistoryController.isLoading.value;

  /// Refresh bookings
  Future<void> refreshBookings() async {
    await _jobHistoryController.refreshBookings();
  }

  /// Accept a job
  Future<void> acceptJob(JobHistory job) async {
    final booking = _findBookingForJob(job);
    if (booking != null) {
      await _jobHistoryController.updateBookingStatus(
        booking.id ?? '',
        'accepted',
      );
    }
  }

  /// Reject a job
  Future<void> rejectJob(JobHistory job) async {
    final booking = _findBookingForJob(job);
    if (booking != null) {
      await _jobHistoryController.updateBookingStatus(
        booking.id ?? '',
        'rejected',
      );
    }
  }

  /// Helper method to find the corresponding BookingModel for a JobHistory
  BookingModel? _findBookingForJob(JobHistory job) {
    // Try to find in trader bookings first (since this is trader home page)
    for (final booking in _jobHistoryController.traderBookings) {
      if (booking.category == job.jobType && booking.price == job.price) {
        return booking;
      }
    }

    // Then try user bookings if needed
    for (final booking in _jobHistoryController.userBookings) {
      if (booking.category == job.jobType && booking.price == job.price) {
        return booking;
      }
    }

    return null;
  }
}
