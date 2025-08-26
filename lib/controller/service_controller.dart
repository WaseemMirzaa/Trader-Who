import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traderwho/models/main_service_model.dart';
import 'package:traderwho/models/models.dart';
import 'package:traderwho/views/trades_profile/presentation/pages/pages.dart';
import 'package:traderwho/views/trades_profile/presentation/pages/trade_large_job_rate_page.dart';

class ServiceController extends GetxController {
  MainServiceModel? predefinedSmallJobs;
  MainServiceModel? predefinedLargeJobs;
  RxString selectedCategory = RxString('');
  final RxMap<String, List<ServiceItem>> smallCategories =
      <String, List<ServiceItem>>{}.obs;
  final RxMap<String, List<ServiceItem>> largeCategories =
      <String, List<ServiceItem>>{}.obs;
  Rx<ServiceItem?> selectedService = Rx<ServiceItem?>(null);

  /// Returns categories sorted alphabetically by category name
  /// Note: Categories are already sorted in the underlying data structure
  List<String> get sortedCategoryNames {
    return smallCategories.keys.toList();
  }

  List<String> get sortedLargeCategoryNames {
    return largeCategories.keys.toList();
  }

  // Note: Removed allCategories and allCategoryNames getters to keep
  // small and large job categories separate as they have different structures

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
    // Load both small and large jobs
    getPredefinedServices();
    getPredefinedLargeJobs();
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

