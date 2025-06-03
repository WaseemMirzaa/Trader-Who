part of 'pages.dart';

class TradeMyaccountPage extends StatelessWidget {
  const TradeMyaccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: const MyAccountAppBar(),
      body: Padding(
        padding: kHV20,
        child: Column(
          spacing: 10,
          children: [
            // Profile Avatar
            Center(
              child: CustomCircleAvatar(
                radius: 50,
                hasBorder: false,
                child: Image(
                  image: AssetImage(Assets.imagesTradeProfile),
                  width: context.width,
                  height: context.height,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // First Name Field
            TextFieldCustom(
              prefixLabel: 'First Name',
              initialValue: 'Kate',
              textColor: AppColor.black,
              fillColor: Colors.white,
              borderColor: AppColor.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),

            // Last Name Field
            TextFieldCustom(
              prefixLabel: 'Last Name',
              initialValue: 'Middleton',
              fillColor: Colors.white,
              borderColor: AppColor.white,
              textColor: AppColor.black,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),

            // Email Field
            TextFieldCustom(
              prefixLabel: 'Email',
              initialValue: 'alexjerome@info.com',
              textColor: AppColor.black,
              fillColor: Colors.white,
              borderColor: AppColor.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              keyboardType: TextInputType.emailAddress,
            ),

            // Phone Field
            TextFieldCustom(
              prefixLabel: 'Phone',
              initialValue: '+9876543210',
              textColor: AppColor.black,
              fillColor: Colors.white,
              borderColor: AppColor.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              keyboardType: TextInputType.phone,
            ),

            // Address Field
            TextFieldCustom(
              prefixLabel: 'Address',
              initialValue: '123 Maple Sreet, Unit 4B, SpringField',
              textColor: AppColor.black,
              fillColor: Colors.white,
              borderColor: AppColor.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              maxLines: 1,
            ),
            Spacer(),
            CustomButton(
              height: 55,
              text: 'Update Profile',
              onTap: () {},
              color: AppColor.darkBlue,
              textColor: Colors.white,
            ),
            SizedBox(height: 20),
            // Save Button
          ],
        ),
      ),
    );
  }
}
