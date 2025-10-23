part of 'widgets.dart';

class ChatCard extends StatefulWidget {
  final String name;
  final String distance;
  final bool isOnline;
  final String avatarImage;
  final bool isOrderChat;
  final String? orderId;
  final String? orderCategory;
  final String? orderService;

  const ChatCard({
    super.key,
    required this.name,
    required this.distance,
    required this.isOnline,
    required this.avatarImage,
    this.isOrderChat = false,
    this.orderId,
    this.orderCategory,
    this.orderService,
  });

  @override
  State<ChatCard> createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  String? _fetchedCategory;
  String? _fetchedService;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Fetch from booking if not provided
    if (widget.isOrderChat &&
        widget.orderId != null &&
        (widget.orderCategory == null || widget.orderService == null)) {
      _fetchBookingDetails();
    }
  }

  Future<void> _fetchBookingDetails() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final bookingDoc =
          await FirebaseFirestore.instance
              .collection('bookings')
              .doc(widget.orderId)
              .get();

      if (bookingDoc.exists) {
        final data = bookingDoc.data();
        if (data != null && mounted) {
          setState(() {
            _fetchedCategory = data['category'] as String?;
            _fetchedService = data['service'] as String?;
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      print('Error fetching booking details: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String? get _displayCategory => widget.orderCategory ?? _fetchedCategory;
  String? get _displayService => widget.orderService ?? _fetchedService;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundImage: AssetImage(widget.avatarImage),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.name,
                              style: const TextStyle(
                                fontFamily: 'openSans',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColor.primaryText,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (widget.isOrderChat &&
                                _displayService != null) ...[
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  Icon(
                                    Icons.home_repair_service_outlined,
                                    size: 14,
                                    color: AppColor.primaryButton,
                                  ),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      _displayService!,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppColor.primaryButton,
                                        fontFamily: 'openSans',
                                        fontWeight: FontWeight.w500,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ] else if (widget.isOrderChat && _isLoading) ...[
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 12,
                                    height: 12,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColor.primaryButton,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Loading...',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColor.secondaryText,
                                      fontFamily: 'openSans',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (widget.isOnline)
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColor.white, width: 2),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.isOrderChat
                        ? (_displayCategory ?? 'Booking chat')
                        : '${widget.distance} away from your location',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColor.secondaryText,
                      fontFamily: 'openSans',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
