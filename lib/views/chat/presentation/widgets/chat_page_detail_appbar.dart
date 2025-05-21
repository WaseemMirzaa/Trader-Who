part of 'widgets.dart';

class ChatPageDetailAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String userName;
  final String avatarImage; // Not used in this case, kept for compatibility

  const ChatPageDetailAppBar({
    super.key,
    required this.userName,
    required this.avatarImage,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      elevation: 0,
      toolbarHeight: 80,
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
                    children: [
                      // Back button
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      // Centered title with userName
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Chat With $userName',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // Right-aligned avatar with circular Container and SVG
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColor.darkBlue,
                            shape: BoxShape.circle,
                          ),
                          width:
                              30, // Matches original CircleAvatar diameter (radius: 12 * 2)
                          height: 30,
                          child: Center(
                            child: SvgPicture.asset(
                              Assets.svgsCall, // e.g., 'assets/icons/call.svg'
                              color:
                                  Colors
                                      .white, // Tint SVG to white for visibility
                              width:
                                  16, // Slightly smaller to fit inside Container
                              height: 16,
                              fit: BoxFit.contain,
                            ),
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

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
