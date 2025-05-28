part of 'widgets.dart';

class JobHistoryDetailAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final JobHistory job;
  final VoidCallback? onBackPressed;

  const JobHistoryDetailAppBar({
    super.key,
    required this.job,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColor.appbarBackground,
      automaticallyImplyLeading: false,
      elevation: 0,
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
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                          ),
                          onPressed:
                              onBackPressed ?? () => Navigator.pop(context),
                        ),
                      ),
                      // Centered title
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          job.status == 'Accepted'
                              ? 'Accepted by ${job.tradesPerson.name}'
                              : job.status == 'Waiting for porposal'
                              ? 'Details'
                              : job.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
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
  Size get preferredSize => const Size.fromHeight(70);
}
