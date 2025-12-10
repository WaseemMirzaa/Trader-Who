// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:traderou/models/models.dart';
// import 'package:traderou/views/trades_profile/presentation/pages/pages.dart';

// class TradeRateController extends GetxController {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final String userId = FirebaseAuth.instance.currentUser!.uid;
//   final RxBool fromProfile = false.obs;
//   final RxMap<String, List<ServiceItem>> categories =
//       <String, List<ServiceItem>>{}.obs;
//   final RxString selectedCategory = RxString('');
//   final RxBool isLoading = true.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     // Check if coming from profile when controller initializes
//     fromProfile.value = Get.arguments == true;
//     // getPredefinedServices();
//     // initializeAndLoadCategories();
//   }

//   // Initialize predefined services if needed, then load categories
//   Future<void> initializeAndLoadCategories() async {
//     try {
//       isLoading(true);

//       // Check if predefined services exist in Firebase
//       final existingData =
//           await _firestore.collection('Services').doc('smalljoblist').get();

//       if (!existingData.exists) {
//         // No predefined data exists, initialize it first
//         await initializePredefinedServices();
//       } else {
//         // Data exists, just load categories
//         await loadCategories();
//       }
//     } catch (e) {
//       // Fallback to just loading categories
//       await loadCategories();
//     }
//   }

//   Future<void> loadCategories() async {
//     isLoading(true);
//     try {
//       if (userId.isEmpty) {
//         Get.snackbar('Error', 'User not authenticated');
//         isLoading(false);
//         return;
//       }

//       categories.clear();
//       categories['Custom Services'] = [];

//       // final userDoc = await _firestore.collection('users').doc(userId).get();
//       final servicesPricesSnap =
//           await _firestore
//               .collection('services_prices')
//               .where('jobType', isEqualTo: 'smallJob')
//               .where('trader_id', isEqualTo: userId)
//               .get();
//       final snapshot =
//           await _firestore.collection('Services').doc('smalljoblist').get();

//       if (!snapshot.exists || snapshot.data() == null) {
//         Get.snackbar(
//           'Warning',
//           'No services found in smalljoblist. You can add custom services.',
//         );
//       } else {
//         final data = snapshot.data()!;
//         final predefinedServices =
//             data['predefinedServices'] as Map<String, dynamic>? ?? {};

//         for (String category in predefinedServices.keys) {
//           final servicesList = predefinedServices[category] as List? ?? [];
//           final services =
//               servicesList
//                   .map((item) {
//                     if (item is Map<String, dynamic>) {
//                       return ServiceItem.fromMap(item);
//                     }
//                     return null;
//                   })
//                   .where((item) => item != null)
//                   .cast<ServiceItem>()
//                   .toList();
//           categories[category] = services;
//         }
//       }

//       // if (userDoc.exists && userDoc.data()!.containsKey('smalljoblist')) {
//       List<QueryDocumentSnapshot<Map<String, dynamic>>> userServices =
//           servicesPricesSnap.docs;

//       for (QueryDocumentSnapshot<Map<String, dynamic>> userService
//           in userServices) {
//         final categoryValue = userService.data()['category'];
//         if (categoryValue == null) {
//           continue;
//         }
//         final category = categoryValue as String;

//         // Check if userService.id is not null and contains underscore
//         if (userService.id.isEmpty || !userService.id.contains('_')) {
//           continue;
//         }

//         final serviceParts = userService.id.split("_");
//         if (serviceParts.length < 2) {
//           continue;
//         }

//         // Ensure category exists in categories map
//         if (!categories.containsKey(category)) {
//           categories[category] = [];
//         }

//         final index =
//             categories[category]?.indexWhere(
//               (item) => item.id == serviceParts[1],
//             ) ??
//             -1;

