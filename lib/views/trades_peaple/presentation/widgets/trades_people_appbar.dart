part of 'widgets.dart';

class TradesPeopleAppbar extends StatefulWidget implements PreferredSizeWidget {
  const TradesPeopleAppbar({super.key});

  @override
  State<TradesPeopleAppbar> createState() => _TradesPeopleAppbarState();

  @override
  Size get preferredSize => const Size.fromHeight(120);
}

class _TradesPeopleAppbarState extends State<TradesPeopleAppbar> {
  bool _isNomapTapped = false;
  bool _isMapTapped = false;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: 120,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.of(context).pop(),
      ),
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
            )
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
                            "Trades People",
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
                                    _isNomapTapped = !_isNomapTapped;
                                    _isMapTapped = false;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: _isNomapTapped ? AppColor.darkBlue : Colors.transparent,
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
                                    _isMapTapped = !_isMapTapped;
                                    _isNomapTapped = false;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: _isMapTapped ? AppColor.darkBlue : Colors.transparent,
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