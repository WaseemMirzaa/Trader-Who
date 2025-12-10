import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:traderou/models/models.dart';
import 'package:traderou/models/review_model.dart';
import 'package:traderou/models/trades_people_model.dart';

class TradesPeopleController extends GetxController {
  static const int pageSize = 20;
  RxList<TradesPerson> tradesPeople = <TradesPerson>[].obs;
  RxList<TradesPerson> filteredTradesPeople = <TradesPerson>[].obs;
  RxList<ServiceItem> filteredServices = <ServiceItem>[].obs;
  RxBool isLoading = true.obs;
  RxBool isLoadingMore = false.obs;
  DocumentSnapshot? lastDoc;
  bool hasMore = true;

  // Filter properties
  RxString selectedCategory = ''.obs;
  RxString selectedServiceId = ''.obs;
  RxString selectedService = ''.obs;
  RxString selectedJobType = ''.obs;
  RxDouble selectedServicePrice = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    // Check if arguments are passed (from navigation)
    final arguments = Get.arguments as Map<String, dynamic>?;

    print('🔍 TradesPeopleController.onInit - Received arguments: $arguments');

    if (arguments != null) {
      selectedCategory.value = arguments['selectedCategory'] ?? '';
      selectedServiceId.value = arguments['service_id'] ?? '';
      selectedService.value = arguments['selectedService'] ?? '';
      selectedJobType.value = arguments['jobType'] ?? '';
      selectedServicePrice.value = arguments['servicePrice'] ?? 0.0;

      print('📋 Parsed arguments:');
      print('  Category: ${selectedCategory.value}');
      print('  Category Name: ${arguments['categoryName']}');
      print('  Service ID: ${selectedServiceId.value}');
      print('  Service: ${selectedService.value}');
      print('  Job Type: ${selectedJobType.value}');
      print('  Price: ${selectedServicePrice.value}');
    } else {
      print('⚠️ No arguments passed to TradesPeopleController');
    }

