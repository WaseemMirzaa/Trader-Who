part of 'pages.dart';

class EmailVerificationScreen extends StatelessWidget {
  const EmailVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Retrieve arguments
    final arguments = Get.arguments as Map<String, dynamic>;
    final String userEmail = arguments['email'] as String;
    final UserModel userModel = arguments['userModel'] as UserModel;
    final String userId = arguments['userId'] as String;
    final bool isTradesperson = arguments['isTradesperson'] as bool;

    // Initialize controller
    final controller = Get.put(
      EmailVerificationController(
        userEmail: userEmail,
        userModel: userModel,
        userId: userId,
        isTradesperson: isTradesperson,
      ),
    );

    return TraderWhoScaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Main Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32.0),
                decoration: BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Animated Icon
                    Obx(
                      () => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color:
                              controller.isVerified.value
                                  ? Colors.green.withOpacity(0.1)
                                  : Get.theme.primaryColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          controller.isVerified.value
                              ? Icons.check_circle_rounded
                              : Icons.mail_outline_rounded,
                          size: 40,
                          color:
                              controller.isVerified.value
                                  ? Colors.green
                                  : Get.theme.primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Title
                    Obx(
                      () => Text(
                        controller.isVerified.value
                            ? 'Email Verified!'
                            : 'Check Your Email',
                        style: Get.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Get.theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Description
                    Obx(
                      () => Text(
                        controller.isVerified.value
                            ? 'Your email has been successfully verified. You can now continue to your account.'
                            : 'We\'ve sent a verification link to\n$userEmail\n\nPlease check your email and click the link to verify your account.',
                        textAlign: TextAlign.center,
                        style: Get.textTheme.bodyMedium?.copyWith(
                          color: Get.theme.colorScheme.onSurface.withOpacity(
                            0.7,
                          ),
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Status Indicator
                    Obx(
                      () =>
                          !controller.isVerified.value
                              ? Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Get.theme.colorScheme.onSurface
                                                    .withOpacity(0.4),
                                              ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Waiting for verification...',
                                        style: Get.textTheme.bodySmall
                                            ?.copyWith(
                                              color: Get
                                                  .theme
                                                  .colorScheme
                                                  .onSurface
                                                  .withOpacity(0.6),
                                            ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 24),
                                ],
                              )
                              : const SizedBox.shrink(),
                    ),

                    // Continue Button
                    Obx(
                      () => SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed:
                              controller.isLoading.value
                                  ? null
                                  : controller.handleContinue,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                controller.isVerified.value
                                    ? Colors.green
                                    : Get.theme.primaryColor,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            disabledBackgroundColor: Get.theme.primaryColor
                                .withOpacity(0.6),
                          ),
                          child:
                              controller.isLoading.value
                                  ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                  : Text(
                                    controller.isVerified.value
                                        ? 'Go to Dashboard'
                                        : 'Continue',
                                    style: Get.textTheme.titleMedium?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                        ),
                      ),
                    ),

                    // Resend Email Option
                    Obx(
                      () =>
                          !controller.isVerified.value
                              ? Column(
                                children: [
                                  const SizedBox(height: 24),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Didn\'t receive the email? ',
                                        style: Get.textTheme.bodySmall
                                            ?.copyWith(
                                              color: Get
                                                  .theme
                                                  .colorScheme
                                                  .onSurface
                                                  .withOpacity(0.6),
                                            ),
                                      ),
                                      GestureDetector(
                                        onTap:
                                            controller.isResending.value
                                                ? null
                                                : controller.handleResendEmail,
                                        child:
                                            controller.isResending.value
                                                ? SizedBox(
                                                  width: 12,
                                                  height: 12,
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: 1.5,
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                          Color
                                                        >(
                                                          Get
                                                              .theme
                                                              .primaryColor,
                                                        ),
                                                  ),
                                                )
                                                : Text(
                                                  'Resend',
                                                  style: Get.textTheme.bodySmall
                                                      ?.copyWith(
                                                        color:
                                                            Get
                                                                .theme
                                                                .primaryColor,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                              : const SizedBox.shrink(),
                    ),

                    // Footer
                    const SizedBox(height: 32),
                    Text(
                      'Make sure to check your spam folder if you don\'t see the email.',
                      textAlign: TextAlign.center,
                      style: Get.textTheme.bodySmall?.copyWith(
                        color: Get.theme.colorScheme.onSurface.withOpacity(0.4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
