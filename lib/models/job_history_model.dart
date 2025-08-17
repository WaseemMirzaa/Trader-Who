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
  final String notes;
  final List<String> images;
  final LatLng location;
  final String bookingId;
  final int? rating;
  final String? review;
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
    required this.notes,
    required this.images,
    required this.location,
    required this.bookingId,
    this.rating,
    this.review,
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
    String? notes,
    List<String>? images,
    LatLng? location,
    String? bookingId,
    int? rating,
    String? review,
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
      notes: notes ?? this.notes,
      images: images ?? this.images,
      location: location ?? this.location,
      bookingId: bookingId ?? this.bookingId,
      rating: rating ?? this.rating,
      review: review ?? this.review,
    );
  }
}
