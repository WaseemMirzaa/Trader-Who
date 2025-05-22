part of 'pages.dart';

class MyAccountPage extends StatelessWidget {
  const MyAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: const MyAccountAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Avatar
            Center(
              child: CustomCircleAvatar(
                radius: 50,
                hasBorder: false,
                child: Image(
                  image: AssetImage(Assets.imagesCircularAvatar),
                  width: context.width,
                  height: context.height,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // First Name Field
            CustomTextField(
              leftLabel: 'First Name',
              initialValue: 'Alex',
              textColor: AppColor.black,
              fillColor: Colors.white,
              borderColor: AppColor.lightGray,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            const SizedBox(height: 16),

            // Last Name Field
            CustomTextField(
              leftLabel: 'Last Name',
              initialValue: 'Middleton',
              fillColor: Colors.white,
              borderColor: AppColor.lightGray,
              textColor: AppColor.black,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            const SizedBox(height: 16),

            // Email Field
            CustomTextField(
              leftLabel: 'Email',
              initialValue: 'alexjerome@info.com',
              textColor: AppColor.black,
              fillColor: Colors.white,
              borderColor: AppColor.lightGray,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),

            // Phone Field
            CustomTextField(
              leftLabel: 'Phone',
              initialValue: '+9876543210',
              textColor: AppColor.black,
              fillColor: Colors.white,
              borderColor: AppColor.lightGray,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),

            // Address Field
            CustomTextField(
              leftLabel: 'Address',
              initialValue: '123 Maple',
              textColor: AppColor.black,
              fillColor: Colors.white,
              borderColor: AppColor.lightGray,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              maxLines: 2,
            ),

            kGap40,

            // Save Button
            CustomButton(
              text: 'Update Profile',
              onTap: () {},
              color: AppColor.darkBlue,
              textColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
