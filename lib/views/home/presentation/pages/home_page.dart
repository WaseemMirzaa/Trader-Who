part of 'pages.dart';



class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static const List<String> _titles = [
    'Home',
    'Details',
    'Chat',
    'Profile',
  ];

  // Define all pages for each navigation item
  final List<Widget> _pages = [
    const Center(child: Text('Home Content', style: TextStyle(fontSize: 24))),
    const Center(child: Text('Details Content', style: TextStyle(fontSize: 24))),
    const Center(child: Text('Chat Content', style: TextStyle(fontSize: 24))),
    const Center(child: Text('Profile Content', style: TextStyle(fontSize: 24))),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
      

    return Scaffold(
      backgroundColor: AppColor.lightPeach,
      appBar:HomeAppBar() , 
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}