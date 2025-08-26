part of 'pages.dart';

class ChatDetailPage extends StatefulWidget {
  final String userName;
  final String avatarImage;
  final String receiverId;

  const ChatDetailPage({
    super.key,
    required this.userName,
    required this.avatarImage,
    required this.receiverId,
  });

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  String _formatTimestamp(dynamic sentAt) {
    if (sentAt is DateTime) {
      return "${sentAt.hour.toString().padLeft(2, '0')}:${sentAt.minute.toString().padLeft(2, '0')}";
    } else if (sentAt is Timestamp) {
      final dt = sentAt.toDate();
      return "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
    } else if (sentAt is int) {
      final dt = DateTime.fromMillisecondsSinceEpoch(sentAt);
      return "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
    }
    return "";
  }

  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ChatController chatController = Get.put(ChatController());
  late String chatId;

  @override
  void initState() {
    super.initState();
    chatId = chatController.getChatId(
      FirebaseAuth.instance.currentUser!.uid,
      widget.receiverId,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final currentUserId = FirebaseAuth.instance.currentUser!.uid;
      await chatController.createChatIfNotExists(
        currentUserId,
        widget.receiverId,
      );
      chatController.listenToMessages(chatId, reset: true);
      await chatController.markMessagesAsRead(chatId, currentUserId);
      _scrollToBottom();
    });
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    chatController.messageSubscription?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels <=
        _scrollController.position.minScrollExtent + 100) {
      // Near the top, fetch more messages
      chatController.fetchMoreMessages(chatId);
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return TraderWhoScaffold(
      appBar: ChatPageDetailAppBar(
        userName: widget.userName,
        avatarImage: widget.avatarImage,
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              final messages = chatController.messages;
              return ListView.builder(
                controller: _scrollController,
                reverse: true,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  final isMe =
                      message.senderId ==
                      FirebaseAuth.instance.currentUser!.uid;
                  return MessageBubble(
                    text: message.message,
                    isMe: isMe,
                    time: _formatTimestamp(message.sentAt),
                    avatar: isMe ? null : widget.avatarImage,
                  );
                },
              );
            }),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColor.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColor.lightCyan,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          hintStyle: TextStyle(
                            color: AppColor.secondaryText,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'openSans',
                          ),
                          hintText: 'Write message',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: AppColor.darkBlue,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: () async {
                      if (_messageController.text.isNotEmpty) {
                        await chatController.sendMessage(
                          chatId: chatId,
                          senderId: FirebaseAuth.instance.currentUser!.uid,
                          receiverId: widget.userName,
                          message: _messageController.text,
                        );
                        _scrollToBottom();
                        _messageController.clear();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
