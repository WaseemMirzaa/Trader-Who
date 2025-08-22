part of 'models.dart';

// service_item_model.dart
class ServiceModel {
  String category;
  List<ServiceItem> services;

  ServiceModel({required this.category, required this.services});

  factory ServiceModel.fromMap(Map<String, dynamic> map) {
    return ServiceModel(
      category: map['category'] ?? '',
      services: List<ServiceItem>.from(
        map['services']
                ?.map((item) {
                  if (item is Map<String, dynamic>) {
                    return ServiceItem.fromMap(item);
                  }
                  return null;
                })
                .where((item) => item != null) ??
            [],
      ),
    );
  }
}

class ServiceItem {
  String title;
  String? description;
  double? price;
  double? lowestPrice;
  double? highestPrice;
  bool isEnabled;
  bool isCustom;
  String id;
  String? traderId;
  TradesPerson? tradesPerson;

  ServiceItem({
    required this.title,
    this.description,
    this.price,
    this.lowestPrice,
    this.highestPrice,
    this.isEnabled = false,
    this.isCustom = false,
    this.tradesPerson,
    this.traderId,
    required this.id,
  });

  ServiceItem copyWith({
    String? title,
    String? description,
    double? price,
    double? lowestPrice,
    double? highestPrice,
    bool? isEnabled,
    bool? isCustom,
    String? id,
    String? traderId,
    TradesPerson? tradesPerson,
  }) {
    return ServiceItem(
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      lowestPrice: lowestPrice ?? this.lowestPrice,
      highestPrice: highestPrice ?? this.highestPrice,
      isEnabled: isEnabled ?? this.isEnabled,
      isCustom: isCustom ?? this.isCustom,
      id: id ?? this.id,
      traderId: traderId ?? this.traderId,
      tradesPerson: tradesPerson ?? this.tradesPerson,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'price': price,
      'isEnabled': isEnabled,
      'isCustom': isCustom,
      'id': id,
    };
  }

  factory ServiceItem.fromMap(Map<String, dynamic> map) {
    return ServiceItem(
      title: map['title'] ?? map['name'] ?? '',
      description: map['description'] ?? "",
      price: map['price']?.toDouble(),
      isEnabled: map['isEnabled'] ?? false,
      isCustom: map['isCustom'] ?? false,
      id: map['jobId'] ?? map['id'] ?? '',
      traderId: map['trader_id'] ?? '',
    );
  }
}
