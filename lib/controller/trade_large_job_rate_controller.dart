// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_rx/src/rx_types/rx_types.dart';
// import 'package:get/get_state_manager/src/simple/get_controllers.dart';
// import 'package:traderwho/models/models.dart';
// import 'package:traderwho/views/trade_onboarding/presentation/pages/pages.dart';

// class TradeRateLargeJobController extends GetxController {
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
//     fromProfile.value = Get.arguments == true;
//     print('🔥 Controller initialized. From profile: \${fromProfile.value}');
//     initializeAndLoadCategories();
//   }

//   Future<void> initializeAndLoadCategories() async {
//     try {
//       isLoading(true);
//       print('🔍 Checking for existing largejoblist...');

//       final existingData =
//           await _firestore.collection('Services').doc('largejoblist').get();

//       if (!existingData.exists) {
//         print('📦 No predefined services found. Initializing...');
//         await initializePredefinedServices();
//       } else {
//         print('✅ Predefined services found. Loading...');
//         await loadCategories();
//       }
//     } catch (e) {
//       print('❌ Error in initializeAndLoadCategories: \$e');
//       await loadCategories();
//     }
//   }

//   Future<void> loadCategories() async {
//     isLoading(true);
//     print('📤 Loading categories...');
//     try {
//       if (userId.isEmpty) {
//         print('❌ User ID is empty');
//         Get.snackbar('Error', 'User not authenticated');
//         isLoading(false);
//         return;
//       }

//       categories.clear();
//       categories['Custom Services'] = [];
//       print('📂 Initialized "Custom Services"');

//       // final userDoc = await _firestore.collection('users').doc(userId).get();
//       final servicesPricesSnap =
//           await _firestore
//               .collection('services_prices')
//               .where('jobType', isEqualTo: 'largeJob')
//               .where('trader_id', isEqualTo: userId)
//               .get();
//       final snapshot =
//           await _firestore.collection('Services').doc('largejoblist').get();

//       if (!snapshot.exists || snapshot.data() == null) {
//         print('⚠️ No predefined large job services found.');
//         Get.snackbar(
//           'Warning',
//           'No services found in largejoblist. You can add custom services.',
//         );
//       } else {
//         final data = snapshot.data()!;
//         final predefinedServices =
//             data['predefinedServices'] as Map<String, dynamic>? ?? {};
//         print(
//           '✅ Loaded \${predefinedServices.keys.length} predefined categories',
//         );

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

//           // Sort services by name alphabetically
//           sortServicesByName(services);

//           categories[category] = services;
//           print('→ Added \${services.length} services to category: \$category');
//         }
//       }

//       // if (userDoc.exists && userDoc.data()!.containsKey('largejoblist')) {
//       List<QueryDocumentSnapshot<Map<String, dynamic>>> userServices =
//           servicesPricesSnap.docs;
//       print('🧍 Found \${userServices.length} user services');

//       for (QueryDocumentSnapshot<Map<String, dynamic>> userService
//           in userServices) {
//         final categoryValue = userService.data()['category'];
//         if (categoryValue == null) {
//           print('⚠️ Skipping service with null category: ${userService.id}');
//           continue;
//         }
//         final category = categoryValue as String;

//         // Check if userService.id is not null and contains underscore
//         if (userService.id.isEmpty || !userService.id.contains('_')) {
//           print(
//             '⚠️ Skipping service with invalid ID format: ${userService.id}',
//           );
//           continue;
//         }

//         final serviceParts = userService.id.split("_");
//         if (serviceParts.length < 2) {
//           print(
//             '⚠️ Skipping service with invalid ID format: ${userService.id}',
//           );
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
//             print('✅ Updated existing service: $title in $category');
//           } catch (e) {
//             print('⚠️ Error parsing existing service ${userService.id}: $e');
//           }
//         } else {
//           try {
//             categories[category]!.add(ServiceItem.fromMap(userService.data()));
//             final title =
//                 userService.data()['title'] ??
//                 userService.data()['name'] ??
//                 'Unknown Service';
//             print('➕ Added service: $title to category: $category');
//           } catch (e) {
//             print('⚠️ Error parsing service ${userService.id}: $e');
//           }
//         }
//       }

//       // Sort all services within each category
//       for (String category in categories.keys) {
//         if (categories[category]!.isNotEmpty) {
//           sortServicesByName(categories[category]!);
//         }
//       }

//       // Sort categories by name to ensure consistent ordering
//       final sortedCategories = sortCategoriesByName(categories);
//       categories.clear();
//       categories.addAll(sortedCategories);

