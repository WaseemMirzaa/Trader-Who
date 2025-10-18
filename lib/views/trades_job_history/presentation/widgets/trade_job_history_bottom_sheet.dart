part of 'widgets.dart';

class TradeJobHistoryBottomSheet extends StatefulWidget {
  final String title;
  final String description;
  final VoidCallback? onSubmit;
  final TextEditingController priceController;
  final TextEditingController reasonController;

  const TradeJobHistoryBottomSheet({
    super.key,
    required this.title,
    required this.description,
    this.onSubmit,
    required this.priceController,
    required this.reasonController,
  });

  @override
  State<TradeJobHistoryBottomSheet> createState() =>
      _TradeJobHistoryBottomSheetState();
}

class _TradeJobHistoryBottomSheetState
    extends State<TradeJobHistoryBottomSheet> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: keyboardHeight),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: screenHeight * 0.9,
          minHeight: screenHeight * 0.3,
        ),
        decoration: const BoxDecoration(
          color: AppColor.customLightGray,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Content area with light gray background
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: AppColor.black,
                    ),
                  ),
                  kGap10,
                  CustomText(
                    text:
                        'Please provide a reassessed price and an explanation. This will be sent to the customer for approval.',
                    maxLines: 2,
                    fontSize: 13,
                    color: AppColor.darkGrayText,
                  ),
                  kGap10,
                  // Reassessed Price label
                  CustomText(
                    text: 'Reassessed Price:',
                    fontWeight: FontWeight.w500,
                    color: AppColor.black,
                  ),
                  const SizedBox(height: 8),

                  // Price TextField
                  CustomTextField(
                    borderColor: AppColor.white,
                    controller: widget.priceController,
                    hintText: 'Enter price',
                    hintStyle: TextStyle(color: AppColor.customsLightGray),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 14),

                  // Reason label
                  const Text(
                    'Reason/Explanation:',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppColor.black,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Reason TextField
                  CustomTextField(
                    borderColor: AppColor.white,
                    controller: widget.reasonController,
                    hintText: 'Briefly explain',
                    hintStyle: const TextStyle(color: AppColor.midGray),
                    keyboardType: TextInputType.multiline,
                    maxLines: 5,
                    height: screenHeight * 0.13, // Increased height
                    contentPadding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.02,
                      horizontal: screenWidth * 0.04,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),

            // White button container with rounded top corners
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: CustomButton(
                text: _isLoading ? 'Submitting...' : 'Submit',
                onTap:
                    _isLoading
                        ? null
                        : () {
                          setState(() => _isLoading = true);
                          widget.onSubmit?.call();
                        },
                height: 45,
                color: _isLoading ? Colors.grey : AppColor.darkBlue,
                textColor: AppColor.white,
                fontWeight: FontWeight.bold,
                radius: 25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TradeJobQuoteBottomSheet extends StatefulWidget {
  final String title;
  final String description;
  final VoidCallback? onSubmit;
  final TextEditingController priceController;
  final TextEditingController detailsController;

  const TradeJobQuoteBottomSheet({
    super.key,
    required this.title,
    required this.description,
    this.onSubmit,
    required this.priceController,
    required this.detailsController,
  });

  @override
  State<TradeJobQuoteBottomSheet> createState() =>
      _TradeJobQuoteBottomSheetState();
}

class _TradeJobQuoteBottomSheetState extends State<TradeJobQuoteBottomSheet> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: keyboardHeight),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: screenHeight * 0.9,
          minHeight: screenHeight * 0.3,
        ),
        decoration: const BoxDecoration(
          color: AppColor.customLightGray,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Content area with light gray background
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: AppColor.black,
                    ),
                  ),
                  kGap10,
                  CustomText(
                    text:
                        'Please provide a Quote price and details. This will be sent to the customer for approval.',
                    maxLines: 2,
                    fontSize: 13,
                    color: AppColor.darkGrayText,
                  ),
                  kGap10,
                  // Quoted Price label
                  CustomText(
                    text: 'Quoted Price:',
                    fontWeight: FontWeight.w500,
                    color: AppColor.black,
                  ),
                  const SizedBox(height: 8),

                  // Price TextField
                  CustomTextField(
                    borderColor: AppColor.white,
                    controller: widget.priceController,
                    hintText: 'Enter price',
                    hintStyle: TextStyle(color: AppColor.customsLightGray),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 14),

                  // Reason label
                  const Text(
                    'Details:',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppColor.black,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Reason TextField
                  CustomTextField(
                    borderColor: AppColor.white,
                    controller: widget.detailsController,
                    hintText: 'Briefly explain',
                    hintStyle: const TextStyle(color: AppColor.midGray),
                    keyboardType: TextInputType.multiline,
                    maxLines: 5,
                    height: screenHeight * 0.13, // Increased height
                    contentPadding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.02,
                      horizontal: screenWidth * 0.04,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),

            // White button container with rounded top corners
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: CustomButton(
                text: _isLoading ? 'Submitting...' : 'Submit',
                onTap:
                    _isLoading
                        ? null
                        : () {
                          setState(() => _isLoading = true);
                          widget.onSubmit?.call();
                        },
                height: 45,
                color: _isLoading ? Colors.grey : AppColor.darkBlue,
                textColor: AppColor.white,
                fontWeight: FontWeight.bold,
                radius: 25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
