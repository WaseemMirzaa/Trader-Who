part of 'models.dart';

class TradesPerson {
  final String name;
  final String expertise;
  final String description;
  final String price;
  final String imageUrl;
  final double rating;

  const TradesPerson({
    required this.name,
    required this.expertise,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.rating,
  });
}