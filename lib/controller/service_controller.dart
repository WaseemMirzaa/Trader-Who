// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:traderou/models/category_model.dart';
// import 'package:traderou/models/job_model.dart';
// import 'package:traderou/models/trader_service_model.dart';
// import 'package:traderou/views/trades_profile/presentation/pages/pages.dart';
// import 'package:traderou/views/trades_profile/presentation/pages/trade_large_job_rate_page.dart';

// class ServiceController extends GetxController {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final String userId = FirebaseAuth.instance.currentUser!.uid;

//   // Observable lists
//   final RxList<CategoryModel> categories = <CategoryModel>[].obs;
//   final RxList<JobModel> allJobs = <JobModel>[].obs;
//   final RxMap<String, List<JobModel>> smallJobsByCategory =
//       <String, List<JobModel>>{}.obs;
//   final RxMap<String, List<JobModel>> largeJobsByCategory =
//       <String, List<JobModel>>{}.obs;
//   final RxMap<String, List<JobModel>> largeCategories =
//     <String, List<JobModel>>{}.obs;
//   final RxList<TraderServiceModel> traderServices = <TraderServiceModel>[].obs;

//   // Selection state
//   final RxString selectedCategoryId = RxString('');
//   final RxString selectedJobType = RxString('small'); // 'small' or 'large'
//   final Rx<JobModel?> selectedService = Rx<JobModel?>(null);
//   final RxString selectedCategory = RxString('');

//   // Loading states
//   final RxBool isLoadingCategories = false.obs;
//   final RxBool isLoadingJobs = false.obs;
//   final RxBool isLoadingTraderServices = false.obs;
//   final RxBool isLoading = false.obs;
//   final RxBool fromProfile = false.obs;

//     @override
//   void onInit() {
//     super.onInit();
//     if (kDebugMode) {
//       print('🎯 ServiceController onInit() called');
//     }
//     loadAllData();
//   }

//   /// Load all data in parallel
//   Future<void> loadAllData() async {
//     isLoading(true);
//     try {
//       await Future.wait([
//         loadCategories(),
//         loadJobs(),
//         loadTraderServices(),
//       ]);
//       organizeJobsByCategory();
//       if (kDebugMode) {
//         print('✅ All data loaded successfully');
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print('❌ Error loading data: $e');
//       }
//       Get.snackbar('Error', 'Failed to load data: $e');
//     } finally {
//       isLoading(false);
//     }
//   }

//   /// Load categories from Firestore
//   Future<void> loadCategories() async {
//     isLoadingCategories(true);
//     try {
//       final snapshot = await _firestore.collection('categories').get();
//       categories.value = snapshot.docs
//           .map((doc) => CategoryModel.fromMap(doc.data(), doc.id))
//           .toList();
//       if (kDebugMode) {
//         print('📂 Loaded ${categories.length} categories');
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print('❌ Error loading categories: $e');
//       }
//     } finally {
//       isLoadingCategories(false);
//     }
//   }

//   /// Load jobs from Firestore
//   Future<void> loadJobs() async {
//     isLoadingJobs(true);
//     try {
//       final snapshot = await _firestore.collection('jobs').get();
//       allJobs.value = snapshot.docs
//           .map((doc) => JobModel.fromMap(doc.data(), doc.id))
//           .toList();
//       if (kDebugMode) {
//         print('🔧 Loaded ${allJobs.length} jobs');
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print('❌ Error loading jobs: $e');
//       }
//     } finally {
//       isLoadingJobs(false);
//     }
//   }

//   /// Load trader services from Firestore
//   Future<void> loadTraderServices() async {
//     isLoadingTraderServices(true);
//     try {
//       final snapshot = await _firestore
//           .collection('services_prices')
//           .where('traderId', isEqualTo: userId)
//           .get();
//       traderServices.value = snapshot.docs
//           .map((doc) => TraderServiceModel.fromMap(doc.data(), doc.id))
//           .toList();
//       if (kDebugMode) {
//         print('💰 Loaded ${traderServices.length} trader services');
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print('❌ Error loading trader services: $e');
//       }
//     } finally {
//       isLoadingTraderServices(false);
//     }
//   }

//   /// Organize jobs by category and job type
//   void organizeJobsByCategory() {
//     smallJobsByCategory.clear();
//     largeJobsByCategory.clear();

