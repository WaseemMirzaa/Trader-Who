part of 'pages.dart';

class ChatPage extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, dynamic>> chatData = [
    {
      'name': 'Michael James',
      'distance': '650m',

      'time': '10:30 AM',
      'isOnline': true,
      'avatarImage': Assets.imagesChatAvatar,
    },
    {
      'name': 'John Robert',
      'distance': '1.2km',

      'time': 'Yesterday',
      'isOnline': true,
      'avatarImage': Assets.imagesChatRebort,
    },
    {
      'name': 'William David',
      'distance': '3.5km',

      'time': 'Yesterday',
      'isOnline': true,
      'avatarImage': Assets.imagesChatWilliam,
    },
    {
      'name': 'Joseph Richard',
      'distance': '500m',

      'time': '2 days ago',
      'isOnline': true,
      'avatarImage': Assets.imagesChatRichard,
    },
    {
      'name': 'Christopher Thomas',
      'distance': '500m',

      'time': '2 days ago',
      'isOnline': true,
      'avatarImage': Assets.imagesChatThomas,
    },
    {
      'name': 'Daniel Charles',
      'distance': '2.1km',

      'time': '3 days ago',
      'isOnline': true,
      'avatarImage': Assets.imagesChatCharles,
    },
  ];

  ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: const ChatAppbar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SearchBarTile(
                controller: _searchController,
                onSearch: () {},
                hintText: 'Search by Name',
              ),
            ),

            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: chatData.length,
              itemBuilder: (context, index) {
                final chat = chatData[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => ChatDetailPage(
                              userName: chat['name'],
                              avatarImage: chat['avatarImage'],
                            ),
                      ),
                    );
                  },
                  child: ChatCard(
                    name: chat['name'],
                    distance: chat['distance'],

                    isOnline: chat['isOnline'],
                    avatarImage: chat['avatarImage'],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
