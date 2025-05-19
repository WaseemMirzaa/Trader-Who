part of 'models.dart';

class JobHistory {
  final String title;
  final String jobType;
  final double price;
  final String preferredTime;
  final String address;
  final String status;
  final String svgIcon; 
  JobHistory({
    required this.title,
    required this.jobType,
    required this.price,
    required this.preferredTime,
    required this.address,
    required this.status,
    required this.svgIcon,
  });
}