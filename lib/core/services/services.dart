import 'package:get/get.dart';

class HelperService {
  static String formatStatus(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Customer awaiting quote';
      case 'quoted':
        return 'Quote Submitted';
      case 'accepted':
        return 'Accepted';
      case 'confirmed':
        return 'Confirmed';
      case 'inprogress':
        return 'In Progress';
      case 'in_progress':
        return 'In Progress';
      case 'awaiting_verification':
        return 'Awaiting Verification';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      case 'rejected':
        return 'Rejected';
      case 'notinterested':
        return 'Not Interested';
      case 'expired':
        return 'Expired';
      default:
        return status.capitalize ?? status;
    }
  }

  static String formattedJobType(String jobType) {
    switch (jobType) {
      case 'smallJob':
        return 'Small Job';
      case 'largeJob':
        return 'Large Job';

      default:
        return jobType.capitalize ?? jobType;
    }
  }

  static String formattedCategoryName(String category) {
    String cat = category
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) => word.capitalize ?? word)
        .join(' ');
    return cat;
  }
}
