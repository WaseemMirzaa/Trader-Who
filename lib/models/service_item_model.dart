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

  ServiceItem copyWith({
    String? title,
    String? description,
    double? price,
    bool? isEnabled,
    bool? isCustom,
  }) {
    return ServiceItem(
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      isEnabled: isEnabled ?? this.isEnabled,
      isCustom: isCustom ?? this.isCustom,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'price': price,
      'isEnabled': isEnabled,
      'isCustom': isCustom,
    };
  }

  factory ServiceItem.fromMap(Map<String, dynamic> map) {
    return ServiceItem(
      title: map['title'],
      description: map['description'],
      price: map['price']?.toDouble(),
      isEnabled: map['isEnabled'] ?? false,
      isCustom: map['isCustom'] ?? false,
    );
  }
}
