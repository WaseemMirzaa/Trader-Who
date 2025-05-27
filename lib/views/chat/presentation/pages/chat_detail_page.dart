part of 'pages.dart';

class ChatDetailPage extends StatefulWidget {
  final String userName;
  final String avatarImage;

  const ChatDetailPage({
    super.key,
    required this.userName,
    required this.avatarImage,
  });

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final TextEditingController _messageController = TextEditingController();
  // Reordered messages list to match the requested order
  final List<Map<String, dynamic>> messages = [
    {'text': 'Can I book for 3pm?', 'isMe': false, 'time': '10:30 AM'},
    {
      'text': 'Sure! 3PM works.I will confirm,',
      'isMe': true,
      'time': '10:32 AM',
    },
    // Optionally include other messages
    {'text': 'Great Thanks!', 'isMe': false, 'time': '10:35 AM'},
    {
      'text': 'You are Welcome! See you at 3',
      'isMe': true,
      'time': '10:36 AM', // Adjusted time to maintain chronological sense
    },
  ];

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Scroll to the bottom after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
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
    return GradientScaffold(
      appBar: ChatPageDetailAppBar(
        userName: widget.userName,
        avatarImage: widget.avatarImage,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              reverse: true, // Keep reverse: true for chat-like experience
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                // Since reverse is true, reverse the index to access messages
                final message = messages[messages.length - 1 - index];
                return MessageBubble(
                  text: message['text'],
                  isMe: message['isMe'],
                  time: message['time'],
                  avatar: message['isMe'] ? null : widget.avatarImage,
                );
              },
            ),
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
                            color: AppColor.grey,
                            fontWeight: FontWeight.w500,
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
                    onPressed: () {
                      // if (_messageController.text.isNotEmpty) {
                      //   setState(() {
                      //     messages.add({
                      //       'text': _messageController.text,
                      //       'isMe': true,
                      //       'time': FormatCurrentTime(), // Use formatted time
                      //     });
                      //     _messageController.clear();
                      //   });
                      //   _scrollToBottom();
                      // }
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
