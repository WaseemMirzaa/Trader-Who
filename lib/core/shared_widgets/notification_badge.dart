import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/notification_controller.dart';

/// A badge widget that displays the unread notification count
class NotificationBadge extends StatelessWidget {
  final Widget child;
  final bool showZero;

  const NotificationBadge({
    super.key,
    required this.child,
    this.showZero = false,
  });

  @override
  Widget build(BuildContext context) {
    // Get or create NotificationController
    final notificationController =
        Get.isRegistered<NotificationController>()
            ? Get.find<NotificationController>()
            : Get.put(NotificationController());

    return Obx(() {
      final count = notificationController.unreadCount.value;
      final shouldShowBadge = showZero ? true : count > 0;

      return Stack(
        clipBehavior: Clip.none,
        children: [
          child,
          if (shouldShowBadge)
            Positioned(
              right: -2,
              top: -2,
              child: Container(
                padding: const EdgeInsets.all(4),
                constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
                child: Center(
                  child: Text(
                    count > 99 ? '99+' : count.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      height: 1.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
        ],
      );
    });
  }
}