//     for (final job in allJobs) {
//       if (job.jobType == 'small') {
//         if (!smallJobsByCategory.containsKey(job.categoryId)) {
//           smallJobsByCategory[job.categoryId] = [];
//         }
//         smallJobsByCategory[job.categoryId]!.add(job);
//       } else if (job.jobType == 'large') {
//         if (!largeJobsByCategory.containsKey(job.categoryId)) {
//           largeJobsByCategory[job.categoryId] = [];
//         }
//         largeJobsByCategory[job.categoryId]!.add(job);
//       }
//     }

//     // Sort jobs alphabetically by title
//     for (final categoryJobs in smallJobsByCategory.values) {
//       categoryJobs.sort((a, b) => a.title.compareTo(b.title));
//     }
//     for (final categoryJobs in largeJobsByCategory.values) {
//       categoryJobs.sort((a, b) => a.title.compareTo(b.title));
//     }

//     // Sync legacy largeCategories map for views expecting it
//     largeCategories.clear();
//     largeCategories.addAll(largeJobsByCategory);
//   }

//   /// Get jobs for a category and job type
//   List<JobModel> getJobsForCategory(String categoryId, String jobType) {
//     if (jobType == 'small') {
//       return smallJobsByCategory[categoryId] ?? [];
//     } else if (jobType == 'large') {
//       return largeJobsByCategory[categoryId] ?? [];
//     }
//     return [];
//   }

//   /// Get category by ID
//   CategoryModel? getCategoryById(String categoryId) {
//     return categories.firstWhereOrNull((cat) => cat.id == categoryId);
//   }

//   /// Get price for a job
//   double? getJobPrice(String jobId) {
//     final service = traderServices.firstWhereOrNull((s) => s.jobId == jobId);
//     return service?.price;
//   }

//   /// Check if job is enabled
//   bool isJobEnabled(String jobId) {
//     final service = traderServices.firstWhereOrNull((s) => s.jobId == jobId);
//     return service?.isEnabled ?? false;
//   }

//   /// Toggle job enabled status
//   Future<void> toggleJobEnabled(String jobId, bool isEnabled, double? price) async {
//     try {
//       final existingService = traderServices.firstWhereOrNull((s) => s.jobId == jobId);
//       final job = allJobs.firstWhereOrNull((j) => j.id == jobId);
//       final category = categories.firstWhereOrNull((c) => c.id == job?.categoryId);

//       if (job == null || category == null) return;

//       final serviceData = TraderServiceModel(
//         id: existingService?.id ?? '${userId}_$jobId',
//         traderId: userId,
//         jobId: jobId,
//         categoryId: category.id,
//         categoryName: category.name,
//         jobTitle: job.title,
//         jobType: job.jobType,
//         price: price,
//         isEnabled: isEnabled,
//         isCustom: false,
//       );

//       await _firestore
//           .collection('services_prices')
//           .doc(serviceData.id)
//           .set(serviceData.toMap(), SetOptions(merge: true));

//       // Update local list
//       if (existingService != null) {
//         final index = traderServices.indexOf(existingService);
//         traderServices[index] = serviceData;
//       } else {
//         traderServices.add(serviceData);
//       }

//       if (kDebugMode) {
//         print('✅ Job ${job.title} ${isEnabled ? 'enabled' : 'disabled'}');
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print('❌ Error toggling job: $e');
//       }
//     }
//   }

//   /// Update job price
//   Future<void> updateJobPrice(String jobId, double price) async {
//     await toggleJobEnabled(jobId, true, price);
//   }

//   /// Get enabled services count for a category
//   int getEnabledServicesCount(String categoryId) {
//     final jobs = getJobsForCategory(categoryId, selectedJobType.value);
//     return jobs.where((job) => isJobEnabled(job.id)).length;
//   }

//   /// Get total services count for a category
//   int getTotalServicesCount(String categoryId) {
//     return getJobsForCategory(categoryId, selectedJobType.value).length;
//   }

//   /// Get enabled small services count
//   int getEnabledSmallServicesCount(String categoryId) {
//     return getJobsForCategory(categoryId, 'small').where((job) => isJobEnabled(job.id)).length;
//   }

