part of 'widgets.dart';

class MessageBubble extends StatelessWidget {
  final String text;
  final bool isMe;
  final String time;
  final String? avatar;

  const MessageBubble({
    super.key,
    required this.text,
    required this.isMe,
    required this.time,
    this.avatar,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe && avatar != null)
            CircleAvatar(radius: 16, backgroundImage: AssetImage(avatar!)),
          if (!isMe) const SizedBox(width: 8),
          Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isMe ? AppColor.grey : AppColor.white,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20),
                    topRight: const Radius.circular(20),
                    bottomLeft:
                        isMe
                            ? const Radius.circular(20)
                            : const Radius.circular(4),
                    bottomRight:
                        isMe
                            ? const Radius.circular(4)
                            : const Radius.circular(20),
                  ),
                ),
                child: Text(
                  text,
                  style: TextStyle(
                    color: isMe ? AppColor.white : AppColor.black,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                time,
                style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
