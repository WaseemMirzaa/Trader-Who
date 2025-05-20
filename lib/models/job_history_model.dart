part of 'models.dart';

class JobHistory {
  final String title;
  final String svgIcon;
  final String jobType;
  final double price;
  final String preferredTime;
  final String address;
  final String status;
  final TradesPerson? tradesPerson; 

  JobHistory({
    required this.title,
    required this.svgIcon,
    required this.jobType,
    required this.price,
    required this.preferredTime,
    required this.address,
    required this.status,
    this.tradesPerson,
  });
}