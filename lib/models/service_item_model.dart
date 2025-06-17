part of 'models.dart';

// service_item_model.dart
class ServiceItem {
  String title;
  String? description;
  double? price;
  bool isEnabled;
  bool isCustom;

  ServiceItem({
    required this.title,
    this.description,
    this.price,
    this.isEnabled = false,
    this.isCustom = false,
  });
}