//   /// Get total small services count
//   int getTotalSmallServicesCount(String categoryId) {
//     return getJobsForCategory(categoryId, 'small').length;
//   }

//   /// Get enabled large services count
//   int getEnabledLargeServicesCount(String categoryId) {
//     return getJobsForCategory(categoryId, 'large').where((job) => isJobEnabled(job.id)).length;
//   }

//   /// Get total large services count
//   int getTotalLargeServicesCount(String categoryId) {
//     return getJobsForCategory(categoryId, 'large').length;
//   }

//   /// Select category
//   void selectCategory(String categoryId) {
//     selectedCategoryId(categoryId);
//     selectedCategory(categoryId);
//     if (kDebugMode) {
//       print('📌 Selected category: $categoryId');
//     }
//   }

//   /// Select job type
//   void selectJobType(String jobType) {
//     selectedJobType(jobType);
//     if (kDebugMode) {
//       print('📌 Selected job type: $jobType');
//     }
//   }

//   // Compatibility methods for legacy UI
//   void addCustomService() {
//     final id = 'custom_${DateTime.now().millisecondsSinceEpoch}';
//     final job = JobModel(
//       id: id,
//       title: 'Custom Service',
//       categoryId: selectedCategoryId.value,
//       categoryName: getCategoryById(selectedCategoryId.value)?.name ?? '',
//       jobType: selectedJobType.value,
//       isCustom: true,
//     );
//     allJobs.add(job);
//     organizeJobsByCategory();
//     if (kDebugMode) print('➕ Added custom service placeholder: $id');
//   }

//   void removeCustomService(String category, int index) {
//     final list = largeCategories[category] ?? [];
//     if (index >= 0 && index < list.length) {
//       final job = list[index];
//       if (job.isCustom) {
//         list.removeAt(index);
//         allJobs.removeWhere((j) => j.id == job.id);
//         organizeJobsByCategory();
//       }
//     }
//   }

//   Future<void> updateService(String category, int index, JobModel updatedService) async {
//     final job = updatedService;
//     final price = updatedService.price;
//     final isEnabled = updatedService.isCustom ? true : (updatedService.price != null && updatedService.price! > 0);
//     try {
//       await toggleJobEnabled(job.id, isEnabled, price);
//       if (job.isCustom) {
//         final list = largeCategories[category] ?? [];
//         if (index >= 0 && index < list.length) {
//           list[index] = updatedService;
//         }
//       }
//       traderServices.refresh();
//     } catch (e) {
//       if (kDebugMode) print('❌ Error updating service: $e');
//     }
//   }

//   /// Get category icon
//   IconData getCategoryIcon(String categoryName) {
//     const icons = {
//       'Electrician': Icons.electrical_services,
//       'Plumber': Icons.plumbing,
//       'Carpenter / Joiner': Icons.handyman,
//     };
//     return icons[categoryName] ?? Icons.build;
//   }

//   /// Save user services
//   Future<void> saveUserServices({bool isFromLargeJob = false}) async {
//     try {
//       // The services are already saved when toggling, but we can refresh
//       await loadTraderServices();
//       Get.snackbar('Success', 'Services saved successfully');
//       if (Get.arguments == true) {
//         Get.back();
//       } else {
//         // Navigate based on job type
//         if (isFromLargeJob) {
//           Get.off(() => const TradeLargerRatePage());
//         } else {
//           Get.off(() => const TradeRatePage());
//         }
//       }
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to save services: $e');
//     }
//   }

//   // Legacy compatibility
//   List<String> get sortedCategoryNames => categories.map((c) => c.name).toList()..sort();
//   List<String> get sortedLargeCategoryNames => sortedCategoryNames;

//   List<JobModel> get selectedCategoryServices => getJobsForCategory(selectedCategoryId.value, selectedJobType.value);

//   void selectService(String categoryId) {
//     selectCategory(categoryId);
//   }

//   List<JobModel> getServicesForCategory(String categoryId) {
//     return getJobsForCategory(categoryId, selectedJobType.value);
//   }

//   bool isSmallJobCategory(String categoryId) => smallJobsByCategory.containsKey(categoryId);
//   bool isLargeJobCategory(String categoryId) => largeJobsByCategory.containsKey(categoryId);
// }
