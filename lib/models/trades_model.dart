part of 'models.dart';

class TradesPerson {
  final String name;
  final String expertise;
  final String description;
  final String price;
  final String imageUrl;
  final double rating;
  final List<String>? services;
  final String id;
  final String bio;
  final List<ServiceModel> largeJobs;
  final List<ServiceModel> smallJobs;
  List<ReviewModel>? reviews;
  int? startTime;
  int? endTime;
  double latitude;
  double longitude;
  String? title;
  String? phoneNumber;

  TradesPerson({
    required this.name,
    required this.expertise,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.rating,
    this.services,
    required this.id,
    required this.bio,
    required this.largeJobs,
    required this.smallJobs,
    this.reviews,
    this.startTime,
    this.endTime,
    required this.latitude,
    required this.longitude,
    this.title,
    this.phoneNumber,
  });

  factory TradesPerson.fromDocumentSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TradesPerson.fromMap({
      ...data,
      'id': doc.id, // Ensure Firestore doc id is used
    });
  }

  factory TradesPerson.fromMap(Map<String, dynamic> map) {
    return TradesPerson(
      name: map['name'] ?? '',
      expertise: map['expertise'] ?? '',
      description: map['description'] ?? '',
      price: map['price'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      phoneNumber: map['phone'] ?? '',
      rating:
          (map['rating'] is int)
              ? (map['rating'] as int).toDouble()
              : (map['rating'] ?? 0.0).toDouble(),
      // services:
      //     map['services'] != null ? List<String>.from(map['services']) : null,
      id: map['id'] ?? '',
      bio: map['bio'] ?? '',
      largeJobs:
          (map['largejoblist'] ?? [])
              .map<ServiceModel>((item) => ServiceModel.fromMap(item))
              .toList(),
      smallJobs:
          (map['smalljoblist'] ?? [])
              .map<ServiceModel>((item) => ServiceModel.fromMap(item))
              .toList(),
      startTime: map['start_time'],
      endTime: map['end_time'],
      latitude: map['lat'] ?? 0,
      longitude: map['lon'] ?? 0,
      title: HelperService.formattedCategoryName(map['title'] ?? ''),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'expertise': expertise,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'rating': rating,
      'services': services,
      'id': id,
      'bio': bio,
    };
  }
}
