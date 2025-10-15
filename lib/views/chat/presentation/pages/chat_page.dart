part of 'pages.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _searchController = TextEditingController();
  final ChatController chatController = Get.put(ChatController());
  final ScrollController _scrollController = ScrollController();
  late String userId;

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser!.uid;
    chatController.listenToChats(userId, reset: true);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    chatController.chatSubscription?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      // Near the bottom, fetch more chats
      chatController.fetchMoreChats(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TraderWhoScaffold(
      appBar: const ChatAppbar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SearchBarTile(
              controller: _searchController,
              onSearch: () {},
              hintText: 'Search by Name',
            ),
          ),
          Expanded(
            child: Obx(() {
              final chats = chatController.chats;
              if (chats.isEmpty) {
                return const Center(child: Text('No chats found'));
              }
              return ListView.builder(
                controller: _scrollController,
                itemCount: chats.length,
                itemBuilder: (context, index) {
                  final chat = chats[index];
                  final otherUserId =
                      chat.receiverId == userId
                          ? chat.senderId
                          : chat.receiverId;
                  return FutureBuilder(
                    future: chatController.fetchUserById(otherUserId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const ListTile(title: Text('Loading...'));
                      }
                      if (!snapshot.hasData || snapshot.data == null) {
                        return const ListTile(title: Text('User not found'));
                      }
                      final user = snapshot.data!;
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => ChatDetailPage(
                                    userName: user.name,
                                    avatarImage: user.image ?? '',
                                    receiverId: otherUserId,
                                    chatModel: chat,
                                  ),
                            ),
                          );
                        },
                        child: ChatCard(
                          name: user.name,
                          distance: user.address ?? '',
                          isOnline:
                              false, // You may want to fetch online status from user profile
                          avatarImage: user.image ?? '',
                        ),
                      );
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
