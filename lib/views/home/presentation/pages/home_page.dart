part of 'pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, String>> services = [
    {'title': 'Electricians', 'image': Assets.imagesElectricity},
    {'title': 'Plumbers', 'image': Assets.imagesPlumber},
    {'title': 'Gas Engineers', 'image': Assets.imagesGas},
    {'title': 'Heating Engineers', 'image': Assets.imagesHeatingEng},
    {'title': 'Builders', 'image': Assets.imagesBuilder},
    {'title': 'Carpenters & Joiners', 'image': Assets.imagesSawing},
    {'title': 'Plasterers', 'image': Assets.imagesPlaster},
    {'title': 'Roofers', 'image': Assets.imagesRoofers},
    {'title': 'Tilers', 'image': Assets.imagesTilers},
    {'title': 'Painters & Decorators', 'image': Assets.imagesPainter},
    {'title': 'Bricklayers', 'image': Assets.imagesBricker},
    {'title': 'Flooring', 'image': Assets.imagesFlooring},
    {'title': 'Tilers', 'image': Assets.imagesTilers},
    {'title': 'Painters & Decorators', 'image': Assets.imagesPainter},
    {'title': 'Bricklayers', 'image': Assets.imagesBricker},
  ];

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: const HomeAppBar(),
      body: Stack(
        children: [
          SizedBox(
            height: context.screenHeight,
            width: context.screenWidth,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 15,
                  children: [
                    CustomText(
                      text: 'Select Category',
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                    GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap:
                          true, // Make GridView take only the space it needs

                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 1,
                          ),
                      itemCount: services.length,
                      itemBuilder: (context, index) {
                        // Debug
                        return HomeTiles(
                          imagePath: services[index]['image']!,
                          title: services[index]['title']!,
                          onTap: () {
                            // Handle tile tap
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter, // Align button at bottom center
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16.0,
              ),
              child: CustomButton(
                text: 'Next',
                onTap: () {
                  Get.toNamed(AppRoutes.jobPage);
                },
                width: double.infinity,
                color: AppColor.darkBlue,
                textColor: AppColor.white,
                fontWeight: FontWeight.normal,
                radius: 25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
