import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:traderwho/models/models.dart';
import 'package:traderwho/models/review_model.dart';
import 'package:traderwho/models/trades_people_model.dart';

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
    if (arguments != null) {
      selectedCategory.value = arguments['selectedCategory'] ?? '';
      selectedServiceId.value = arguments['service_id'] ?? '';
      selectedService.value = arguments['selectedService'] ?? '';
      selectedJobType.value = arguments['jobType'] ?? '';
      selectedServicePrice.value = arguments['servicePrice'] ?? 0.0;
    }
    fetchServices(selectedServiceId.value);
    // fetchTradesPeople();
  }

  void fetchServices(String serviceId) async {
    isLoading.value = true;
    try {
      final query =
          await FirebaseFirestore.instance
              .collection('services_prices')
              .where('jobId', isEqualTo: serviceId)
              .get();
      List<ServiceItem> services =
          query.docs.map((doc) => ServiceItem.fromMap(doc.data())).toList();

      // Process all services in parallel
      await Future.wait(
        services.map((service) async {
          TradesPerson trader = await getTrader(service.traderId ?? '-');
          service.tradesPerson = trader;
        }),
      );

      filteredServices.value = services;
    } catch (e) {
      print('Error fetching services: $e');
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
      final doc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(traderId)
              .get();
      if (doc.exists) {
        return await _fetchTraderServices(
          TradesPerson.fromDocumentSnapshot(doc),
        );
      } else {
        throw Exception('Trader not found');
      }
    } catch (e) {
      print('Error fetching trader: $e');
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
      // Fetch all services for this trader
      final servicesQuery =
          await FirebaseFirestore.instance
              .collection('services_prices')
              .where('trader_id', isEqualTo: tradesPerson.id)
              .where('isEnabled', isEqualTo: true)
              .get();

      // Organize services by category and jobType
      Map<String, List<ServiceItem>> largeJobsMap = {};
      Map<String, List<ServiceItem>> smallJobsMap = {};

      // Process all service documents in parallel (though this is mainly data transformation)
      final serviceItems =
          servicesQuery.docs.map((serviceDoc) {
            final serviceData = serviceDoc.data();
            final category = serviceData['category'] as String? ?? 'Other';
            final jobType = serviceData['jobType'] as String? ?? 'smallJob';

            final serviceItem = ServiceItem(
              id: serviceData['jobId'] ?? serviceDoc.id,
              title: serviceData['name'] ?? '',
              description: serviceData['description'] ?? '',
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

        if (jobType == 'largeJob') {
          if (!largeJobsMap.containsKey(category)) {
            largeJobsMap[category] = [];
          }
          largeJobsMap[category]!.add(serviceItem);
        } else if (jobType == 'smallJob') {
          if (!smallJobsMap.containsKey(category)) {
            smallJobsMap[category] = [];
          }
          smallJobsMap[category]!.add(serviceItem);
        }
      }

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
