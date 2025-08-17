import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:traderwho/models/models.dart';

class JobPostController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final RxBool isLoading = false.obs;
  final RxMap<String, List<ServiceItem>> availableServices =
      <String, List<ServiceItem>>{}.obs;
  final RxMap<String, Map<String, double>> categoryPriceRanges =
      <String, Map<String, double>>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadAvailableServices();
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
          final category = serviceData['category'] as String? ?? 'Other';
          final price = (serviceData['price'] as num?)?.toDouble();

          // Skip services without valid price
          if (price == null || price <= 0) {
            print('⚠️ Skipping service without valid price: ${doc.id}');
            continue;
          }

          // Create ServiceItem from the data
          final serviceItem = ServiceItem.fromMap(serviceData);

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

      // Calculate price ranges for each category
      for (String category in categoryPrices.keys) {
        final prices = categoryPrices[category]!;
        if (prices.isNotEmpty) {
          prices.sort();
          final minPrice = prices.first;
          final maxPrice = prices.last;

          categoryPriceRanges[category] = {'min': minPrice, 'max': maxPrice};

          print('💰 $category price range: £$minPrice - £$maxPrice');
        }
      }

      // Update available services
      availableServices.addAll(categorizedServices);

      print(
        '✅ Loaded ${categorizedServices.keys.length} categories with services',
      );
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
      final servicesSnapshot =
          await _firestore
              .collection('services_prices')
              .where('jobType', isEqualTo: jobType)
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
          final category = serviceData['category'] as String? ?? 'Other';
          final price = (serviceData['price'] as num?)?.toDouble();

          // Skip services without valid price
          if (price == null || price <= 0) {
            print('⚠️ Skipping service without valid price: ${doc.id}');
            continue;
          }

          // Create ServiceItem from the data
          final serviceItem = ServiceItem.fromMap(serviceData);

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
