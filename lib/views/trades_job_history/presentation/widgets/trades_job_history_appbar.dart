part of 'widgets.dart';

class TradesJobHistoryAppbar extends StatefulWidget
    implements PreferredSizeWidget {
  final Type? currentScreen; // To track the current screen

  const TradesJobHistoryAppbar({super.key, required this.currentScreen});

  @override
  State<TradesJobHistoryAppbar> createState() => _TradesJobHistoryAppbarState();

  @override
  Size get preferredSize => const Size.fromHeight(120);
}

class _TradesJobHistoryAppbarState extends State<TradesJobHistoryAppbar> {
  late bool _isNomapTapped;
  late bool _isMapTapped;

  @override
  void initState() {
    super.initState();
    // Set initial state based on currentScreen
    _isNomapTapped = widget.currentScreen != MapScreen;
    _isMapTapped = widget.currentScreen == MapScreen;
  }

  void _navigateToMapScreen(BuildContext context) {
    if (widget.currentScreen != MapScreen) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MapScreen()),
      );
    }
  }

  void _navigateToTradesPage(BuildContext context) {
    if (widget.currentScreen != TradesPage) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const TradesJobHistoryPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: 120,
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
              color: Colors.black.withOpacity(0.1),
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
                    alignment: Alignment.center,
                    children: [
                      // Centered title
                      Positioned.fill(
                        child: Center(
                          child: Text(
                            "Job History",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      // Right-aligned icons
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppColor.midGray,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isNomapTapped = true;
                                    _isMapTapped = false;
                                  });
                                  _navigateToTradesPage(context);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color:
                                        _isNomapTapped
                                            ? AppColor.darkBlue
                                            : Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: SvgPicture.asset(
                                    Assets.svgsNomap,
                                    color: AppColor.white,
                                    width: 24,
                                    height: 24,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isMapTapped = true;
                                    _isNomapTapped = false;
                                  });
                                  _navigateToMapScreen(context);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color:
                                        _isMapTapped
                                            ? AppColor.darkBlue
                                            : Colors.transparent,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: SvgPicture.asset(
                                    Assets.svgsMap,
                                    color: AppColor.white,
                                    width: 24,
                                    height: 24,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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