    // For smallJob, fetch by specific service ID
    // For largeJob, fetch traders directly by title (no service_prices check)
    if (selectedJobType.value == 'smallJob' &&
        selectedServiceId.value.isNotEmpty) {
      print(
        '📍 Fetching services for smallJob with serviceId: ${selectedServiceId.value}',
      );
      fetchServices(selectedServiceId.value);
    } else if (selectedJobType.value == 'largeJob' &&
        selectedCategory.value.isNotEmpty) {
      final categoryName = arguments?['categoryName'] as String?;
      print(
        '📍 Fetching traders for largeJob with categoryName: $categoryName',
      );
      fetchTradersForLargeJob(categoryName: categoryName);
    } else {
      print(
        '⚠️ Unable to determine fetch strategy - JobType: ${selectedJobType.value}, ServiceId: ${selectedServiceId.value}, CategoryId: ${selectedCategory.value}',
      );
    }
    // fetchTradesPeople();
  }

  void fetchServices(String serviceId) async {
    isLoading.value = true;
    print(
      '🔍 TradesPeopleController.fetchServices called with serviceId: "$serviceId"',
    );

    try {
      if (serviceId.isEmpty) {
        print('⚠️ Service ID is empty, cannot fetch services');
        filteredServices.value = [];
        return;
      }

      print('🔍 Querying services_prices where jobId == "$serviceId"');
      final query =
          await FirebaseFirestore.instance
              .collection('services_prices')
              .where('jobId', isEqualTo: serviceId)
              .get();

      print('📊 Found ${query.docs.length} service prices');

      List<ServiceItem> services =
          query.docs.map((doc) {
            print('📄 Processing service doc: ${doc.id}');
            print('   Data: ${doc.data()}');
            return ServiceItem.fromMap(doc.data());
          }).toList();

      print(
        '🔍 Processing ${services.length} services to fetch trader data...',
      );

      // Process all services in parallel
      await Future.wait(
        services.map((service) async {
          if (service.traderId == null || service.traderId!.isEmpty) {
            print('⚠️ Service "${service.title}" has no traderId, skipping');
            return;
          }

          try {
            TradesPerson trader = await getTrader(service.traderId!);
            service.tradesPerson = trader;
            print('✅ Linked trader ${trader.name} to service ${service.title}');
          } catch (e) {
            print('❌ Failed to fetch trader for service ${service.title}: $e');
          }
        }),
      );

      // Filter out services without traders
      services = services.where((s) => s.tradesPerson != null).toList();

      filteredServices.value = services;
      print(
        '✅ Successfully loaded ${services.length} services with trader data',
      );
    } catch (e) {
      print('❌ Error fetching services: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch services by category and job type (for largeJob)
  void fetchServicesByCategory(
    String categoryId,
    String jobType, {
    String? categoryName,
  }) async {
    isLoading.value = true;
    print(
      '🔍 fetchServicesByCategory called with categoryId: "$categoryId", jobType: "$jobType", categoryName: "$categoryName"',
    );

    try {
      if (categoryId.isEmpty) {
        print('⚠️ Category ID is empty, cannot fetch services');
        filteredServices.value = [];
        return;
      }

      print(
        '🔍 Querying services_prices where categoryId == "$categoryId" and jobType == "$jobType"',
      );
      final query =
          await FirebaseFirestore.instance
              .collection('services_prices')
              .where('categoryId', isEqualTo: categoryId)
              .where('jobType', isEqualTo: jobType)
              .get();

      print('📊 Found ${query.docs.length} service prices for category');

      List<ServiceItem> services =
          query.docs.map((doc) {
            print('📄 Processing service doc: ${doc.id}');
            return ServiceItem.fromMap(doc.data());
          }).toList();

      print(
        '🔍 Processing ${services.length} services to fetch trader data...',
      );

      // Process all services in parallel
      await Future.wait(
        services.map((service) async {
          if (service.traderId == null || service.traderId!.isEmpty) {
            print('⚠️ Service "${service.title}" has no traderId, skipping');
            return;
          }

          try {
            TradesPerson trader = await getTrader(service.traderId!);

            // For large jobs, filter by trader's title field matching category name
            if (categoryName != null && trader.title != null) {
              final traderTitle = trader.title!.toLowerCase().trim();
              final catName = categoryName.toLowerCase().trim();

              // Check if trader's title matches the category name (exact match or contains)
              // This ensures only traders with matching expertise are shown
              if (traderTitle == catName || traderTitle.contains(catName)) {
                service.tradesPerson = trader;
                print(
                  '✅ Linked trader ${trader.name} (title: ${trader.title}) to service ${service.title}',
                );
              } else {
                print(
                  '⚠️ Skipping trader ${trader.name} - title "${trader.title}" does not match category "$categoryName"',
                );
              }
            } else if (categoryName != null && trader.title == null) {
              // If category name is provided but trader has no title, skip this trader
              print(
                '⚠️ Skipping trader ${trader.name} - no title set (required for large jobs)',
              );
            } else {
              // No category name provided, include the trader
              service.tradesPerson = trader;
              print(
                '✅ Linked trader ${trader.name} to service ${service.title}',
              );
            }
          } catch (e) {
            print('❌ Failed to fetch trader for service ${service.title}: $e');
          }
        }),
      );

      // Filter out services without traders
      services = services.where((s) => s.tradesPerson != null).toList();

      filteredServices.value = services;
      print(
        '✅ Successfully loaded ${services.length} services with trader data for category',
      );
    } catch (e) {
      print('❌ Error fetching services by category: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch traders directly by title for large jobs (no service_prices check)
  Future<void> fetchTradersForLargeJob({String? categoryName}) async {
    isLoading.value = true;
    print(
      '🔍 fetchTradersForLargeJob called with categoryName: "$categoryName"',
    );

    try {
      if (categoryName == null || categoryName.isEmpty) {
        print('⚠️ Category name is empty, cannot fetch traders');
        filteredServices.value = [];
        return;
      }

      print(
        '🔍 Querying users where user_type is "tradesperson" and title matches "$categoryName"',
      );

      // Query users collection where user_type is tradesperson
      final query =
          await FirebaseFirestore.instance
              .collection('users')
              .where('user_type', isEqualTo: 'tradesperson')
              .get();

      print(
        '📊 Found ${query.docs.length} tradesperson users, filtering by title...',
      );

      List<ServiceItem> traderServices = [];

      for (var doc in query.docs) {
        try {
          final data = doc.data();
          final traderTitle = (data['title'] as String?)?.toLowerCase().trim();
          final categoryLower = categoryName.toLowerCase().trim();

          // Check if trader's title matches the category
          if (traderTitle != null &&
              (traderTitle == categoryLower ||
                  traderTitle.contains(categoryLower))) {
            print(
              '✅ Found matching trader: ${data['name']} (title: ${data['title']})',
            );

            // Create TradesPerson from the trader data
            TradesPerson trader = TradesPerson.fromMap({...data, 'id': doc.id});

            // Create a ServiceItem for this trader (without specific service/price)
            ServiceItem serviceItem = ServiceItem(
              id: doc.id,
              traderId: doc.id,
              title: trader.title ?? categoryName,
              tradesPerson: trader,
            );

            traderServices.add(serviceItem);
          } else {
            print(
              '⚠️ Skipping trader ${data['name']} - title "$traderTitle" does not match category "$categoryName"',
            );
          }
        } catch (e) {
          print('❌ Error processing trader doc ${doc.id}: $e');
        }
      }

      filteredServices.value = traderServices;
      print(
        '✅ Successfully loaded ${traderServices.length} traders for large job category "$categoryName"',
      );
    } catch (e) {
      print('❌ Error fetching traders for large job: $e');
      filteredServices.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  /// Set filter criteria and refresh the list
  void setFilters({String? category, String? service, String? jobType}) {
    selectedCategory.value = category ?? '';
    selectedService.value = service ?? '';
    selectedJobType.value = jobType ?? '';
    _applyFilters();
  }

  /// Apply filters to the loaded tradespeople
  void _applyFilters() {
    if (selectedCategory.value.isEmpty &&
        selectedService.value.isEmpty &&
        selectedJobType.value.isEmpty) {
      // No filters, show all tradespeople
      filteredTradesPeople.value = List.from(tradesPeople);
      return;
    }

    filteredTradesPeople.value =
        tradesPeople.where((trader) {
          // Filter by category - check if trader offers services in the selected category
          if (selectedCategory.value.isNotEmpty) {
            bool hasCategory = false;

            if (selectedJobType.value == 'largeJob' ||
                selectedJobType.value.isEmpty) {
              hasCategory = trader.largeJobs.any(
                (job) =>
                    job.category.toLowerCase() ==
                    selectedCategory.value.toLowerCase(),
              );
            }

            if (!hasCategory &&
                (selectedJobType.value == 'smallJob' ||
                    selectedJobType.value.isEmpty)) {
              hasCategory = trader.smallJobs.any(
                (job) =>
                    job.category.toLowerCase() ==
                    selectedCategory.value.toLowerCase(),
              );
            }

            if (!hasCategory) return false;
          }

          // Filter by specific service
          if (selectedService.value.isNotEmpty) {
            bool hasService = false;

            if (selectedJobType.value == 'largeJob' ||
                selectedJobType.value.isEmpty) {
              hasService = trader.largeJobs.any(
                (job) => job.services.any(
                  (service) => service.title.toLowerCase().contains(
                    selectedService.value.toLowerCase(),
                  ),
                ),
              );
            }

            if (!hasService &&
                (selectedJobType.value == 'smallJob' ||
                    selectedJobType.value.isEmpty)) {
              hasService = trader.smallJobs.any(
                (job) => job.services.any(
                  (service) => service.title.toLowerCase().contains(
                    selectedService.value.toLowerCase(),
                  ),
                ),
              );
            }

            if (!hasService) return false;
          }

          return true;
        }).toList();

    print(
      '🔍 Applied filters - Found ${filteredTradesPeople.length} relevant traders',
    );
    print(
      '📊 Filter criteria: Category: ${selectedCategory.value}, Service: ${selectedService.value}, JobType: ${selectedJobType.value}',
    );
  }

  Future<TradesPerson> getTrader(String traderId) async {
    try {
      print('👤 Fetching trader with ID: $traderId');

      final doc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(traderId)
              .get();

      if (doc.exists) {
        print('✅ Found trader: ${doc.data()?['name'] ?? 'Unknown'}');
        return await _fetchTraderServices(
          TradesPerson.fromDocumentSnapshot(doc),
        );
      } else {
        print('❌ Trader not found with ID: $traderId');
        throw Exception('Trader not found');
      }
    } catch (e) {
      print('❌ Error fetching trader $traderId: $e');
      rethrow;
    }
  }

  Future<void> fetchTradesPeople() async {
    isLoading.value = true;
    try {
      final query =
          await FirebaseFirestore.instance
              .collection('users')
              .where('user_type', isEqualTo: 'tradesperson')
              .orderBy('name')
              .limit(pageSize)
              .get();

      // Process all traders in parallel
      final List<TradesPerson> loaded = await Future.wait(
        query.docs.map((doc) async {
          TradesPerson tradesPerson = TradesPerson.fromDocumentSnapshot(doc);
          // Fetch services from services_prices collection
          return await _fetchTraderServices(tradesPerson);
        }),
      );

      tradesPeople.value = loaded;

      // Apply any active filters
      _applyFilters();

      if (query.docs.isNotEmpty) {
        lastDoc = query.docs.last;
      }
      hasMore = query.docs.length == pageSize;

      print('✅ Successfully fetched ${tradesPeople.length} trades people');
      print(
        '🔍 After filtering: ${filteredTradesPeople.length} relevant traders',
      );
    } catch (e) {
      tradesPeople.value = [];
      print('❌ Error fetching tradespeople: $e');
    }
    isLoading.value = false;
  }

  Future<void> fetchMoreTradesPeople() async {
    if (!hasMore || isLoadingMore.value) return;
    isLoadingMore.value = true;
    try {
      Query queryRef = FirebaseFirestore.instance
          .collection('users')
          .where('user_type', isEqualTo: 'tradesperson')
          .orderBy('name')
          .limit(pageSize);
      if (lastDoc != null) {
        queryRef = queryRef.startAfterDocument(lastDoc!);
      }
      final query = await queryRef.get();

      // Process all traders in parallel
      final List<TradesPerson> loaded = await Future.wait(
        query.docs.map((doc) async {
          TradesPerson tradesPerson = TradesPerson.fromDocumentSnapshot(doc);

          // Fetch reviews from subCollection
          QuerySnapshot<Map<String, dynamic>> reviewsSnapshot =
              await doc.reference.collection('reviews').get();
          final reviews =
              reviewsSnapshot.docs.map((reviewDoc) {
                return ReviewModel.fromDoc(reviewDoc);
              }).toList();
          // Attach reviews to tradesPerson if the model supports it
          tradesPerson.reviews = reviews;

          // Fetch services from services_prices collection
          return await _fetchTraderServices(tradesPerson);
        }),
      );

      if (query.docs.isNotEmpty) {
        lastDoc = query.docs.last;
        tradesPeople.addAll(loaded);
        // Reapply filters after adding new traders
        _applyFilters();
      }
      hasMore = query.docs.length == pageSize;
    } catch (e) {
      print('❌ Error fetching more tradespeople: $e');
      // ignore
    }
    isLoadingMore.value = false;
  }

  /// Fetch services for a trader from services_prices collection and organize by jobType
  Future<TradesPerson> _fetchTraderServices(TradesPerson tradesPerson) async {
    try {
      print(
        '🔍 Fetching services for trader: ${tradesPerson.name} (${tradesPerson.id})',
      );

      // Fetch all services for this trader - using 'traderId' (camelCase)
      final servicesQuery =
          await FirebaseFirestore.instance
              .collection('services_prices')
              .where('traderId', isEqualTo: tradesPerson.id)
              .where('isEnabled', isEqualTo: true)
              .get();

      print(
        '📊 Found ${servicesQuery.docs.length} services for trader ${tradesPerson.name}',
      );

      // Organize services by category and jobType
      Map<String, List<ServiceItem>> largeJobsMap = {};
      Map<String, List<ServiceItem>> smallJobsMap = {};

      // Process all service documents in parallel (though this is mainly data transformation)
      final serviceItems =
          servicesQuery.docs.map((serviceDoc) {
            final serviceData = serviceDoc.data();

            // Use new schema field names
            final category =
                serviceData['categoryName'] as String? ??
                serviceData['category'] as String? ??
                'Other';
            final jobType = serviceData['jobType'] as String? ?? 'small';

            print(
              '  📄 Service: ${serviceData['jobTitle']} - Category: $category, Type: $jobType',
            );

            final serviceItem = ServiceItem(
              id: serviceData['jobId'] ?? serviceDoc.id,
              title:
                  serviceData['jobTitle'] ??
                  serviceData['name'] ??
                  serviceData['customTitle'] ??
                  '',
              description:
                  serviceData['customDescription'] ??
                  serviceData['description'] ??
                  '',
              price: (serviceData['price'] as num?)?.toDouble(),
              isEnabled: serviceData['isEnabled'] ?? false,
              isCustom: serviceData['isCustom'] ?? false,
            );

            return {
              'serviceItem': serviceItem,
              'category': category,
              'jobType': jobType,
            };
          }).toList();

      // Group services by category and job type
      for (final item in serviceItems) {
        final serviceItem = item['serviceItem'] as ServiceItem;
        final category = item['category'] as String;
        final jobType = item['jobType'] as String;

        if (jobType == 'large' || jobType == 'largeJob') {
          if (!largeJobsMap.containsKey(category)) {
            largeJobsMap[category] = [];
          }
          largeJobsMap[category]!.add(serviceItem);
        } else if (jobType == 'small' || jobType == 'smallJob') {
          if (!smallJobsMap.containsKey(category)) {
            smallJobsMap[category] = [];
          }
          smallJobsMap[category]!.add(serviceItem);
        }
      }

      print(
        '✅ Organized services: ${largeJobsMap.length} large job categories, ${smallJobsMap.length} small job categories',
      );

      // Convert maps to ServiceModel lists
      final largeJobs =
          largeJobsMap.entries
              .map(
                (entry) =>
                    ServiceModel(category: entry.key, services: entry.value),
              )
              .toList();

      final smallJobs =
          smallJobsMap.entries
              .map(
                (entry) =>
                    ServiceModel(category: entry.key, services: entry.value),
              )
              .toList();

      print(
        '✅ Created ${largeJobs.length} large job categories and ${smallJobs.length} small job categories for ${tradesPerson.name}',
      );

      // Create new TradesPerson with updated services
      return TradesPerson(
        name: tradesPerson.name,
        expertise: tradesPerson.expertise,
        description: tradesPerson.description,
        price: tradesPerson.price,
        imageUrl: tradesPerson.imageUrl,
        rating: tradesPerson.rating,
        services: tradesPerson.services,
        id: tradesPerson.id,
        bio: tradesPerson.bio,
        largeJobs: largeJobs,
        smallJobs: smallJobs,
        phoneNumber: tradesPerson.phoneNumber,
        reviews: tradesPerson.reviews,
        startTime: tradesPerson.startTime,
        endTime: tradesPerson.endTime,
        latitude: tradesPerson.latitude,
        longitude: tradesPerson.longitude,
        title: tradesPerson.title,
      );
    } catch (e) {
      print('❌ Error fetching services for trader ${tradesPerson.id}: $e');
      return tradesPerson; // Return original if error occurs
    }
  }

  /// Get current booking information for selected criteria
  Map<String, String> getCurrentBookingInfo() {
    return {
      'category':
          selectedCategory.value.isNotEmpty
              ? selectedCategory.value
              : 'General',
      'service':
          selectedService.value.isNotEmpty
              ? selectedService.value
              : '${selectedCategory.value} Service',
      'jobType':
          selectedJobType.value.isNotEmpty ? selectedJobType.value : 'largeJob',
    };
  }

  @override
  void onClose() {
    tradesPeople.clear();
    super.onClose();
  }
}
