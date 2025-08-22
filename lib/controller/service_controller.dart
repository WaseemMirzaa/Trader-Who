import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traderwho/models/main_service_model.dart';
import 'package:traderwho/models/models.dart';
import 'package:traderwho/views/trades_profile/presentation/pages/pages.dart';

class ServiceController extends GetxController {
  MainServiceModel? predefinedSmallJobs;
  RxString selectedCategory = RxString('');
  final RxMap<String, List<ServiceItem>> smallCategories =
      <String, List<ServiceItem>>{}.obs;

  /// Returns categories sorted alphabetically by category name
  /// Note: Categories are already sorted in the underlying data structure
  List<String> get sortedCategoryNames {
    return smallCategories.keys.toList();
  }

  final RxMap<String, List<ServiceItem>> categories =
      <String, List<ServiceItem>>{}.obs;
  List<ServiceItem> get selectedCategoryServices =>
      smallCategories[selectedCategory.value] ?? [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  final RxBool fromProfile = false.obs;

  RxBool isLoading = false.obs;
  @override
  void onInit() {
    super.onInit();
    if (kDebugMode) {
      print('🎯 ServiceController onInit() called');
    }
    getPredefinedServices();
    fromProfile.value = Get.arguments == true;
    loadCategories();
  }

  void setLoading(bool value) {
    isLoading(value);
  }

  getPredefinedServices() async {
    setLoading(true);
    if (kDebugMode) {
      print('🔄 Starting getPredefinedServices()');
    }
    try {
      var data =
          await FirebaseFirestore.instance
              .collection('Services')
              .doc('smalljoblist')
              .get();
      MainServiceModel dataModel = MainServiceModel.fromMap(data.data()!);

      // Create a map to store filtered services
      Map<String, List<ServiceItem>> filteredServices = {};

      // Process all categories in parallel
      await Future.wait(
        dataModel.predefinedServices.entries.map((entry) async {
          String category = entry.key;
          List<ServiceItem> services = entry.value;

          // Process all services in this category in parallel
          List<ServiceItem> validServices = [];
          List<Future<void>> serviceFutures =
              services.map((serviceItem) async {
                (double?, double?) priceRange = await getPriceRange(
                  serviceItem.id,
                );
                if (priceRange.$1 != null && priceRange.$2 != null) {
                  serviceItem.lowestPrice = priceRange.$1;
                  serviceItem.highestPrice = priceRange.$2;
                  validServices.add(serviceItem);
                }
              }).toList();

          await Future.wait(serviceFutures);

          // Only add category if it has valid services
          if (validServices.isNotEmpty) {
            // Sort services by name (title) alphabetically
            validServices.sort(
              (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
            );
            filteredServices[category] = validServices;
          } else {
            filteredServices[category] = [];
          }
        }),
      );

      // Sort the categories by name and create a new sorted map
      final sortedFilteredServices = sortCategoriesByName(filteredServices);

      // Create a new MainServiceModel with sorted filtered services
      predefinedSmallJobs = MainServiceModel(
        createdAt: dataModel.createdAt,
        updatedAt: dataModel.updatedAt,
        predefinedServices: sortedFilteredServices,
      );

      // Update the reactive smallCategories map
      smallCategories.clear();
      smallCategories.addAll(sortedFilteredServices);

      if (kDebugMode) {
        print(
          '✅ Loaded ${smallCategories.keys.length} categories: ${smallCategories.keys.join(", ")}',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching predefined services: $e');
      }
      Get.snackbar('Error', 'Failed to fetch services: ${e.toString()}');
    } finally {
      setLoading(false);
    }
  }

  void selectService(String category) {
    selectedCategory(category);
  }

  /// Helper method to sort services by name alphabetically
  void sortServicesByName(List<ServiceItem> services) {
    services.sort(
      (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
    );
  }

  /// Helper method to sort categories by name alphabetically
  Map<String, List<ServiceItem>> sortCategoriesByName(
    Map<String, List<ServiceItem>> categoriesMap,
  ) {
    final sortedCategories = <String, List<ServiceItem>>{};
    final sortedCategoryNames =
        categoriesMap.keys.toList()
          ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

    for (final categoryName in sortedCategoryNames) {
      sortedCategories[categoryName] = categoriesMap[categoryName]!;
    }

    return sortedCategories;
  }

  Future<void> loadCategories() async {
    isLoading(true);
    try {
      if (userId.isEmpty) {
        Get.snackbar('Error', 'User not authenticated');
        isLoading(false);
        return;
      }

      categories.clear();
      categories['Custom Services'] = [];

      // final userDoc = await _firestore.collection('users').doc(userId).get();
      final servicesPricesSnap =
          await _firestore
              .collection('services_prices')
              .where('jobType', isEqualTo: 'smallJob')
              .where('trader_id', isEqualTo: userId)
              .get();
      final snapshot =
          await _firestore.collection('Services').doc('smalljoblist').get();

      if (!snapshot.exists || snapshot.data() == null) {
        Get.snackbar(
          'Warning',
          'No services found in smalljoblist. You can add custom services.',
        );
      } else {
        final data = snapshot.data()!;
        final predefinedServices =
            data['predefinedServices'] as Map<String, dynamic>? ?? {};

        for (String category in predefinedServices.keys) {
          final servicesList = predefinedServices[category] as List? ?? [];
          final services =
              servicesList
                  .map((item) {
                    if (item is Map<String, dynamic>) {
                      return ServiceItem.fromMap(item);
                    }
                    return null;
                  })
                  .where((item) => item != null)
                  .cast<ServiceItem>()
                  .toList();

          // Sort services by name (title) alphabetically
          sortServicesByName(services);

          categories[category] = services;
        }
      }

      // if (userDoc.exists && userDoc.data()!.containsKey('smalljoblist')) {
      List<QueryDocumentSnapshot<Map<String, dynamic>>> userServices =
          servicesPricesSnap.docs;

      for (QueryDocumentSnapshot<Map<String, dynamic>> userService
          in userServices) {
        final categoryValue = userService.data()['category'];
        if (categoryValue == null) {
          continue;
        }
        final category = categoryValue as String;

        // Check if userService.id is not null and contains underscore
        if (userService.id.isEmpty || !userService.id.contains('_')) {
          continue;
        }

        final serviceParts = userService.id.split("_");
        if (serviceParts.length < 2) {
          continue;
        }

        // Ensure category exists in categories map
        if (!categories.containsKey(category)) {
          categories[category] = [];
        }

        final index =
            categories[category]?.indexWhere(
              (item) => item.id == serviceParts[1],
            ) ??
            -1;

        if (index != -1) {
          try {
            categories[category]![index] = ServiceItem.fromMap(
              userService.data(),
            );
          } catch (e) {
            if (kDebugMode) {
              print('Error updating service in $category: $e');
            }
          }
        } else {
          try {
            categories[category]!.add(ServiceItem.fromMap(userService.data()));
          } catch (e) {
            if (kDebugMode) {
              print('Error adding service to $category: $e');
            }
          }
        }
      }

      // Sort all categories by service name after processing user services
      for (String category in categories.keys) {
        if (categories[category]!.isNotEmpty) {
          sortServicesByName(categories[category]!);
        }
      }

      // Sort categories by category name to ensure consistent ordering
      final sortedCategories = sortCategoriesByName(categories);

      // Replace the categories with sorted version
      categories.clear();
      categories.addAll(sortedCategories);
      // }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load services: ${e.toString()}');
    } finally {
      isLoading(false);
    }
  }

  Future<(double?, double?)> getPriceRange(String jobId) async {
    double? lowPrice;
    double? highPrice;
    QuerySnapshot lowPriceSnapshot =
        await FirebaseFirestore.instance
            .collection('services_prices')
            .where('jobId', isEqualTo: jobId)
            .orderBy('price', descending: false)
            .limit(1)
            .get();
    QuerySnapshot highPriceSnapshot =
        await FirebaseFirestore.instance
            .collection('services_prices')
            .where('jobId', isEqualTo: jobId)
            .orderBy('price', descending: true)
            .limit(1)
            .get();

    if (lowPriceSnapshot.docs.isNotEmpty) {
      ServiceItem lowPriceItem = ServiceItem.fromMap(
        lowPriceSnapshot.docs.first.data() as Map<String, dynamic>,
      );
      lowPrice = lowPriceItem.price;
    }

    if (highPriceSnapshot.docs.isNotEmpty) {
      ServiceItem highPriceItem = ServiceItem.fromMap(
        highPriceSnapshot.docs.first.data() as Map<String, dynamic>,
      );
      highPrice = highPriceItem.price;
    }

    return (lowPrice, highPrice);
  }

  void updateService(String category, int index, ServiceItem updatedService) {
    if (kDebugMode) {
      print('✏️ Updating service: ${updatedService.title} in $category');
    }
    categories[category]![index] = updatedService;

    // Re-sort the category to maintain alphabetical order
    sortServicesByName(categories[category]!);

    categories.refresh();
  }

  void addCustomService() {
    final service = ServiceItem(
      title: '',
      isCustom: true,
      id: FirebaseFirestore.instance.collection('Services').doc().id,
    );
    categories['Custom Services']!.add(service);
    selectService('Custom Services');
    categories.refresh();
    if (kDebugMode) {
      print('➕ Custom service added and selected.');
    }
  }

  void removeCustomService(String category, int index) {
    if (kDebugMode) {
      print('🗑 Removing custom service from $category at index $index');
    }
    categories[category]!.removeAt(index);
    categories.refresh();
  }

  int getEnabledServicesCount(String category) {
    final count = categories[category]?.where((s) => s.isEnabled).length ?? 0;
    if (kDebugMode) {
      print('✔️ $count enabled services in $category');
    }
    return count;
  }

  int getTotalServicesCount(String category) {
    final total = categories[category]?.length ?? 0;
    if (kDebugMode) {
      print('📊 $total total services in $category');
    }
    return total;
  }

  IconData getCategoryIcon(String category) {
    const icons = {
      'Custom Services': Icons.add,
      'Electrician': Icons.electrical_services,
      'Plumber': Icons.plumbing,
      'Carpenter / Joiner': Icons.handyman,
    };
    return icons[category] ?? Icons.build;
  }

  Future<void> saveUserServices() async {
    try {
      // Get count of enabled categories for logging
      final enabledCategoriesCount =
          categories.entries.where((entry) {
            final category = entry.key;
            final enabledServices =
                entry.value.where((s) => s.isEnabled).toList();
            return enabledServices.isNotEmpty || category == 'Custom Services';
          }).length;

      if (kDebugMode) {
        print('💾 Saving $enabledCategoriesCount categories to Firestore');
      }
      // await _firestore.collection('users').doc(userId).set({
      //   'smalljoblist': smalljobList,
      // }, SetOptions(merge: true));

      // Also save individual services with userId_serviceId format
      await saveIndividualServices();

      if (kDebugMode) {
        print('✅ Prices saved successfully!');
      }
      Get.snackbar('Success', 'Prices saved successfully');
      if (fromProfile.value) {
        // If came from profile, just go back
        Get.back();
      } else {
        // If came from signup flow, proceed to onboarding
        Get.off(() => const TradeRatePage());
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error saving services: $e');
      }
      Get.snackbar('Error', 'Failed to save services: ${e.toString()}');
    }
  }

  /// Save individual services with docId format: userId_serviceId
  Future<void> saveIndividualServices() async {
    try {
      if (kDebugMode) {
        print('💾 Saving individual services with userId_serviceId format...');
      }

      for (String category in categories.keys) {
        final servicesList = categories[category] ?? [];

        for (ServiceItem service in servicesList) {
          if (service.isEnabled &&
              service.price != null &&
              service.price! > 0) {
            // Use existing service ID
            final serviceId = service.id;
            final docId = '${userId}_$serviceId';

            final serviceData = {
              'name': service.title,
              'category': category,
              'jobId': serviceId,
              'jobType': 'smallJob',
              'price': service.price,
              'trader_id': userId,
              'description': service.description ?? '',
              'isCustom': service.isCustom,
              'createdAt': FieldValue.serverTimestamp(),
              'updatedAt': FieldValue.serverTimestamp(),
              'isEnabled': true,
            };

            await _firestore
                .collection('services_prices')
                .doc(docId)
                .set(serviceData, SetOptions(merge: true));

            if (kDebugMode) {
              print('✅ Saved service: ${service.title} with docId: $docId');
            }
          }
        }
      }

      if (kDebugMode) {
        print('✅ All individual services saved successfully!');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error saving individual services: $e');
      }
    }
  }

  /// Save a single service with userId_serviceId format
  Future<void> saveSingleService(String category, ServiceItem service) async {
    try {
      if (!service.isEnabled || service.price == null || service.price! <= 0) {
        if (kDebugMode) {
          print('⚠️ Service not enabled or price not set');
        }
        return;
      }

      // Use existing service ID
      final serviceId = service.id;
      final docId = '${userId}_$serviceId';

      final serviceData = {
        'name': service.title,
        'category': category,
        'jobId': serviceId,
        'jobType': 'smallJob',
        'price': service.price,
        'trader_id': userId,
        'description': service.description ?? '',
        'isCustom': service.isCustom,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'isEnabled': true,
      };

      await _firestore
          .collection('services_prices')
          .doc(docId)
          .set(serviceData, SetOptions(merge: true));

      if (kDebugMode) {
        print('✅ Single service saved: ${service.title} with docId: $docId');
      }
      Get.snackbar('Success', 'Service "${service.title}" saved successfully');
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error saving single service: $e');
      }
      Get.snackbar('Error', 'Failed to save service: ${e.toString()}');
    }
  }
}
