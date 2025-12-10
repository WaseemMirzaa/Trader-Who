import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traderou/core/shared_widgets/map_picker_screen.dart';
import 'package:traderou/models/main_service_model.dart';
import 'package:traderou/models/models.dart';

class JobPostController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final RxBool isLoading = false.obs;
  final RxMap<String, List<ServiceItem>> availableServices =
      <String, List<ServiceItem>>{}.obs;
  final RxMap<String, Map<String, double>> categoryPriceRanges =
      <String, Map<String, double>>{}.obs;
  MainServiceModel? predefinedSmallJobs;
  Map<String, List<ServiceItem>> get smallCategories =>
      predefinedSmallJobs?.predefinedServices ?? {};
  String? address;
  RxDouble selectedLat = 0.0.obs;
  RxDouble selectedLon = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    getPredefinedServices();

    loadAvailableServices();
  }

  Future<void> pickLocationFromMap() async {
    try {
      final result = await Get.to<Map<String, dynamic>>(
        () => const MapPickerScreen(),
      );
      if (result != null) {
        address = result['address'];
        selectedLat.value = result['lat'];
        selectedLon.value = result['lon'];
      }
    } catch (e) {
      debugPrint("Error picking location: $e");
      Get.snackbar('Error', 'Could not pick location');
    }
  }

  getPredefinedServices() async {
    isLoading(true);
    try {
      // New DB: predefined quick jobs are stored as documents in `jobs` collection
      // We'll query for small jobs and group them by categoryName to build the
      // legacy-shaped MainServiceModel.predefinedServices map.
      final snapshot =
          await _firestore
              .collection('jobs')
              .where('jobType', isEqualTo: 'small')
              .where('isActive', isEqualTo: true)
              .orderBy('order')
              .get();

      final Map<String, List<ServiceItem>> grouped = {};

      for (final doc in snapshot.docs) {
        final data = doc.data();
        final title = data['title'] ?? '';
        final description = data['description'] ?? '';
        final categoryName = data['categoryName'] ?? 'Other';

        final serviceItem = ServiceItem(
          title: title,
          description: description,
          price: null,
          id: doc.id,
          isEnabled: false,
          isCustom: false,
        );

        grouped.putIfAbsent(categoryName, () => []).add(serviceItem);
      }

      // Sort each category's services alphabetically
      for (final key in grouped.keys) {
        grouped[key]!.sort(
          (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
        );
      }

      final sorted = sortCategoriesByName(grouped);

      predefinedSmallJobs = MainServiceModel(
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        predefinedServices: sorted,
      );
    } catch (e) {
      print('Error fetching predefined services: $e');
      Get.snackbar('Error', 'Failed to fetch services: ${e.toString()}');
    } finally {
      isLoading(false);
    }
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

  /// Load all available services from services_prices collection
  Future<void> loadAvailableServices() async {
    try {
      isLoading(true);
      print('📤 Loading available services for job posting...');

      // Clear existing data
      availableServices.clear();
      categoryPriceRanges.clear();

      // Query all services from services_prices collection
      final servicesSnapshot =
          await _firestore
              .collection('services_prices')
              .where('isEnabled', isEqualTo: true)
              .get();

      print('🧍 Found ${servicesSnapshot.docs.length} enabled services');

      // Group services by category
      Map<String, List<ServiceItem>> categorizedServices = {};
      Map<String, List<double>> categoryPrices = {};

      for (var doc in servicesSnapshot.docs) {
        try {
          final serviceData = doc.data();
          final category =
              serviceData['categoryName'] as String? ??
              serviceData['category'] as String? ??
              'Other';
          final price = (serviceData['price'] as num?)?.toDouble();

          // Skip services without valid price
          if (price == null || price <= 0) {
            print('⚠️ Skipping service without valid price: ${doc.id}');
            continue;
          }

          // Create ServiceItem from the services_prices document
          final serviceItem = ServiceItem(
            title: serviceData['jobTitle'] ?? serviceData['title'] ?? '',
            description:
                serviceData['customDescription'] ??
                serviceData['description'] ??
                '',
            price: price,
            lowestPrice:
                serviceData['lowestPrice'] != null
                    ? (serviceData['lowestPrice'] as num).toDouble()
                    : null,
            highestPrice:
                serviceData['highestPrice'] != null
                    ? (serviceData['highestPrice'] as num).toDouble()
                    : null,
            isEnabled: serviceData['isEnabled'] ?? true,
            isCustom: serviceData['isCustom'] ?? false,
            tradesPerson: null,
            traderId: serviceData['traderId'] ?? serviceData['trader_id'] ?? '',
            id: serviceData['jobId'] ?? doc.id,
          );

          // Group by category
          if (!categorizedServices.containsKey(category)) {
            categorizedServices[category] = [];
            categoryPrices[category] = [];
          }

          categorizedServices[category]!.add(serviceItem);
          categoryPrices[category]!.add(price);

          print('✅ Added service: ${serviceItem.title} to $category (£$price)');
        } catch (e) {
          print('⚠️ Error parsing service ${doc.id}: $e');
        }
      }

      // Calculate price ranges for each category and sort services
      for (String category in categoryPrices.keys) {
        final prices = categoryPrices[category]!;
        if (prices.isNotEmpty) {
          prices.sort();
          final minPrice = prices.first;
          final maxPrice = prices.last;

          categoryPriceRanges[category] = {'min': minPrice, 'max': maxPrice};

          // Sort services in this category by name
          categorizedServices[category]!.sort(
            (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
          );

          print('💰 $category price range: £$minPrice - £$maxPrice');
        }
      }

      // Sort categories by name and update available services
      final sortedServices = sortCategoriesByName(categorizedServices);
      availableServices.addAll(sortedServices);

      print('✅ Loaded ${sortedServices.keys.length} categories with services');
    } catch (e) {
      print('❌ Error loading available services: $e');
      Get.snackbar('Error', 'Failed to load services: ${e.toString()}');
    } finally {
      isLoading(false);
    }
  }

  /// Get services for a specific category
  List<ServiceItem> getServicesForCategory(String category) {
    return availableServices[category] ?? [];
  }

  /// Get services for a specific category and job type
  List<ServiceItem> getServicesForCategoryAndType(
    String category,
    String jobType,
  ) {
    final categoryServices = availableServices[category] ?? [];
    // Note: We can filter by jobType if needed, but since we're loading all services,
    // we might want to add jobType to the query in loadAvailableServices
    return categoryServices;
  }

  /// Get price range for a category
  Map<String, double>? getPriceRangeForCategory(String category) {
    return categoryPriceRanges[category];
  }

  /// Format price range as string
  String getFormattedPriceRange(String category) {
    final priceRange = getPriceRangeForCategory(category);
    if (priceRange == null) return 'Price on request';

    final min = priceRange['min']!.toInt();
    final max = priceRange['max']!.toInt();

    if (min == max) {
      return '£$min';
    } else {
      return '£$min - £$max';
    }
  }

  /// Get all available categories
  List<String> getAvailableCategories() {
    return availableServices.keys.toList()..sort();
  }

  /// Get services count for a category
  int getServicesCountForCategory(String category) {
    return availableServices[category]?.length ?? 0;
  }

  /// Load services for specific job type
  Future<void> loadServicesForJobType(String jobType) async {
    try {
      isLoading(true);
      print('📤 Loading services for job type: $jobType');

      // Clear existing data
      availableServices.clear();
      categoryPriceRanges.clear();

      // Query services by job type
      // Map UI jobType values (e.g., 'smallJob'/'largeJob') to DB values ('small'/'large')
      String dbJobType = jobType;
      if (jobType == 'smallJob') dbJobType = 'small';
      if (jobType == 'largeJob') dbJobType = 'large';

      final servicesSnapshot =
          await _firestore
              .collection('services_prices')
              .where('jobType', isEqualTo: dbJobType)
              .where('isEnabled', isEqualTo: true)
              .get();

      print(
        '🧍 Found ${servicesSnapshot.docs.length} enabled $jobType services',
      );

      // Group services by category
      Map<String, List<ServiceItem>> categorizedServices = {};
      Map<String, List<double>> categoryPrices = {};

      for (var doc in servicesSnapshot.docs) {
        try {
          final serviceData = doc.data();
          final category =
              serviceData['categoryName'] as String? ??
              serviceData['category'] as String? ??
              'Other';
          final price = (serviceData['price'] as num?)?.toDouble();

          // Skip services without valid price
          if (price == null || price <= 0) {
            print('⚠️ Skipping service without valid price: ${doc.id}');
            continue;
          }

          // Create ServiceItem from the data
          final serviceItem = ServiceItem(
            title: serviceData['jobTitle'] ?? serviceData['title'] ?? '',
            description:
                serviceData['customDescription'] ??
                serviceData['description'] ??
                '',
            price: price,
            lowestPrice:
                serviceData['lowestPrice'] != null
                    ? (serviceData['lowestPrice'] as num).toDouble()
                    : null,
            highestPrice:
                serviceData['highestPrice'] != null
                    ? (serviceData['highestPrice'] as num).toDouble()
                    : null,
            isEnabled: serviceData['isEnabled'] ?? true,
            isCustom: serviceData['isCustom'] ?? false,
            tradesPerson: null,
            traderId: serviceData['traderId'] ?? serviceData['trader_id'] ?? '',
            id: serviceData['jobId'] ?? doc.id,
          );

          // Group by category
          if (!categorizedServices.containsKey(category)) {
            categorizedServices[category] = [];
            categoryPrices[category] = [];
          }

          categorizedServices[category]!.add(serviceItem);
          categoryPrices[category]!.add(price);

          print(
            '✅ Added $jobType service: ${serviceItem.title} to $category (£$price)',
          );
        } catch (e) {
          print('⚠️ Error parsing service ${doc.id}: $e');
        }
      }

      // Calculate price ranges for each category
      for (String category in categoryPrices.keys) {
        final prices = categoryPrices[category]!;
        if (prices.isNotEmpty) {
          prices.sort();
          final minPrice = prices.first;
          final maxPrice = prices.last;

          categoryPriceRanges[category] = {'min': minPrice, 'max': maxPrice};

          print('💰 $category ($jobType) price range: £$minPrice - £$maxPrice');
        }
      }

      // Update available services
      availableServices.addAll(categorizedServices);

      print(
        '✅ Loaded ${categorizedServices.keys.length} categories for $jobType',
      );
    } catch (e) {
      print('❌ Error loading services for job type $jobType: $e');
      Get.snackbar(
        'Error',
        'Failed to load $jobType services: ${e.toString()}',
      );
    } finally {
      isLoading(false);
    }
  }
}
