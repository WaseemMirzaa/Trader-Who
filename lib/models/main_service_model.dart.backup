import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:traderwho/models/models.dart';

class MainServiceModel {
  final DateTime createdAt;
  final DateTime updatedAt;
  Map<String, List<ServiceItem>> predefinedServices;

  MainServiceModel({
    required this.createdAt,
    required this.updatedAt,
    required this.predefinedServices,
  });

  factory MainServiceModel.fromMap(Map<String, dynamic> map) {
    Map<String, List<ServiceItem>> services = {};

    if (map['predefinedServices'] != null) {
      final predefinedServicesMap =
          map['predefinedServices'] as Map<String, dynamic>;
      predefinedServicesMap.forEach((key, value) {
        if (value is List) {
          services[key] =
              value
                  .map(
                    (item) => ServiceItem.fromMap(item as Map<String, dynamic>),
                  )
                  .toList();
        }
      });
    }

    return MainServiceModel(
      createdAt:
          map['createdAt'] is Timestamp
              ? (map['createdAt'] as Timestamp).toDate()
              : (map['createdAt'] is int
                  ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int)
                  : DateTime.now()),
      updatedAt:
          map['updatedAt'] is Timestamp
              ? (map['updatedAt'] as Timestamp).toDate()
              : (map['updatedAt'] is int
                  ? DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int)
                  : DateTime.now()),
      predefinedServices: services,
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> servicesMap = {};
    predefinedServices.forEach((key, value) {
      servicesMap[key] = value.map((item) => item.toMap()).toList();
    });

    return {
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'predefinedServices': servicesMap,
    };
  }
}
