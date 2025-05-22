part of 'models.dart';

class JobHistory {
  final String title;
  final String svgIcon;
  final String jobType;
  final double price;
  final String preferredTime;
  final String address;
  final String status;
  final TradesPerson tradesPerson;
  final bool showQuoteButtons; // New property

  const JobHistory({
    required this.title,
    required this.svgIcon,
    required this.jobType,
    required this.price,
    required this.preferredTime,
    required this.address,
    required this.status,
    required this.tradesPerson,
    this.showQuoteButtons = false, // Default to Reject/Accept
  });

  JobHistory copyWith({
    String? title,
    String? svgIcon,
    String? jobType,
    double? price,
    String? preferredTime,
    String? address,
    String? status,
    TradesPerson? tradesPerson,
    bool? showQuoteButtons,
  }) {
    return JobHistory(
      title: title ?? this.title,
      svgIcon: svgIcon ?? this.svgIcon,
      jobType: jobType ?? this.jobType,
      price: price ?? this.price,
      preferredTime: preferredTime ?? this.preferredTime,
      address: address ?? this.address,
      status: status ?? this.status,
      tradesPerson: tradesPerson ?? this.tradesPerson,
      showQuoteButtons: showQuoteButtons ?? this.showQuoteButtons,
    );
  }
}
