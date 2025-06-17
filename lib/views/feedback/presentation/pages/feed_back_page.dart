part of 'pages.dart';

class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({super.key});

  Widget _buildTipButton(String amount, double width) {
    return SizedBox(
      width: width,
      height: 48, // Fixed height for consistency
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.white, // White background
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.white,
          ), // Optional: keep light border
        ),
        child: TextButton(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            // Handle tip selection
            // You could add state management here to track selected tip
          },
          child: Text(
            amount,
            style: TextStyle(fontSize: 14, color: AppColor.darkerGray),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return TraderWhoScaffold(
      appBar: const FeedBackAppbar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: context.responsivePadding(horizontal: 5, vertical: 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, // Center content
            children: [
              SizedBox(height: context.responsiveHeight(29)),
              // Share Your Experience text
              Text(
                'Share Your Experience',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColor.black,
                  fontSize: context.responsiveFontSize(22),
                  fontWeight: FontWeight.w500,
                ),
              ),
              kGap10,

              // How would you rate text
              Text(
                'How would you rate your experience today?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: context.responsiveFontSize(14),
                  fontWeight: FontWeight.w500,
                  color: AppColor.customsLightGray,
                ),
              ),
              SizedBox(height: context.responsiveHeight(2)),

              // Five stars rating
              RatingBar.builder(
                initialRating: 5,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 21,
                ignoreGestures: true, // Makes it read-only
                itemBuilder:
                    (context, _) =>
                        Icon(Icons.star, color: AppColor.vibrantYellow),
                onRatingUpdate: (rating) {},
              ),
              SizedBox(height: context.responsiveHeight(2)),

              // Comments text field
              CustomTextField(
                fillColor: AppColor.white,
                borderColor: AppColor.white,
                // controller: _descriptionController,
                hintText:
                    ' Please share any comments or suggestions to help us improve your next visit.',
                fontStyle: FontStyle.normal,
                hintStyle: const TextStyle(
                  color: AppColor.midGray,
                  fontSize: 13,
                ),
                keyboardType: TextInputType.multiline,
                maxLines: 5,
                height: screenHeight * 0.13, // Increased height
                contentPadding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.02,
                  horizontal: screenWidth * 0.04,
                ),
              ),

              // Optional tip section (aligned to the left)
              Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Left-align this section
                children: [
                  SizedBox(height: context.responsiveHeight(4)),
                  Text(
                    'Optional tip',
                    textAlign: TextAlign.start, // Align text to the left
                    style: TextStyle(
                      fontSize: context.responsiveFontSize(16),
                      fontWeight: FontWeight.w500,
                      color: AppColor.black,
                    ),
                  ),
                  SizedBox(height: context.responsiveHeight(2)),

                  // Tip amounts row - responsive layout
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final buttonWidth =
                          (constraints.maxWidth - 32) / 5; // Adjust for spacing
                      return Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        alignment:
                            WrapAlignment.start, // Align buttons to the left
                        children: [
                          _buildTipButton('£5', buttonWidth),
                          _buildTipButton('£10', buttonWidth),
                          _buildTipButton('£15', buttonWidth),
                          _buildTipButton('£20', buttonWidth),
                          _buildTipButton('Others', buttonWidth),
                        ],
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: context.responsiveHeight(6)),

              // Submit button
              CustomButton(
                text: 'Submit Review & Tip',
                textColor: AppColor.white,
                color: AppColor.darkBlue,
              ),
              SizedBox(height: context.responsiveHeight(2)),
            ],
          ),
        ),
      ),
    );
  }
}
