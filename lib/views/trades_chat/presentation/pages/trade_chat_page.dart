part of 'pages.dart';

class TradeChatPage extends StatefulWidget {
  const TradeChatPage({super.key});

  @override
  State<TradeChatPage> createState() => _TradeChatPageState();
}

class _TradeChatPageState extends State<TradeChatPage> {
  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: TradeChatAppBar(),
      body: const Center(child: Text('Welcome to Tradesperson Chat Page!')),
      bottomNavigationBar: const CustomNavBar(), // Add the CustomNavBar here
    );
  }
}