//         if (index != -1) {
//           try {
//             categories[category]![index] = ServiceItem.fromMap(
//               userService.data(),
//             );
//             final title =
//                 userService.data()['title'] ??
//                 userService.data()['name'] ??
//                 'Unknown Service';
//           } catch (e) {}
//         } else {
//           try {
//             categories[category]!.add(ServiceItem.fromMap(userService.data()));
//             final title =
//                 userService.data()['title'] ??
//                 userService.data()['name'] ??
//                 'Unknown Service';
//           } catch (e) {}
//         }
//       }
//       // }
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to load services: ${e.toString()}');
//     } finally {
//       isLoading(false);
//     }
//   }

//   void selectCategory(String? category) {
//     selectedCategory.value = category ?? '';
//   }

//   void updateService(String category, int index, ServiceItem updatedService) {
//     categories[category]![index] = updatedService;
//     categories.refresh();
//   }

//   void addCustomService() {
//     final service = ServiceItem(
//       title: '',
//       isCustom: true,
//       id: FirebaseFirestore.instance.collection('Services').doc().id,
//     );
//     categories['Custom Services']!.add(service);
//     selectCategory('Custom Services');
//     categories.refresh();
//   }

//   void removeCustomService(String category, int index) {
//     categories[category]!.removeAt(index);
//     categories.refresh();
//   }

//   int getEnabledServicesCount(String category) {
//     final count = categories[category]?.where((s) => s.isEnabled).length ?? 0;
//     return count;
//   }

//   int getTotalServicesCount(String category) {
//     final total = categories[category]?.length ?? 0;
//     return total;
//   }

//   IconData getCategoryIcon(String category) {
//     const icons = {
//       'Custom Services': Icons.add,
//       'Electrician': Icons.electrical_services,
//       'Plumber': Icons.plumbing,
//       'Carpenter / Joiner': Icons.handyman,
//     };
//     return icons[category] ?? Icons.build;
//   }

//   Future<void> saveUserServices() async {
//     try {
//       // Get count of enabled categories for logging
//       final enabledCategoriesCount =
//           categories.entries.where((entry) {
//             final category = entry.key;
//             final enabledServices =
//                 entry.value.where((s) => s.isEnabled).toList();
//             return enabledServices.isNotEmpty || category == 'Custom Services';
//           }).length;

//       // await _firestore.collection('users').doc(userId).set({
//       //   'smalljoblist': smalljobList,
//       // }, SetOptions(merge: true));

//       // Also save individual services with userId_serviceId format
//       await saveIndividualServices();

//       Get.snackbar('Success', 'Prices saved successfully');
//       if (fromProfile.value) {
//         // If came from profile, just go back
//         Get.back();
//       } else {
//         // If came from signup flow, proceed to onboarding
//         Get.off(() => const TradeRatePage());
//       }
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to save services: ${e.toString()}');
//     }
//   }

//   /// Save individual services with docId format: userId_serviceId
//   Future<void> saveIndividualServices() async {
//     try {
//       for (String category in categories.keys) {
//         final servicesList = categories[category] ?? [];

//         for (ServiceItem service in servicesList) {
//           if (service.isEnabled &&
//               service.price != null &&
//               service.price! > 0) {
//             // Use existing service ID
//             final serviceId = service.id;
//             final docId = '${userId}_$serviceId';

//             final serviceData = {
//               'name': service.title,
//               'category': category,
//               'jobId': serviceId,
//               'jobType': 'smallJob',
//               'price': service.price,
//               'trader_id': userId,
//               'description': service.description ?? '',
//               'isCustom': service.isCustom,
//               'createdAt': FieldValue.serverTimestamp(),
//               'updatedAt': FieldValue.serverTimestamp(),
//               'isEnabled': true,
//             };

//             await _firestore
//                 .collection('services_prices')
//                 .doc(docId)
//                 .set(serviceData, SetOptions(merge: true));
//           }
//         }
//       }
//     } catch (e) {}
//   }

//   /// Save a single service with userId_serviceId format
//   Future<void> saveSingleService(String category, ServiceItem service) async {
//     try {
//       if (!service.isEnabled || service.price == null || service.price! <= 0) {
//         return;
//       }