//       // }
//     } catch (e) {
//       print('❌ Failed to load services: $e');
//       Get.snackbar('Error', 'Failed to load services: ${e.toString()}');
//     } finally {
//       isLoading(false);
//       print('✅ Finished loading services.');
//     }
//   }

//   void selectCategory(String? category) {
//     selectedCategory.value = category ?? '';
//     print('📌 Selected category: \${selectedCategory.value}');
//   }

//   /// Helper method to sort services by name alphabetically
//   void sortServicesByName(List<ServiceItem> services) {
//     services.sort(
//       (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
//     );
//   }

//   /// Helper method to sort categories by name alphabetically
//   Map<String, List<ServiceItem>> sortCategoriesByName(
//     Map<String, List<ServiceItem>> categoriesMap,
//   ) {
//     final sortedCategories = <String, List<ServiceItem>>{};
//     final sortedCategoryNames =
//         categoriesMap.keys.toList()
//           ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

//     for (final categoryName in sortedCategoryNames) {
//       sortedCategories[categoryName] = categoriesMap[categoryName]!;
//     }

//     return sortedCategories;
//   }

//   void updateService(String category, int index, ServiceItem updatedService) {
//     print('✏️ Updating service: \${updatedService.title} in \$category');
//     categories[category]![index] = updatedService;

//     // Re-sort the category to maintain alphabetical order
//     sortServicesByName(categories[category]!);

//     categories.refresh();
//   }

//   void addCustomService() {
//     final service = ServiceItem(
//       title: '',
//       isCustom: true,
//       id: FirebaseFirestore.instance.collection('services').doc().id,
//     );
//     categories['Custom Services']!.add(service);
//     selectCategory('Custom Services');
//     categories.refresh();
//     print('➕ Custom service added and selected.');
//   }

//   void removeCustomService(String category, int index) {
//     print('🗑 Removing custom service from \$category at index \$index');
//     categories[category]!.removeAt(index);
//     categories.refresh();
//   }

//   int getEnabledServicesCount(String category) {
//     final count = categories[category]?.where((s) => s.isEnabled).length ?? 0;
//     print('✔️ \$count enabled services in \$category');
//     return count;
//   }

//   int getTotalServicesCount(String category) {
//     final total = categories[category]?.length ?? 0;
//     print('📊 \$total total services in \$category');
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

//       print('💾 Saving $enabledCategoriesCount categories to Firestore');
//       // await _firestore.collection('users').doc(userId).set({
//       //   'largejoblist': largeJobList,
//       // }, SetOptions(merge: true));

//       // Also save individual services with userId_serviceId format
//       await saveIndividualServices();

//       print('✅ Prices saved successfully!');
//       Get.snackbar('Success', 'Prices saved successfully');
//       if (fromProfile.value) {
//         Get.back();
//       } else {
//         Get.off(() => const TraderOnboardingPage());
//       }
//     } catch (e) {
//       print('❌ Error saving services: \$e');
//       Get.snackbar('Error', 'Failed to save services: \${e.toString()}');
//     }
//   }

//   /// Save individual services with docId format: userId_serviceId
//   Future<void> saveIndividualServices() async {
//     try {
//       print('💾 Saving individual services with userId_serviceId format...');

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
//               'jobType': 'largeJob',
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

//             print('✅ Saved service: ${service.title} with docId: $docId');
//           }
//         }
//       }

//       print('✅ All individual services saved successfully!');
//     } catch (e) {
//       print('❌ Error saving individual services: $e');
//     }
//   }

//   /// Save a single service with userId_serviceId format
//   Future<void> saveSingleService(String category, ServiceItem service) async {
//     try {
//       if (!service.isEnabled || service.price == null || service.price! <= 0) {
//         print('⚠️ Service not enabled or price not set');
//         return;
//       }

//       // Use existing service ID
//       final serviceId = service.id;
//       final docId = '${userId}_$serviceId';

//       final serviceData = {
//         'name': service.title,
//         'category': category,
//         'jobId': serviceId,
//         'jobType': 'largeJob',
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

//       print('✅ Single service saved: ${service.title} with docId: $docId');
//       Get.snackbar('Success', 'Service "${service.title}" saved successfully');
//     } catch (e) {
//       print('❌ Error saving single service: $e');
//       Get.snackbar('Error', 'Failed to save service: ${e.toString()}');
//     }
//   }

