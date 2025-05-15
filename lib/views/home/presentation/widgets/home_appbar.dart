part of 'widgets.dart';


class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      flexibleSpace: Center(
        child: Container(
          width: 735,
          height: 185,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            children: [
              
              const Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text(
                    'Home',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
           
              Positioned(
                bottom: 16,
                left: 16,
                child: Row(
                  children: [
                   
                    const CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.blue,
                      child: Icon(
                        Icons.person,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                   
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'Hi, Alex',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      toolbarHeight: 200, 
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(200);
}