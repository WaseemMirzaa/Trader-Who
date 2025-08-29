import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:traderwho/core/services/notification_service.dart';

class UserController extends GetxController {
  final Rx<User?> user = Rx<User?>(null);
  final RxString fullName = ''.obs;
  final RxString email = ''.obs;
  final RxBool isLoading = true.obs;
  final RxString error = ''.obs;
  final RxDouble latitude = 0.0.obs;
  final RxDouble longitude = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      isLoading(true);
      error('');

      User? authUser = FirebaseAuth.instance.currentUser;
      if (authUser == null) {
        error('No authenticated user');
        return;
      }

      user.value = authUser;

      // Fetch additional user data from Firestore
      final userDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(authUser.uid)
              .get();

      if (userDoc.exists) {
        await NotificationService.requestNotificationPermission();
        await NotificationService.initializeNotificationState();

        // Initialize Firebase notification listeners
        await NotificationService.initFirebasePushNotification(Get.context!);

        // Setup token refresh listener
        NotificationService.setupTokenRefreshListener();

        // Get and print Firebase token for debugging
        await NotificationService.getFirebaseToken();
        final data = userDoc.data();
        fullName.value = data?['name'] ?? authUser.displayName ?? 'User';
        email.value = data?['email'] ?? authUser.email ?? 'No email';
        latitude.value = data?['lat'] ?? 0.0;
        longitude.value = data?['lon'] ?? 0.0;
      } else {
        // Document doesn't exist, use auth data
        fullName.value = authUser.displayName ?? 'User';
        email.value = authUser.email ?? 'No email';
      }
    } catch (e) {
      error('Failed to fetch user data: ${e.toString()}');
      // Set fallback values
      final authUser = FirebaseAuth.instance.currentUser;
      if (authUser != null) {
        fullName.value = authUser.displayName ?? 'User';
        email.value = authUser.email ?? 'No email';
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> refreshUserData() async {
    await fetchUserData();
  }
}
