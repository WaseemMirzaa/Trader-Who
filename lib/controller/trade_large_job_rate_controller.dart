import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:traderwho/models/models.dart';
import 'package:traderwho/views/trade_onboarding/presentation/pages/pages.dart';

class TradeRateLargeJobController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  final RxBool fromProfile = false.obs;
  final RxMap<String, List<ServiceItem>> categories = <String, List<ServiceItem>>{}.obs;
  final RxString selectedCategory = RxString('');
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fromProfile.value = Get.arguments == true;
    print('🔥 Controller initialized. From profile: \${fromProfile.value}');
    initializeAndLoadCategories();
  }

  Future<void> initializeAndLoadCategories() async {
    try {
      isLoading(true);
      print('🔍 Checking for existing largejoblist...');

      final existingData = await _firestore.collection('Services').doc('largejoblist').get();

      if (!existingData.exists) {
        print('📦 No predefined services found. Initializing...');
        await initializePredefinedServices();
      } else {
        print('✅ Predefined services found. Loading...');
        await loadCategories();
      }
    } catch (e) {
      print('❌ Error in initializeAndLoadCategories: \$e');
      await loadCategories();
    }
  }

  Future<void> loadCategories() async {
    isLoading(true);
    print('📤 Loading categories...');
    try {
      if (userId.isEmpty) {
        print('❌ User ID is empty');
        Get.snackbar('Error', 'User not authenticated');
        isLoading(false);
        return;
      }

      categories.clear();
      categories['Custom Services'] = [];
      print('📂 Initialized "Custom Services"');

      final userDoc = await _firestore.collection('users').doc(userId).get();
      final snapshot = await _firestore.collection('Services').doc('largejoblist').get();

      if (!snapshot.exists || snapshot.data() == null) {
        print('⚠️ No predefined large job services found.');
        Get.snackbar(
          'Warning',
          'No services found in largejoblist. You can add custom services.',
        );
      } else {
        final data = snapshot.data()!;
        final predefinedServices = data['predefinedServices'] as Map<String, dynamic>? ?? {};
        print('✅ Loaded \${predefinedServices.keys.length} predefined categories');

        for (String category in predefinedServices.keys) {
          final services = (predefinedServices[category] as List? ?? [])
              .map((item) => ServiceItem.fromMap(item as Map<String, dynamic>))
              .toList();

          categories[category] = services;
          print('→ Added \${services.length} services to category: \$category');
        }
      }

      if (userDoc.exists && userDoc.data()!.containsKey('largejoblist')) {
        final userServices = userDoc['largejoblist'] as List;
        print('🧍 Found \${userServices.length} user custom categories');

        for (var categoryData in userServices) {
          final category = categoryData['category'] as String;
          final userServiceList = categoryData['services'] as List? ?? [];

          for (var userService in userServiceList) {
            final index = categories[category]?.indexWhere((item) => item.title == userService['title']) ?? -1;

            if (index != -1) {
              categories[category]![index] = ServiceItem.fromMap(userService);
              print('✅ Updated existing service: ${userService['title']}');
            } else if (category == 'Custom Services') {
              categories[category]!.add(ServiceItem.fromMap(userService));
              print('➕ Added custom service: ${userService['title']}');
            }
          }
        }
      }
    } catch (e) {
      print('❌ Failed to load services: \$e');
      Get.snackbar('Error', 'Failed to load services: \${e.toString()}');
    } finally {
      isLoading(false);
      print('✅ Finished loading services.');
    }
  }

  void selectCategory(String? category) {
    selectedCategory.value = category ?? '';
    print('📌 Selected category: \${selectedCategory.value}');
  }

  void updateService(String category, int index, ServiceItem updatedService) {
    print('✏️ Updating service: \${updatedService.title} in \$category');
    categories[category]![index] = updatedService;
    categories.refresh();
  }

  void addCustomService() {
    final service = ServiceItem(title: '', isCustom: true);
    categories['Custom Services']!.add(service);
    selectCategory('Custom Services');
    categories.refresh();
    print('➕ Custom service added and selected.');
  }

  void removeCustomService(String category, int index) {
    print('🗑 Removing custom service from \$category at index \$index');
    categories[category]!.removeAt(index);
    categories.refresh();
  }

  int getEnabledServicesCount(String category) {
    final count = categories[category]?.where((s) => s.isEnabled).length ?? 0;
    print('✔️ \$count enabled services in \$category');
    return count;
  }

  int getTotalServicesCount(String category) {
    final total = categories[category]?.length ?? 0;
    print('📊 \$total total services in \$category');
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

  Future<void> saveUserServices() async {
    try {
      final largeJobList = categories.entries
          .map((entry) {
        final category = entry.key;
        final enabledServices = entry.value
            .where((s) => s.isEnabled)
            .map((s) => s.toMap())
            .toList();
        if (enabledServices.isNotEmpty || category == 'Custom Services') {
          return {'category': category, 'services': enabledServices};
        }
        return null;
      })
          .where((item) => item != null)
          .toList();

      print('💾 Saving \${largeJobList.length} categories to Firestore');
      await _firestore.collection('users').doc(userId).set({
        'largejoblist': largeJobList,
      }, SetOptions(merge: true));

      print('✅ Prices saved successfully!');
      Get.snackbar('Success', 'Prices saved successfully');
      if (fromProfile.value) {
        Get.back();
      } else {
        Get.off(() => const TraderOnboardingPage());
      }
    } catch (e) {
      print('❌ Error saving services: \$e');
      Get.snackbar('Error', 'Failed to save services: \${e.toString()}');
    }
  }

  Future<void> initializePredefinedServices() async {
    try {
      isLoading(true);
      print('🚀 Initializing predefined services for largejoblist...');

      final existingData = await _firestore.collection('Services').doc('largejoblist').get();
      if (existingData.exists) {
        print('ℹ️ Predefined services already exist.');
        await loadCategories();
        return;
      }

      final predefinedServices = {
        'Electrical': [
          'Full or partial house rewire',
          'New consumer unit / fuse board installation',
          'Electric vehicle charger installation',
          'Outdoor lighting systems',
          'Rewiring after water/fire damage',
          'Smart home rewiring and automation',
          'Electrical safety inspections (EICR)',
        ],
        'Plumbing': [
          'Full bathroom installation or renovation',
          'New kitchen plumbing fit-out',
          'Replacement or relocation of water mains',
          'Installing or replacing full pipework systems',
          'Underfloor heating installation',
          'Large-scale leak detection and repair',
          'Cold water storage tank installations',
        ],
        'Heating & Gas': [
          'Full central heating system installation',
          'Boiler replacement or relocation',
          'Unvented cylinder installation',
          'Radiator relocation or full system upgrade',
          'Smart thermostat installation (with zone control)',
          'Full system power flush',
        ],
        'Joinery / Carpentry': [
          'Full staircase replacement',
          'Loft boarding or loft conversions',
          'Kitchen fitting / bespoke cabinetry',
          'Full internal door refit',
          'Roof truss construction or repairs',
        ],
        'Painting & Decorating': [
          'Whole house internal painting',
          'Full external house repainting',
          'Listed building / heritage property work',
          'Wallpapering multiple rooms or feature walls',
          'Decorative ceiling and cornice restorations',
        ],
        'Roofing': [
          'Full roof replacement',
          'Flat roof installation or full felt re-lay',
          'Chimney rebuild or removal',
          'Roof truss replacements',
          'Gutter, soffit, and fascia full replacements',
        ],
        'Bricklaying / Building Work': [
          'Home extensions',
          'Garage conversions',
          'Structural wall removal (with RSJ)',
          'Full driveway or patio installation',
          'Garden wall and boundary wall builds',
        ],
        'Window & Door Installation': [
          'Whole home window replacement',
          'Bi-fold / sliding door installation',
          'Conservatory installation',
          'Skylight or rooflight fitting',
        ],
        'Plastering / Rendering': [
          'Full house skim / re-skim',
          'External rendering (monocouche or silicone)',
          'Damp proofing and tanking',
          'Soundproofing installs',
        ],
        'Landscaping & Fencing': [
          'Full garden redesign',
          'Large decking installations',
          'Garden room/summer house builds',
          'Boundary fencing for full property',
          'Artificial grass or turf laying on large plots',
        ],
        'Solar & Renewables': [
          'Solar PV system installation',
          'Battery storage integration',
          'Heat pump installations (air or ground source)',
          'EV infrastructure install for commercial use',
        ],
        'Security & CCTV': [
          'Full home CCTV system with multiple zones',
          'Smart home security and alarm integration',
          'Access control systems for gates and properties',
        ],
      };

      Map<String, List<Map<String, dynamic>>> organizedServices = {};
      for (String category in predefinedServices.keys) {
        final services = predefinedServices[category]!
            .map((title) => ServiceItem(title: title, isCustom: false).toMap())
            .toList();
        organizedServices[category] = services;
      }

      await _firestore.collection('Services').doc('largejoblist').set({
        'predefinedServices': organizedServices,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      print('✅ Initialized \${predefinedServices.length} categories with services');
      await loadCategories();
      Get.snackbar('Success', 'Predefined services initialized successfully!');
    } catch (e) {
      print('❌ Error initializing predefined services: \$e');
      Get.snackbar('Error', 'Failed to initialize services: \${e.toString()}');
    } finally {
      isLoading(false);
    }
  }
}