part of 'widgets.dart';

class TradeServicesAppbar extends StatefulWidget
    implements PreferredSizeWidget {
  const TradeServicesAppbar({super.key});

  @override
  State<TradeServicesAppbar> createState() => _TradeServicesAppbarState();

  @override
  Size get preferredSize => const Size.fromHeight(70);
}

class _TradeServicesAppbarState extends State<TradeServicesAppbar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColor.appBackground,
      automaticallyImplyLeading: false,
      elevation: 0,
      toolbarHeight: 90,
      flexibleSpace: Container(
        margin: EdgeInsets.zero,
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              children: [
                const SizedBox(height: 16),
                Expanded(
                  child: Stack(
                    children: [
                      // Back button on the left
                      Align(
                        alignment: Alignment.centerLeft,
                        child: InkWell(
                          onTap: () => Get.back(),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                            size: 24,
                          ),
                        ),
                      ),

                      // Centered title
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Main Services",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: () {
                            // showDialog(
                            //   context: context,
                            //   builder:
                            //       (context) => CustomDialogs.addService(
                            //         onSave: (newService) {
                            //           if (newService != null) {
                            //             // Close the dialog
                            //             Navigator.pop(context);

                            //             // Add a small delay to ensure dialog is closed before navigation
                            //             Future.delayed(
                            //               const Duration(milliseconds: 100),
                            //               () {
                            //                 // Navigate to the main page with navbar (home screen)
                            //                 final navController =
                            //                     NavigationController.to;
                            //                 navController.setUserType(
                            //                   true,
                            //                 ); // Set as tradesperson
                            //                 navController.navigateToMainPage();

                            //                 // For debugging
                            //                 print(
                            //                   "Navigating to main page after adding service",
                            //                 );
                            //               },
                            //             );
                            //           }
                            //         },
                            //       ),
                            // );
                          },
                          child: Container(
                            width: context.responsiveWidth(10),
                            height: context.responsiveWidth(10),
                            decoration: BoxDecoration(
                              color:
                                  AppColor
                                      .orangecustomColor, // Orange background
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Icon(
                                Icons.add,
                                color: Colors.black,
                                size: context.responsiveWidth(6),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Right-aligned notification icon
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