  getPredefinedLargeJobs() async {
    if (kDebugMode) {
      print('🔄 Starting getPredefinedLargeJobs()');
    }
    try {
      var data =
          await FirebaseFirestore.instance
              .collection('Services')
              .doc('largejoblist')
              .get();

      if (!data.exists) {
        if (kDebugMode) {
          print('❌ largejoblist document does not exist');
        }
        // This is not an error since large jobs might not be set up yet
        return;
      }

      if (kDebugMode) {
        print('✅ largejoblist document found');
      }

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
                try {
                  (double?, double?) priceRange = await getPriceRange(
                    serviceItem.id,
                  );
                  if (priceRange.$1 != null && priceRange.$2 != null) {
                    serviceItem.lowestPrice = priceRange.$1;
                    serviceItem.highestPrice = priceRange.$2;
                    validServices.add(serviceItem);
                  }
                } catch (e) {
                  if (kDebugMode) {
                    print(
                      '⚠️ Error getting price range for ${serviceItem.id}: $e',
                    );
                  }
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
      predefinedLargeJobs = MainServiceModel(
        createdAt: dataModel.createdAt,
        updatedAt: dataModel.updatedAt,
        predefinedServices: sortedFilteredServices,
      );

      // Update the reactive largeCategories map
      largeCategories.clear();
      largeCategories.addAll(sortedFilteredServices);

      if (kDebugMode) {
        print(
          '✅ Loaded ${largeCategories.keys.length} large job categories: ${largeCategories.keys.join(", ")}',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching predefined large jobs: $e');
      }
      // Don't show error snackbar for large jobs as they might not be set up yet
    }
  }

  void selectService(String category) {
    selectedCategory(category);
  }

  /// Get services for a category, checking both small and large jobs
  List<ServiceItem> getServicesForCategory(String category) {
    if (smallCategories.containsKey(category)) {
      return smallCategories[category] ?? [];
    } else if (largeCategories.containsKey(category)) {
      return largeCategories[category] ?? [];
    }
    return [];
  }

  /// Check if a category is from small jobs
  bool isSmallJobCategory(String category) {
    return smallCategories.containsKey(category);
  }

  /// Check if a category is from large jobs
  bool isLargeJobCategory(String category) {
    return largeCategories.containsKey(category);
  }

  /// Helper method to sort services by name alphabetically
  void sortServicesByName(List<ServiceItem> services) {
    services.sort(
      (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
    );
  }

  /// Helper method to sort categories by name alphabetically, with Custom Services first
  Map<String, List<ServiceItem>> sortCategoriesByName(
    Map<String, List<ServiceItem>> categoriesMap,
  ) {
    final sortedCategories = <String, List<ServiceItem>>{};

    // Always put Custom Services first
    if (categoriesMap.containsKey('Custom Services')) {
      sortedCategories['Custom Services'] = categoriesMap['Custom Services']!;
    }

    // Sort remaining categories alphabetically
    final otherCategoryNames =
        categoriesMap.keys.where((name) => name != 'Custom Services').toList()
          ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

    for (final categoryName in otherCategoryNames) {
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

      // Initialize Custom Services for both small and large categories
      smallCategories.clear();
      largeCategories.clear();
      smallCategories['Custom Services'] = [];
      largeCategories['Custom Services'] = [];

      // Load both small and large job prices
      final smallJobPricesSnap =
          await _firestore
              .collection('services_prices')
              .where('jobType', isEqualTo: 'smallJob')
              .where('trader_id', isEqualTo: userId)
              .get();

      final largeJobPricesSnap =
          await _firestore
              .collection('services_prices')
              .where('jobType', isEqualTo: 'largeJob')
              .where('trader_id', isEqualTo: userId)
              .get();
      // Load small job predefined services
      final smallJobSnapshot =
          await _firestore.collection('Services').doc('smalljoblist').get();

      if (!smallJobSnapshot.exists || smallJobSnapshot.data() == null) {
        Get.snackbar(
          'Warning',
          'No services found in smalljoblist. You can add custom services.',
        );
      } else {
        final data = smallJobSnapshot.data()!;
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

      // Load large job predefined services
      final largeJobSnapshot =
          await _firestore.collection('Services').doc('largejoblist').get();

      if (largeJobSnapshot.exists && largeJobSnapshot.data() != null) {
        final data = largeJobSnapshot.data()!;
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

          largeCategories[category] = services;
        }

        if (kDebugMode) {
          print(
            '✅ Loaded ${largeCategories.keys.length} large job categories for pricing',
          );
        }
      } else {
        if (kDebugMode) {
          print('⚠️ No largejoblist found in Services collection');
        }
      }

      // Process small job user services separately
      for (QueryDocumentSnapshot<Map<String, dynamic>> userService
          in smallJobPricesSnap.docs) {
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
              print('Error updating small job service in $category: $e');
            }
          }
        } else {
          try {
            categories[category]!.add(ServiceItem.fromMap(userService.data()));
          } catch (e) {
            if (kDebugMode) {
              print('Error adding small job service to $category: $e');
            }
          }
        }
      }

      // Process large job user services separately
      for (QueryDocumentSnapshot<Map<String, dynamic>> userService
          in largeJobPricesSnap.docs) {
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

        // Ensure category exists in largeCategories map
        if (!largeCategories.containsKey(category)) {
          largeCategories[category] = [];
        }

        final index =
            largeCategories[category]?.indexWhere(
              (item) => item.id == serviceParts[1],
            ) ??
            -1;

        if (index != -1) {
          try {
            largeCategories[category]![index] = ServiceItem.fromMap(
              userService.data(),
            );
          } catch (e) {
            if (kDebugMode) {
              print('Error updating large job service in $category: $e');
            }
          }
        } else {
          try {
            largeCategories[category]!.add(
              ServiceItem.fromMap(userService.data()),
            );
          } catch (e) {
            if (kDebugMode) {
              print('Error adding large job service to $category: $e');
            }
          }
        }
      }

      if (kDebugMode) {
        print(
          '📋 Processed ${smallJobPricesSnap.docs.length} small job services and ${largeJobPricesSnap.docs.length} large job services',
        );
      }

      // Sort all small job categories by service name after processing user services
      for (String category in categories.keys) {
        if (categories[category]!.isNotEmpty) {
          sortServicesByName(categories[category]!);
        }
      }

      // Sort all large job categories by service name after processing user services
      for (String category in largeCategories.keys) {
        if (largeCategories[category]!.isNotEmpty) {
          sortServicesByName(largeCategories[category]!);
        }
      }

      // Sort categories by category name to ensure consistent ordering
      final sortedSmallCategories = sortCategoriesByName(categories);
      final sortedLargeCategories = sortCategoriesByName(largeCategories);

      // Replace the categories with sorted versions
      categories.clear();
      categories.addAll(sortedSmallCategories);

      largeCategories.clear();
      largeCategories.addAll(sortedLargeCategories);
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

    // Update in the appropriate category map
    if (smallCategories.containsKey(category)) {
      smallCategories[category]![index] = updatedService;
      // Re-sort the category to maintain alphabetical order
      sortServicesByName(smallCategories[category]!);
      smallCategories.refresh();
    } else if (largeCategories.containsKey(category)) {
      largeCategories[category]![index] = updatedService;
      // Re-sort the category to maintain alphabetical order
      sortServicesByName(largeCategories[category]!);
      largeCategories.refresh();
    } else {
      // Fallback to categories for backward compatibility
      categories[category]![index] = updatedService;
      // Re-sort the category to maintain alphabetical order
      sortServicesByName(categories[category]!);
      categories.refresh();
    }
  }

  void addCustomService() {
    final service = ServiceItem(
      title: '',
      isCustom: true,
      id: FirebaseFirestore.instance.collection('Services').doc().id,
    );

    // Add to the appropriate category map
    if (smallCategories.containsKey('Custom Services')) {
      smallCategories['Custom Services']!.add(service);
      smallCategories.refresh();
    } else if (largeCategories.containsKey('Custom Services')) {
      largeCategories['Custom Services']!.add(service);
      largeCategories.refresh();
    } else {
      // Fallback to categories for backward compatibility
      categories['Custom Services']!.add(service);
      categories.refresh();
    }

    selectService('Custom Services');
    if (kDebugMode) {
      print('➕ Custom service added and selected.');
    }
  }

  void removeCustomService(String category, int index) {
    if (kDebugMode) {
      print('🗑 Removing custom service from $category at index $index');
    }

    // Remove from the appropriate category map
    if (smallCategories.containsKey(category)) {
      smallCategories[category]!.removeAt(index);
      smallCategories.refresh();
    } else if (largeCategories.containsKey(category)) {
      largeCategories[category]!.removeAt(index);
      largeCategories.refresh();
    } else {
      // Fallback to categories for backward compatibility
      categories[category]!.removeAt(index);
      categories.refresh();
    }
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

  /// Get enabled services count for small job categories
  int getEnabledSmallServicesCount(String category) {
    final count =
        smallCategories[category]?.where((s) => s.isEnabled).length ?? 0;
    if (kDebugMode) {
      print('✔️ $count enabled small job services in $category');
    }
    return count;
  }

  /// Get total services count for small job categories
  int getTotalSmallServicesCount(String category) {
    final total = smallCategories[category]?.length ?? 0;
    if (kDebugMode) {
      print('📊 $total total small job services in $category');
    }
    return total;
  }

  /// Get enabled services count for large job categories
  int getEnabledLargeServicesCount(String category) {
    final count =
        largeCategories[category]?.where((s) => s.isEnabled).length ?? 0;
    if (kDebugMode) {
      print('✔️ $count enabled large job services in $category');
    }
    return count;
  }

  /// Get total services count for large job categories
  int getTotalLargeServicesCount(String category) {
    final total = largeCategories[category]?.length ?? 0;
    if (kDebugMode) {
      print('📊 $total total large job services in $category');
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

  Future<void> saveUserServices({bool isFromLargeJob = false}) async {
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
      await saveIndividualServices(isLargeJob: isFromLargeJob);

      if (kDebugMode) {
        print('✅ Prices saved successfully!');
      }
      Get.snackbar('Success', 'Prices saved successfully');
      if (fromProfile.value) {
        // If came from profile, just go back
        Get.back();
      } else {
        isFromLargeJob
            ? Get.off(() => const TradeLargerRatePage())
            : Get.off(() => const TradeRatePage());
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error saving services: $e');
      }
      Get.snackbar('Error', 'Failed to save services: ${e.toString()}');
    }
  }

  /// Save individual services with docId format: userId_serviceId
  Future<void> saveIndividualServices({bool isLargeJob = false}) async {
    try {
      if (kDebugMode) {
        print('💾 Saving individual services with userId_serviceId format...');
      }

      // Choose the appropriate category map based on job type
      final Map<String, List<ServiceItem>> targetCategories =
          isLargeJob ? largeCategories : smallCategories;

      for (String category in targetCategories.keys) {
        final servicesList = targetCategories[category] ?? [];

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
              'jobType': isLargeJob ? 'largeJob' : 'smallJob',
              'price': service.price,
              'trader_id': userId,
              'description': service.description ?? '',
              'isCustom': service.isCustom,
              'createdAt': DateTime.now().millisecondsSinceEpoch,
              'updatedAt': DateTime.now().millisecondsSinceEpoch,
              'isEnabled': true,
            };

            await _firestore
                .collection('services_prices')
                .doc(docId)
                .set(serviceData, SetOptions(merge: true));

            if (kDebugMode) {
              print(
                '✅ Saved ${isLargeJob ? 'large' : 'small'} job service: ${service.title} with docId: $docId',
              );
            }
          }
        }
      }

      if (kDebugMode) {
        print(
          '✅ All individual ${isLargeJob ? 'large' : 'small'} job services saved successfully!',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error saving individual services: $e');
      }
    }
  }

  // /// Save a single service with userId_serviceId format
  // Future<void> saveSingleService(
  //   String category,
  //   ServiceItem service, {
  //   bool isLargeJob = false,
  // }) async {
  //   try {
  //     if (!service.isEnabled || service.price == null || service.price! <= 0) {
  //       if (kDebugMode) {
  //         print('⚠️ Service not enabled or price not set');
  //       }
  //       return;
  //     }

  //     // Use existing service ID
  //     final serviceId = service.id;
  //     final docId = '${userId}_$serviceId';

  //     final serviceData = {
  //       'name': service.title,
  //       'category': category,
  //       'jobId': serviceId,
  //       'jobType': isLargeJob ? 'largeJob' : 'smallJob',
  //       'price': service.price,
  //       'trader_id': userId,
  //       'description': service.description ?? '',
  //       'isCustom': service.isCustom,
  //       'createdAt': DateTime.now().millisecondsSinceEpoch,
  //       'updatedAt': DateTime.now().millisecondsSinceEpoch,
  //       'isEnabled': true,
  //     };

  //     await _firestore
  //         .collection('services_prices')
  //         .doc(docId)
  //         .set(serviceData, SetOptions(merge: true));

  //     if (kDebugMode) {
  //       print('✅ Single service saved: ${service.title} with docId: $docId');
  //     }
  //     Get.snackbar('Success', 'Service "${service.title}" saved successfully');
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print('❌ Error saving single service: $e');
  //     }
  //     Get.snackbar('Error', 'Failed to save service: ${e.toString()}');
  //   }
  // }
}
