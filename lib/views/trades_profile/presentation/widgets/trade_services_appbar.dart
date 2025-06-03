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
      backgroundColor: AppColor.appbarBackground,
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
          boxShadow: [
            BoxShadow(
              color: AppColor.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
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
                          "Services",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 19,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder:
                                  (context) => CustomDialogs.addService(
                                    onSave: (newService) {
                                      if (newService != null) {
                                        // Add the new service to your list
                                        // Using Provider:
                                        // context.read<ServicesProvider>().addService(newService);
                                        // Or using StatefulWidget:
                                        setState(() {
                                          services.add(newService);
                                        });
                                      }
                                      Navigator.pop(
                                        context,
                                      ); // Close the dialog
                                    },
                                  ),
                            );
                          },
                          child: Container(
                            width: context.responsiveWidth(10),
                            height: context.responsiveWidth(10),
                            decoration: BoxDecoration(
                              color:
                                  AppColor
                                      .orangecustomColor, // Dark blue background
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
