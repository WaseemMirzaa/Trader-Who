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
  ];

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: const HomeAppBar(),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 8.0, bottom: 16.0),
                  child: CustomText(
                    text: 'Select Category',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.9,
                        ),
                    itemCount: services.length,
                    itemBuilder: (context, index) {
                      return HomeTiles(
                        imagePath: services[index]['image']!,
                        title: services[index]['title']!,
                        onTap: () {
                          // Handle tile tap
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          // Floating "Next" button positioned at the bottom
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
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
        ],
      ),
    );
  }
}