//   Future<void> initializePredefinedServices() async {
//     try {
//       isLoading(true);
//       print('🚀 Initializing predefined services for largejoblist...');

//       final existingData =
//           await _firestore.collection('Services').doc('largejoblist').get();
//       if (existingData.exists) {
//         print('ℹ️ Predefined services already exist.');
//         await loadCategories();
//         return;
//       }

//       final predefinedServices = {
//         'Electrical': [
//           'Full or partial house rewire',
//           'New consumer unit / fuse board installation',
//           'Electric vehicle charger installation',
//           'Outdoor lighting systems',
//           'Rewiring after water/fire damage',
//           'Smart home rewiring and automation',
//           'Electrical safety inspections (EICR)',
//         ],
//         'Plumbing': [
//           'Full bathroom installation or renovation',
//           'New kitchen plumbing fit-out',
//           'Replacement or relocation of water mains',
//           'Installing or replacing full pipework systems',
//           'Underfloor heating installation',
//           'Large-scale leak detection and repair',
//           'Cold water storage tank installations',
//         ],
//         'Heating & Gas': [
//           'Full central heating system installation',
//           'Boiler replacement or relocation',
//           'Unvented cylinder installation',
//           'Radiator relocation or full system upgrade',
//           'Smart thermostat installation (with zone control)',
//           'Full system power flush',
//         ],
//         'Joinery / Carpentry': [
//           'Full staircase replacement',
//           'Loft boarding or loft conversions',
//           'Kitchen fitting / bespoke cabinetry',
//           'Full internal door refit',
//           'Roof truss construction or repairs',
//         ],
//         'Painting & Decorating': [
//           'Whole house internal painting',
//           'Full external house repainting',
//           'Listed building / heritage property work',
//           'Wallpapering multiple rooms or feature walls',
//           'Decorative ceiling and cornice restorations',
//         ],
//         'Roofing': [
//           'Full roof replacement',
//           'Flat roof installation or full felt re-lay',
//           'Chimney rebuild or removal',
//           'Roof truss replacements',
//           'Gutter, soffit, and fascia full replacements',
//         ],
//         'Bricklaying / Building Work': [
//           'Home extensions',
//           'Garage conversions',
//           'Structural wall removal (with RSJ)',
//           'Full driveway or patio installation',
//           'Garden wall and boundary wall builds',
//         ],
//         'Window & Door Installation': [
//           'Whole home window replacement',
//           'Bi-fold / sliding door installation',
//           'Conservatory installation',
//           'Skylight or rooflight fitting',
//         ],
//         'Plastering / Rendering': [
//           'Full house skim / re-skim',
//           'External rendering (monocouche or silicone)',
//           'Damp proofing and tanking',
//           'Soundproofing installs',
//         ],
//         'Landscaping & Fencing': [
//           'Full garden redesign',
//           'Large decking installations',
//           'Garden room/summer house builds',
//           'Boundary fencing for full property',
//           'Artificial grass or turf laying on large plots',
//         ],
//         'Solar & Renewables': [
//           'Solar PV system installation',
//           'Battery storage integration',
//           'Heat pump installations (air or ground source)',
//           'EV infrastructure install for commercial use',
//         ],
//         'Security & CCTV': [
//           'Full home CCTV system with multiple zones',
//           'Smart home security and alarm integration',
//           'Access control systems for gates and properties',
//         ],
//       };

//       Map<String, List<Map<String, dynamic>>> organizedServices = {};
//       for (String category in predefinedServices.keys) {
//         final services =
//             predefinedServices[category]!
//                 .map(
//                   (title) =>
//                       ServiceItem(
//                         title: title,
//                         isCustom: false,
//                         id:
//                             FirebaseFirestore.instance
//                                 .collection('services')
//                                 .doc()
//                                 .id,
//                       ).toMap(),
//                 )
//                 .toList();
//         organizedServices[category] = services;
//       }

//       await _firestore.collection('Services').doc('largejoblist').set({
//         'predefinedServices': organizedServices,
//         'createdAt': FieldValue.serverTimestamp(),
//         'updatedAt': FieldValue.serverTimestamp(),
//       });

//       print(
//         '✅ Initialized \${predefinedServices.length} categories with services',
//       );
//       await loadCategories();
//       Get.snackbar('Success', 'Predefined services initialized successfully!');
//     } catch (e) {
//       print('❌ Error initializing predefined services: \$e');
//       Get.snackbar('Error', 'Failed to initialize services: \${e.toString()}');
//     } finally {
//       isLoading(false);
//     }
//   }
// }
