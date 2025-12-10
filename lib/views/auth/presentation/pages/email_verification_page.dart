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

    return TraderouScaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Main Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.grey.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Animated Icon
                    Obx(
                      () => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color:
                              controller.isVerified.value
                                  ? AppColor.successGreen.withOpacity(0.1)
                                  : AppColor.primaryButton.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          controller.isVerified.value
                              ? Icons.check_circle_rounded
                              : Icons.mail_outline_rounded,
                          size: 36,
                          color:
                              controller.isVerified.value
                                  ? AppColor.successGreen
                                  : AppColor.primaryButton,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Title
                    Obx(
                      () => Text(
                        controller.isVerified.value
                            ? 'Email Verified!'
                            : 'Check Your Email',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: AppColor.primaryText,
                          fontFamily: 'openSans',
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Description
                    Obx(
                      () => Text(
                        controller.isVerified.value
                            ? 'Your email has been successfully verified. You can now continue to your account.'
                            : 'We\'ve sent a verification link to\n$userEmail\n\nPlease check your email and click the link to verify your account.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColor.secondaryText,
                          fontFamily: 'openSans',
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

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
                                                AppColor.secondaryText
                                                    .withOpacity(0.6),
                                              ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Waiting for verification...',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppColor.secondaryText
                                              .withOpacity(0.8),
                                          fontFamily: 'openSans',
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              )
                              : const SizedBox.shrink(),
                    ),

                    // Continue Button
                    Obx(
                      () => SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed:
                              controller.isLoading.value
                                  ? null
                                  : controller.handleContinue,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                controller.isVerified.value
                                    ? AppColor.successGreen
                                    : AppColor.primaryButton,
                            foregroundColor: AppColor.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            disabledBackgroundColor: AppColor.primaryButton
                                .withOpacity(0.6),
                          ),
                          child:
                              controller.isLoading.value
                                  ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: AppColor.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                  : Text(
                                    controller.isVerified.value
                                        ? 'Go to Dashboard'
                                        : 'Continue',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: AppColor.white,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'openSans',
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
                                  const SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Didn\'t receive the email? ',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppColor.secondaryText
                                              .withOpacity(0.8),
                                          fontFamily: 'openSans',
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
                                                          AppColor
                                                              .primaryButton,
                                                        ),
                                                  ),
                                                )
                                                : Text(
                                                  'Resend',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color:
                                                        AppColor.primaryButton,
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: 'openSans',
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
                    const SizedBox(height: 24),
                    Text(
                      'Make sure to check your spam folder if you don\'t see the email.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColor.secondaryText.withOpacity(0.6),
                        fontFamily: 'openSans',
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
