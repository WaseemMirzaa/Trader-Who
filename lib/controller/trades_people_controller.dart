import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:traderwho/models/models.dart';
import 'package:traderwho/models/review_model.dart';

class TradesPeopleController extends GetxController {
  static const int pageSize = 20;
  RxList<TradesPerson> tradesPeople = <TradesPerson>[].obs;
  RxList<TradesPerson> filteredTradesPeople = <TradesPerson>[].obs;
  RxBool isLoading = true.obs;
  RxBool isLoadingMore = false.obs;
  DocumentSnapshot? lastDoc;
  bool hasMore = true;

  // Filter properties
  RxString selectedCategory = ''.obs;
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
      selectedService.value = arguments['selectedService'] ?? '';
      selectedJobType.value = arguments['jobType'] ?? '';
      selectedServicePrice.value = arguments['servicePrice'] ?? 0.0;
    }
    fetchTradesPeople();
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

      final List<TradesPerson> loaded = [];
      for (final doc in query.docs) {
        TradesPerson tradesPerson = TradesPerson.fromDocumentSnapshot(doc);

        // Fetch services from services_prices collection
        tradesPerson = await _fetchTraderServices(tradesPerson);

        loaded.add(tradesPerson);
      }

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
      final List<TradesPerson> loaded = [];
      for (final doc in query.docs) {
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
        tradesPerson = await _fetchTraderServices(tradesPerson);

        loaded.add(tradesPerson);
      }
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

      for (final serviceDoc in servicesQuery.docs) {
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