//       // Use existing service ID
//       final serviceId = service.id;
//       final docId = '${userId}_$serviceId';

//       final serviceData = {
//         'name': service.title,
//         'category': category,
//         'jobId': serviceId,
//         'jobType': 'smallJob',
//         'price': service.price,
//         'trader_id': userId,
//         'description': service.description ?? '',
//         'isCustom': service.isCustom,
//         'createdAt': FieldValue.serverTimestamp(),
//         'updatedAt': FieldValue.serverTimestamp(),
//         'isEnabled': true,
//       };

//       await _firestore
//           .collection('services_prices')
//           .doc(docId)
//           .set(serviceData, SetOptions(merge: true));

//       Get.snackbar('Success', 'Service "${service.title}" saved successfully');
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to save service: ${e.toString()}');
//     }
//   }

//   // Initialize Firebase with predefined small jobs data
//   Future<void> initializePredefinedServices() async {
//     try {
//       isLoading(true);

//       // Check if data already exists
//       final existingData =
//           await _firestore.collection('Services').doc('smalljoblist').get();
//       if (existingData.exists) {
//         await loadCategories(); // Reload categories
//         return;
//       }
//       // Predefined services data organized by category
//       // final predefinedServices = {
//       //   'Electrician': [
//       //     'Replace socket',
//       //     'Install light fitting',
//       //     'Replace light switch',
//       //     'Install extractor fan',
//       //     'Replace fuse',
//       //     'Install outside security light',
//       //   ],
//       //   'Plumber': [
//       //     'Fix leaking tap',
//       //     'Replace tap',
//       //     'Unblock sink or toilet',
//       //     'Install new kitchen or basin tap',
//       //     'Replace toilet flush mechanism',
//       //     'Fit outside tap',
//       //     'Seal around sink or bath',
//       //   ],
//       //   'Heating Engineer / Gas Engineer': [
//       //     'Bleed radiators',
//       //     'Replace thermostat',
//       //     'Service boiler',
//       //     'Replace radiator valve',
//       //     'Balance heating system',
//       //     'Fit new radiator',
//       //   ],
//       //   'Carpenter / Joiner': [
//       //     'Hang internal door',
//       //     'Trim door',
//       //     'Fit door handles or locks',
//       //     'Fit skirting board',
//       //     'Install shelves',
//       //     'Repair floorboard',
//       //     'Box in pipework',
//       //   ],
//       //   'Painter & Decorator': [
//       //     'Paint a single wall',
//       //     'Touch up marked walls',
//       //     'Paint internal door',
//       //     'Paint front door',
//       //   ],
//       //   'Tiler': [
//       //     'Re-grout tiles',
//       //     'Replace cracked tile',
//       //     'Tile kitchen splashback',
//       //     'Seal around tiles',
//       //   ],
//       //   'Plasterer': [
//       //     'Patch repair small wall',
//       //     'Skim ceiling',
//       //     'Plaster small boxing-in section',
//       //   ],
//       //   'Roofer': [
//       //     'Replace broken tile',
//       //     'Seal flashing',
//       //     'Patch flat roof',
//       //     'Clear blocked gutter',
//       //     'Soffit repair',
//       //     'Re-seal leaking gutter joint',
//       //   ],
//       //   'Flooring Specialist': [
//       //     'Repair lifted floor plank',
//       //     'Fit door threshold strip',
//       //     'Replace carpet gripper',
//       //   ],
//       //   'Bricklayer / Builder': [
//       //     'Re-point small wall section',
//       //     'Repair step or brick crack',
//       //     'Patch render/masonry',
//       //   ],
//       //   'Window Fitter / Glazier': [
//       //     'Replace single-glazed pane',
//       //     'Adjust stiff window',
//       //     'Reseal draughty window',
//       //     'Replace handle or hinge',
//       //   ],
//       //   'Locksmith': [
//       //     'Replace front door lock',
//       //     'Fit night latch or deadbolt',
//       //     'Adjust misaligned lock',
//       //     'Unlock jammed internal door',
//       //   ],
//       //   'Drainage Specialist': [
//       //     'Unblock outdoor drain',
//       //     'Jet-wash drain',
//       //     'Reseal gully trap',
//       //     'Clear debris from downpipe',
//       //   ],
//       //   'Gutter Cleaner / Installer': [
//       //     'Clean gutters on one side of house',
//       //     'Fix gutter bracket',
//       //     'Install leaf guard',
//       //     'Seal leaking corner joint',
//       //   ],
//       //   'Fence Installer': [
//       //     'Replace fence panel',
//       //     'Repair or re-secure post',
//       //     'Fit new gate latch',
//       //     'Straighten leaning fence section',
//       //   ],
//       //   'Driveway / Paving Installer': [
//       //     'Re-sand block paving',
//       //     'Clean driveway surface',
//       //     'Repair 1–2 sunken blocks',
//       //     'Edge tarmac border',
//       //   ],
//       //   'Scaffolder': [
//       //     'Install small scaffold tower (e.g. for gutter access)',
//       //     'Dismantle small scaffolding section',
//       //     'Add handrail or guard rail',
//       //     'Provide temporary working platform',
//       //   ],
//       //   'Gardener / Landscaper': [
//       //     'Mow lawn',
//       //     'Trim hedges',
//       //     'Remove garden waste',
//       //     'Weed flower beds',
//       //     'Lay small turf patch',
//       //     'Install edging or border',
//       //   ],
//       //   'Tree Surgeon / Arborist': [
//       //     'Prune low branches',
//       //     'Remove small tree',
//       //     'Trim overhanging limb',
//       //     'Grind small stump',
//       //   ],
//       //   'Decking Installer': [
//       //     'Replace deck board',
//       //     'Clean and treat decking',
//       //     'Fit handrail or edging',
//       //     'Secure loose board',
//       //   ],
//       //   'Pest Control': [
//       //     'Treat wasp nest',
//       //     'Lay traps or bait for rodents',
//       //     'Spray for ants or insects',
//       //     'Block common rodent entry point',
//       //   ],
//       //   'Fire Alarm / Security System Installer': [
//       //     'Install smoke or heat alarm',
//       //     'Replace alarm battery or sensor',
//       //     'Service alarm system',
//       //     'Test and reconfigure home alarm',
//       //   ],
//       //   'CCTV Installer': [
//       //     'Install basic external camera',
//       //     'Re-align or adjust CCTV angle',
//       //     'Connect CCTV to app or Wi-Fi',
//       //     'Replace camera unit',
//       //   ],
//       // };

