import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:traderou/models/category_model.dart';
import 'package:traderou/models/models.dart';
import 'package:traderou/models/trader_service_model.dart';
import 'package:flutter/material.dart';
import 'package:traderou/views/trade_onboarding/presentation/pages/pages.dart';

/// New Service Controller using the efficient database structure
class NewServiceController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  // Observable lists
  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final RxList<JobModel> allJobs = <JobModel>[].obs;
  final RxMap<String, List<JobModel>> smallJobsByCategory =
      <String, List<JobModel>>{}.obs;
  final RxMap<String, List<JobModel>> largeJobsByCategory =
      <String, List<JobModel>>{}.obs;
  final RxList<TraderServiceModel> traderServices = <TraderServiceModel>[].obs;
  final RxString userCategoryId = RxString(''); // Trader's category from signup

  // Selection state
  final RxString selectedCategoryId = RxString('');
  final RxString selectedJobId = RxString(''); // Selected job/service ID
  final RxString selectedJobType = RxString('small'); // 'small' or 'large'

  // Loading states
  final RxBool isLoadingCategories = false.obs;
  final RxBool isLoadingJobs = false.obs;
  final RxBool isLoadingTraderServices = false.obs;
  final RxBool isLoading = false.obs;

  // Legacy compatibility for migration from ServiceController
  final RxString selectedCategory = RxString('');
  final RxMap<String, List<JobModel>> smallCategories =
      <String, List<JobModel>>{}.obs;
  final RxMap<String, List<JobModel>> largeCategories =
      <String, List<JobModel>>{}.obs;

  @override
  void onInit() {
    super.onInit();
    if (kDebugMode) {
      print('🎯 NewServiceController onInit() called');
    }
    loadAllData();
  }

  /// Load all data in parallel
  Future<void> loadAllData() async {
    isLoading(true);
    try {
      // Load user's category first
      await _loadUserCategory();

      // Then load other data
      await Future.wait([loadCategories(), loadJobs(), loadTraderServices()]);

      // Auto-select user's category if not coming from profile
      if (!fromProfile.value && userCategoryId.isNotEmpty) {
        selectedCategoryId(userCategoryId.value);
        selectedCategory(userCategoryId.value); // legacy compatibility
      }

      if (kDebugMode) {
        print('✅ All data loaded successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error loading data: $e');
      }
      Get.snackbar('Error', 'Failed to load data: ${e.toString()}');
    } finally {
      isLoading(false);
    }
  }

  /// Load user's category from their profile
  Future<void> _loadUserCategory() async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        final categoryId = userDoc.data()?['title'] as String?;
        if (categoryId != null && categoryId.isNotEmpty) {
          userCategoryId(categoryId);
          if (kDebugMode) {
            print('✅ Loaded user category: $categoryId');
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error loading user category: $e');
      }
    }
  }

  /// Load all categories from Firestore
  Future<void> loadCategories() async {
    isLoadingCategories(true);
    try {
      if (kDebugMode) {
        print('📂 Loading categories...');
      }

      final snapshot =
          await _firestore.collection('categories').orderBy('order').get();

      final loadedCategories =
          snapshot.docs
              .map((doc) => CategoryModel.fromDoc(doc))
              .toList()
              .cast<CategoryModel>();

      // Sort categories by name
      loadedCategories.sort(
        (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      );

      categories.value = loadedCategories;

      if (kDebugMode) {
        print('✅ Loaded ${categories.length} categories (sorted by name)');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error loading categories: $e');
      }
      rethrow;
    } finally {
      isLoadingCategories(false);
    }
  }

  /// Load all jobs and organize by category and type
  Future<void> loadJobs() async {
    isLoadingJobs(true);
    try {
      if (kDebugMode) {
        print('📋 Loading jobs...');
      }
      final snapshot =
          await _firestore
              .collection('jobs')
              .where('isActive', isEqualTo: true)
              .orderBy('order')
              .get();
      allJobs.value =
          snapshot.docs
              .map((doc) => JobModel.fromMap(doc.data(), doc.id))
              .toList();
      // Organize by category and type
      _organizeJobs();
      _syncLegacyCategoryMaps();
      if (kDebugMode) {
        print('✅ Loaded allJobs.length jobs');
        print('   - Small jobs categories: smallJobsByCategory.length');
        print('   - Large jobs categories: largeJobsByCategory.length');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error loading jobs: $e');
      }
      rethrow;
    } finally {
      isLoadingJobs(false);
    }
  }

  /// Organize jobs by category and type
  void _organizeJobs() {
    smallJobsByCategory.clear();
    largeJobsByCategory.clear();

    for (var job in allJobs) {
      // Only include jobs from trader's category (if userCategoryId is set)
      // If userCategoryId is empty, show all categories (for flexibility)
      if (userCategoryId.isNotEmpty && job.categoryId != userCategoryId.value) {
        continue; // Skip jobs not in trader's category
      }

      if (job.jobType == 'small') {
        if (!smallJobsByCategory.containsKey(job.categoryId)) {
          smallJobsByCategory[job.categoryId] = [];
        }
        smallJobsByCategory[job.categoryId]!.add(job);
      } else if (job.jobType == 'large') {
        if (!largeJobsByCategory.containsKey(job.categoryId)) {
          largeJobsByCategory[job.categoryId] = [];
        }
        largeJobsByCategory[job.categoryId]!.add(job);
      }
    }
  }

  /// Load trader's service prices
  Future<void> loadTraderServices() async {
    isLoadingTraderServices(true);
    try {
      if (kDebugMode) {
        print('👷 Loading trader services...');
      }

      final snapshot =
          await _firestore
              .collection('services_prices')
              .where('traderId', isEqualTo: userId)
              .get();

      traderServices.value =
          snapshot.docs
              .map((doc) => TraderServiceModel.fromMap(doc.data(), doc.id))
              .toList();

      if (kDebugMode) {
        print('✅ Loaded ${traderServices.length} trader services');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error loading trader services: $e');
      }
      rethrow;
    } finally {
      isLoadingTraderServices(false);
    }
  }

  /// Sync legacy category maps for compatibility
  void _syncLegacyCategoryMaps() {
    smallCategories.clear();
    largeCategories.clear();
    smallCategories.addAll(smallJobsByCategory);
    largeCategories.addAll(largeJobsByCategory);
  }

  /// Get jobs for a specific category and type
  List<JobModel> getJobsForCategory(String categoryId, String jobType) {
    List<JobModel> jobs;
    if (jobType == 'small') {
      jobs = smallJobsByCategory[categoryId] ?? [];
    } else {
      jobs = largeJobsByCategory[categoryId] ?? [];
    }

    // Sort jobs alphabetically by title
    jobs.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
    return jobs;
  }

  /// Get category by ID
  CategoryModel? getCategoryById(String categoryId) {
    try {
      return categories.firstWhere((cat) => cat.id == categoryId);
    } catch (e) {
      return null;
    }
  }

  /// Get job by ID
  JobModel? getJobById(String jobId) {
    try {
      return allJobs.firstWhere((job) => job.id == jobId);
    } catch (e) {
      return null;
    }
  }

  /// Get trader service for a specific job
  TraderServiceModel? getTraderService(String jobId) {
    try {
      return traderServices.firstWhere((service) => service.jobId == jobId);
    } catch (e) {
      return null;
    }
  }

  /// Check if trader has enabled a specific job
  bool isJobEnabled(String jobId) {
    final service = getTraderService(jobId);
    return service?.isEnabled ?? false;
  }

  /// Get price for a specific job
  double? getJobPrice(String jobId) {
    final service = getTraderService(jobId);
    return service?.price;
  }

  /// Get price range for a specific job (lowest and highest from all traders)
  Future<(double?, double?)> getPriceRange(String jobId) async {
    try {
      final snapshot =
          await _firestore
              .collection('services_prices')
              .where('jobId', isEqualTo: jobId)
              .where('isEnabled', isEqualTo: true)
              .orderBy('price')
              .get();

      if (snapshot.docs.isEmpty) {
        return (null, null);
      }

      final prices =
          snapshot.docs
              .map((doc) => doc.data()['price'] as num?)
              .whereType<num>()
              .map((n) => n.toDouble())
              .toList();

      if (prices.isEmpty) {
        return (null, null);
      }

      return (prices.first, prices.last);
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error getting price range: $e');
      }
      return (null, null);
    }
  }

  /// Enable/disable a job for the trader
  Future<void> toggleJobEnabled(
    String jobId,
    bool isEnabled, {
    double? price,
  }) async {
    try {
      final job = getJobById(jobId);
      if (job == null) {
        throw Exception('Job not found');
      }

      final docId = '${userId}_$jobId';
      final docRef = _firestore.collection('services_prices').doc(docId);

      if (isEnabled && price != null && price > 0) {
        // Enable with price
        final serviceData = TraderServiceModel(
          id: docId,
          traderId: userId,
          jobId: jobId,
          categoryId: job.categoryId,
          categoryName: job.categoryName,
          jobTitle: job.title,
          jobType: job.jobType,
          price: price,
          isEnabled: true,
          isCustom: false,
        );

        await docRef.set(serviceData.toMap());

        // Update local state
        final existingIndex = traderServices.indexWhere(
          (s) => s.jobId == jobId,
        );
        if (existingIndex >= 0) {
          traderServices[existingIndex] = serviceData;
        } else {
          traderServices.add(serviceData);
        }

        if (kDebugMode) {
          print('✅ Enabled job: ${job.title} with price: \$${price}');
        }
      } else {
        // Disable
        await docRef.update({'isEnabled': false});

        // Update local state
        final existingIndex = traderServices.indexWhere(
          (s) => s.jobId == jobId,
        );
        if (existingIndex >= 0) {
          traderServices[existingIndex] = traderServices[existingIndex]
              .copyWith(isEnabled: false);
        }

        if (kDebugMode) {
          print('🔴 Disabled job: ${job.title}');
        }
      }

      traderServices.refresh();
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error toggling job: $e');
      }
      Get.snackbar('Error', 'Failed to update service: ${e.toString()}');
      rethrow;
    }
  }

  /// Update price for a job
  Future<void> updateJobPrice(String jobId, double price) async {
    try {
      final docId = '${userId}_$jobId';
      await _firestore.collection('services_prices').doc(docId).update({
        'price': price,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Update local state
      final existingIndex = traderServices.indexWhere((s) => s.jobId == jobId);
      if (existingIndex >= 0) {
        traderServices[existingIndex] = traderServices[existingIndex].copyWith(
          price: price,
        );
        traderServices.refresh();
      }

      if (kDebugMode) {
        print('✅ Updated price for job $jobId: \$${price}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error updating price: $e');
      }
      rethrow;
    }
  }

  /// Get enabled services count for a category
  int getEnabledServicesCount(String categoryId, String jobType) {
    final jobs = getJobsForCategory(categoryId, jobType);
    return jobs.where((job) => isJobEnabled(job.id)).length;
  }

  /// Get total services count for a category
  int getTotalServicesCount(String categoryId, String jobType) {
    return getJobsForCategory(categoryId, jobType).length;
  }

  /// Select a category
  void selectCategory(String categoryId) {
    selectedCategoryId(categoryId);
    selectedCategory(categoryId); // legacy compatibility
    if (kDebugMode) {
      print('📌 Selected category: $categoryId');
    }
  }

  /// Select job type
  void selectJobType(String jobType) {
    selectedJobType(jobType);
    if (kDebugMode) {
      print('📌 Selected job type: $jobType');
    }
  }

  // Legacy compatibility getters and methods expected by views
  List<String> get sortedCategoryNames =>
      categories.map((c) => c.name).toList()..sort();

  List<String> get sortedLargeCategoryNames => sortedCategoryNames;

  List<JobModel> get selectedCategoryServices =>
      getJobsForCategory(selectedCategoryId.value, selectedJobType.value);

  /// Select a service/job by its ID
  void selectService(String jobId) {
    selectedJobId(jobId);

    if (kDebugMode) {
      final job = allJobs.firstWhereOrNull((j) => j.id == jobId);
      if (job != null) {
        print('📌 Selected service/job: ${job.title} (ID: $jobId)');
      } else {
        print('⚠️ Job not found with ID: $jobId');
      }
    }
  }

  List<JobModel> getServicesForCategory(String categoryId) {
    return getJobsForCategory(categoryId, selectedJobType.value);
  }

  bool isSmallJobCategory(String categoryId) =>
      smallJobsByCategory.containsKey(categoryId);
  bool isLargeJobCategory(String categoryId) =>
      largeJobsByCategory.containsKey(categoryId);

  // Custom service operations (stubbed to work with new schema)
  void addCustomService() {
    // Custom services are removed from the new schema; for compatibility, add a placeholder
    final id = 'custom_${DateTime.now().millisecondsSinceEpoch}';
    final job = JobModel(
      id: id,
      title: 'Custom Service',
      categoryId: selectedCategoryId.value,
      categoryName: getCategoryById(selectedCategoryId.value)?.id ?? '',
      jobType: selectedJobType.value,
      isCustom: true,
    );
    // Add to local lists only; not persisted in jobs collection
    allJobs.add(job);
    _organizeJobs();
    _syncLegacyCategoryMaps();
    if (kDebugMode) print('➕ Added custom service placeholder: $id');
  }

  void removeCustomService(String category, int index) {
    final list = largeJobsByCategory[category] ?? [];
    if (index >= 0 && index < list.length) {
      final job = list[index];
      if (job.isCustom) {
        list.removeAt(index);
        allJobs.removeWhere((j) => j.id == job.id);
        _organizeJobs();
        _syncLegacyCategoryMaps();
      }
    }
  }

  void updateService(
    String category,
    int index,
    JobModel updatedService,
  ) async {
    // If service has price/isEnabled fields change trader services accordingly
    final job = updatedService;
    final price = updatedService.price;
    final isEnabled =
        updatedService.isCustom
            ? true
            : (updatedService.price != null && updatedService.price! > 0);
    try {
      await toggleJobEnabled(job.id, isEnabled, price: price);
      // update local job if it's custom
      if (job.isCustom) {
        final list = largeJobsByCategory[category] ?? [];
        if (index >= 0 && index < list.length) {
          list[index] = updatedService;
        }
      }
      traderServices.refresh();
    } catch (e) {
      if (kDebugMode) print('❌ Error updating service: $e');
    }
  }

  // Additional legacy helpers
  int getEnabledLargeServicesCount(String categoryId) {
    return getJobsForCategory(
      categoryId,
      'large',
    ).where((job) => isJobEnabled(job.id)).length;
  }

  int getTotalLargeServicesCount(String categoryId) {
    return getJobsForCategory(categoryId, 'large').length;
  }

  final RxBool fromProfile = false.obs;

  Future<void> saveUserServices({bool shouldGoBack = true}) async {
    await loadTraderServices();
    if (shouldGoBack == true) {
      Get.back();
    } else {
      Get.to(() => const TraderOnboardingPage());
    }
    Get.snackbar('Success', 'Services saved successfully');
  }

  /// Refresh all data
  Future<void> refreshAll() async {
    await loadAllData();
  }

  /// Get categories with small jobs
  List<CategoryModel> getCategoriesWithSmallJobs() {
    return categories
        .where(
          (cat) =>
              smallJobsByCategory.containsKey(cat.id) &&
              smallJobsByCategory[cat.id]!.isNotEmpty,
        )
        .toList();
  }

  /// Get categories with large jobs
  List<CategoryModel> getCategoriesWithLargeJobs() {
    return categories
        .where(
          (cat) =>
              largeJobsByCategory.containsKey(cat.id) &&
              largeJobsByCategory[cat.id]!.isNotEmpty,
        )
        .toList();
  }

  /// Get icon for a category
  IconData getCategoryIcon(String categoryName) {
    const icons = {
      'Custom Services': Icons.add,
      'Electrician': Icons.electrical_services,
      'Plumber': Icons.plumbing,
      'Carpenter / Joiner': Icons.handyman,
    };
    return icons[categoryName] ?? Icons.build;
  }

  @override
  void onClose() {
    // Clean up if needed
    super.onClose();
  }

  void skipSettingServices({required bool isFromLargeJob}) {
    if (fromProfile.value) {
      // If coming from profile, just go back
      Get.back();
    } else {
      // If from onboarding flow, navigate to onboarding screen
      Get.to(() => const TraderOnboardingPage());
    }
  }
}
