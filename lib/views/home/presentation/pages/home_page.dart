part of 'pages.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  int _counter = 0;

  static const List<String> _titles = [
    'Home',
    'Details',
    'Chat',
    'Profile',
  ];

  final List<Widget> _pages = [
    const Center(child: Text('Home Content', style: TextStyle(fontSize: 24))),
   
  ];

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _titles[_selectedIndex],
          style: const TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications, color: Colors.black),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundColor: Colors.grey,
              child: Text('TT', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
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