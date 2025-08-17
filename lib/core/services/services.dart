import 'package:get/get.dart';

class HelperService {
  static String formatStatus(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Waiting for proposal';
      case 'confirmed':
        return 'Accepted';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      case 'in_progress':
        return 'In Progress';
      default:
        return status.capitalize ?? status;
    }
  }
}
