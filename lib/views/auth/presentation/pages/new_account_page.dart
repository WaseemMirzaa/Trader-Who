part of 'pages.dart';

class NewAccountPage extends StatefulWidget {
  const NewAccountPage({super.key});

  @override
  State<NewAccountPage> createState() => _NewAccountState();
}

class _NewAccountState extends State<NewAccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.lightPeach,
      appBar: AppBar(
        centerTitle: true,
        title: const CustomText(
          text: 'Create New Account',
          color: AppColor.black,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                       Get.toNamed(AppRoutes.signup);
                      },
              child: Container(
                width: 175,
                height: 150,
                decoration: BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.circular(20.0), 
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, 
                  children: [
                   Image.asset(
                      Assets.imagesCustomer,
                      height: 50, 
                      width: 50,
                    ), 
                    const SizedBox(height: 8.0),
                    const CustomText(
                      text: 'Customer',
                      color: AppColor.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Container(
              width: 175,
              height: 150,
              decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.circular(20.0), 
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                 Image.asset(
        Assets.imagesPeople, 
        height: 50, 
        width: 50,
      ), 
                  const SizedBox(height: 8.0),
                  const CustomText(
                    text: 'TradesPerson',
                    color: AppColor.black,
                    fontWeight: FontWeight.bold,
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