//       // Create service items for each category and organize them

//       Get.snackbar('Success', 'Predefined services initialized successfully!');
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to initialize services: ${e.toString()}');
//     } finally {
//       isLoading(false);
//     }
//   }
// }









// // class TradeRateLargeJobController extends GetxController {
// //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// //   final String userId = FirebaseAuth.instance.currentUser!.uid;
// //   final RxBool fromProfile = false.obs;
// //   final RxMap<String, List<ServiceItem>> categories =
// //       <String, List<ServiceItem>>{}.obs;
// //   final RxString selectedCategory = RxString('');
// //   final RxBool isLoading = true.obs;
// //
// //   @override
// //   void onInit() {
// //     super.onInit();
// //     // Check if coming from profile when controller initializes
// //     fromProfile.value = Get.arguments == true;
// //     initializeAndLoadCategories();
// //   }
// //
// //   // Initialize predefined services if needed, then load categories
// //   Future<void> initializeAndLoadCategories() async {
// //     try {
// //       isLoading(true);
// //
// //       // Check if predefined services exist in Firebase
// //       final existingData =
// //       await _firestore.collection('Services').doc('largejoblist').get();
// //
// //       if (!existingData.exists) {
// //         // No predefined data exists, initialize it first
// //         await initializePredefinedServices();
// //       } else {
// //         // Data exists, just load categories
// //         await loadCategories();
// //       }
// //     } catch (e) {
// //       print('Error in initializeAndLoadCategories: $e');
// //       // Fallback to just loading categories
// //       await loadCategories();
// //     }
// //   }
// //
// //   Future<void> loadCategories() async {
// //     isLoading(true);
// //     try {
// //       if (userId.isEmpty) {
// //         Get.snackbar('Error', 'User not authenticated');
// //         isLoading(false);
// //         return;
// //       }
// //
// //       categories.clear();
// //       categories['Custom Services'] = [];
// //
// //       final userDoc = await _firestore.collection('users').doc(userId).get();
// //       // final userTitle = userDoc.exists ? userDoc['title'] as String? : null;
// //
// //       final snapshot =
// //       await _firestore.collection('Services').doc('largejoblist').get();
// //
// //       if (!snapshot.exists || snapshot.data() == null) {
// //         Get.snackbar(
// //           'Warning',
// //           'No services found in largejoblist. You can add custom services.',
// //         );
// //       } else {
// //         final data = snapshot.data()!;
// //         final predefinedServices =
// //             data['predefinedServices'] as Map<String, dynamic>? ?? {};
// //
// //         for (String category in predefinedServices.keys) {
// //           // Remove the userTitle filter to include all categories
// //           final services =
// //           (predefinedServices[category] as List? ?? [])
// //               .map(
// //                 (item) => ServiceItem.fromMap(item as Map<String, dynamic>),
// //           )
// //               .toList();
// //           categories[category] = services;
// //         }
// //       }
// //
// //       // Pre-populate user services
// //       if (userDoc.exists && userDoc['largejoblist'] != null) {
// //         final userServices = userDoc['largejoblist'] as List;
// //         for (var categoryData in userServices) {
// //           final category = categoryData['category'] as String;
// //           final userServiceList = categoryData['services'] as List? ?? [];
// //           if (categories.containsKey(category)) {
// //             for (var userService in userServiceList) {
// //               final index = categories[category]!.indexWhere(
// //                     (item) => item.title == userService['title'],
// //               );
// //               if (index != -1) {
// //                 categories[category]![index] = ServiceItem.fromMap(userService);
// //               } else if (category == 'Custom Services') {
// //                 categories[category]!.add(ServiceItem.fromMap(userService));
// //               }
// //             }
// //           }
// //         }
// //       }
// //     } catch (e) {
// //       Get.snackbar('Error', 'Failed to load services: ${e.toString()}');
// //     } finally {
// //       isLoading(false);
// //     }
// //   }
// //
// //   void selectCategory(String? category) {
// //     selectedCategory.value = category ?? '';
// //   }
// //
// //   void updateService(String category, int index, ServiceItem updatedService) {
// //     categories[category]![index] = updatedService;
// //     categories.refresh();
// //   }
// //
// //   void addCustomService() {
// //     final service = ServiceItem(title: '', isCustom: true);
// //     categories['Custom Services']!.add(service);
// //     selectCategory('Custom Services');
// //     categories.refresh();
// //   }
// //
// //   void removeCustomService(String category, int index) {
// //     categories[category]!.removeAt(index);
// //     categories.refresh();
// //   }
// //
// //   int getEnabledServicesCount(String category) {
// //     return categories[category]?.where((s) => s.isEnabled).length ?? 0;
// //   }
// //
// //   int getTotalServicesCount(String category) {
// //     return categories[category]?.length ?? 0;
// //   }
// //
// //   IconData getCategoryIcon(String category) {
// //     const icons = {
// //       'Custom Services': Icons.add,
// //       'Electrician': Icons.electrical_services,
// //       'Plumber': Icons.plumbing,
// //       'Carpenter / Joiner': Icons.handyman,
// //     };
// //     return icons[category] ?? Icons.build;
// //   }
// //
// //   Future<void> saveUserServices() async {
// //     try {
// //       final largeJobList =
// //       categories.entries
// //           .map((entry) {
// //         final category = entry.key;
// //         final enabledServices =
// //         entry.value
// //             .where((s) => s.isEnabled)
// //             .map((s) => s.toMap())
// //             .toList();
// //         if (enabledServices.isNotEmpty ||
// //             category == 'Custom Services') {
// //           return {'category': category, 'services': enabledServices};
// //         }
// //         return null;
// //       })
// //           .where((item) => item != null)
// //           .toList();
// //
// //       await _firestore.collection('users').doc(userId).set({
// //         'largejoblist': largeJobList,
// //       }, SetOptions(merge: true));
// //
// //       Get.snackbar('Success', 'Prices saved successfully');
// //       if (fromProfile.value) {
// //         // If came from profile, just go back
// //         Get.back();
// //       } else {
// //         // If came from signup flow, proceed to onboarding
// //         Get.off(() => const TraderOnboardingPage());
// //       }
// //     } catch (e) {
// //       Get.snackbar('Error', 'Failed to save services: ${e.toString()}');
// //     }
// //   }
// //
// //   // Initialize Firebase with predefined small jobs data
// //   Future<void> initializePredefinedServices() async {
// //     try {
// //       isLoading(true);
// //
// //       // Check if data already exists
// //       final existingData =
// //       await _firestore.collection('Services').doc('largejoblist').get();
// //       if (existingData.exists) {
// //         print('Predefined services already exist in Firebase');
// //         await loadCategories(); // Reload categories
// //         return;
// //       }
// //
// //       // Predefined services data organized by category
// //       final predefinedServices = {
// //         'Electrician': [
// //           'Replace socket',
// //           'Install light fitting',
// //           'Replace light switch',
// //           'Install extractor fan',
// //           'Replace fuse',
// //           'Install outside security light',
// //         ],
// //         'Plumber': [
// //           'Fix leaking tap',
// //           'Replace tap',
// //           'Unblock sink or toilet',
// //           'Install new kitchen or basin tap',
// //           'Replace toilet flush mechanism',
// //           'Fit outside tap',
// //           'Seal around sink or bath',
// //         ],
// //         'Heating Engineer / Gas Engineer': [
// //           'Bleed radiators',
// //           'Replace thermostat',
// //           'Service boiler',
// //           'Replace radiator valve',
// //           'Balance heating system',
// //           'Fit new radiator',
// //         ],
// //         'Carpenter / Joiner': [
// //           'Hang internal door',
// //           'Trim door',
// //           'Fit door handles or locks',
// //           'Fit skirting board',
// //           'Install shelves',
// //           'Repair floorboard',
// //           'Box in pipework',
// //         ],
// //         'Painter & Decorator': [
// //           'Paint a single wall',
// //           'Touch up marked walls',
// //           'Paint internal door',
// //           'Paint front door',
// //         ],
// //         'Tiler': [
// //           'Re-grout tiles',
// //           'Replace cracked tile',
// //           'Tile kitchen splashback',
// //           'Seal around tiles',
// //         ],
// //         'Plasterer': [
// //           'Patch repair small wall',
// //           'Skim ceiling',
// //           'Plaster small boxing-in section',
// //         ],
// //         'Roofer': [
// //           'Replace broken tile',
// //           'Seal flashing',
// //           'Patch flat roof',
// //           'Clear blocked gutter',
// //           'Soffit repair',
// //           'Re-seal leaking gutter joint',
// //         ],
// //         'Flooring Specialist': [
// //           'Repair lifted floor plank',
// //           'Fit door threshold strip',
// //           'Replace carpet gripper',
// //         ],
// //         'Bricklayer / Builder': [
// //           'Re-point small wall section',
// //           'Repair step or brick crack',
// //           'Patch render/masonry',
// //         ],
// //         'Window Fitter / Glazier': [
// //           'Replace single-glazed pane',
// //           'Adjust stiff window',
// //           'Reseal draughty window',
// //           'Replace handle or hinge',
// //         ],
// //         'Locksmith': [
// //           'Replace front door lock',
// //           'Fit night latch or deadbolt',
// //           'Adjust misaligned lock',
// //           'Unlock jammed internal door',
// //         ],
// //         'Drainage Specialist': [
// //           'Unblock outdoor drain',
// //           'Jet-wash drain',
// //           'Reseal gully trap',
// //           'Clear debris from downpipe',
// //         ],
// //         'Gutter Cleaner / Installer': [
// //           'Clean gutters on one side of house',
// //           'Fix gutter bracket',
// //           'Install leaf guard',
// //           'Seal leaking corner joint',
// //         ],
// //         'Fence Installer': [
// //           'Replace fence panel',
// //           'Repair or re-secure post',
// //           'Fit new gate latch',
// //           'Straighten leaning fence section',
// //         ],
// //         'Driveway / Paving Installer': [
// //           'Re-sand block paving',
// //           'Clean driveway surface',
// //           'Repair 1–2 sunken blocks',
// //           'Edge tarmac border',
// //         ],
// //         'Scaffolder': [
// //           'Install small scaffold tower (e.g. for gutter access)',
// //           'Dismantle small scaffolding section',
// //           'Add handrail or guard rail',
// //           'Provide temporary working platform',
// //         ],
// //         'Gardener / Landscaper': [
// //           'Mow lawn',
// //           'Trim hedges',
// //           'Remove garden waste',
// //           'Weed flower beds',
// //           'Lay small turf patch',
// //           'Install edging or border',
// //         ],
// //         'Tree Surgeon / Arborist': [
// //           'Prune low branches',
// //           'Remove small tree',
// //           'Trim overhanging limb',
// //           'Grind small stump',
// //         ],
// //         'Decking Installer': [
// //           'Replace deck board',
// //           'Clean and treat decking',
// //           'Fit handrail or edging',
// //           'Secure loose board',
// //         ],
// //         'Pest Control': [
// //           'Treat wasp nest',
// //           'Lay traps or bait for rodents',
// //           'Spray for ants or insects',
// //           'Block common rodent entry point',
// //         ],
// //         'Fire Alarm / Security System Installer': [
// //           'Install smoke or heat alarm',
// //           'Replace alarm battery or sensor',
// //           'Service alarm system',
// //           'Test and reconfigure home alarm',
// //         ],
// //         'CCTV Installer': [
// //           'Install basic external camera',
// //           'Re-align or adjust CCTV angle',
// //           'Connect CCTV to app or Wi-Fi',
// //           'Replace camera unit',
// //         ],
// //       };
// //
// //       // Create service items for each category and organize them
// //       Map<String, List<Map<String, dynamic>>> organizedServices = {};
// //
// //       for (String category in predefinedServices.keys) {
// //         final services =
// //         predefinedServices[category]!
// //             .map(
// //               (title) => ServiceItem(title: title, isCustom: false).toMap(),
// //         )
// //             .toList();
// //         organizedServices[category] = services;
// //       }
// //
// //       // Save all predefined services to Services/largejoblist document
// //       await _firestore.collection('Services').doc('largejoblist').set({
// //         'predefinedServices': organizedServices,
// //         'createdAt': FieldValue.serverTimestamp(),
// //         'updatedAt': FieldValue.serverTimestamp(),
// //       });
// //
// //       print(
// //         'Successfully initialized ${predefinedServices.length} categories with predefined services',
// //       );
// //
// //       // Reload the categories after initialization
// //       await loadCategories();
// //
// //       Get.snackbar('Success', 'Predefined services initialized successfully!');
// //     } catch (e) {
// //       print('Error initializing predefined services: $e');
// //       Get.snackbar('Error', 'Failed to initialize services: ${e.toString()}');
// //     } finally {
// //       isLoading(false);
// //     }
// //   }
// // }



