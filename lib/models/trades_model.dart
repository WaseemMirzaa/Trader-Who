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

  const TradesPerson({
    required this.name,
    required this.expertise,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.rating,
    this.services,
    required this.id,
    required this.bio,
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
      rating:
          (map['rating'] is int)
              ? (map['rating'] as int).toDouble()
              : (map['rating'] ?? 0.0).toDouble(),
      services:
          map['services'] != null ? List<String>.from(map['services']) : null,
      id: map['id'] ?? '',
      bio: map['bio'] ?? '',
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
