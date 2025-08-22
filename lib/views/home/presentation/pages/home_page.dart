part of 'pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, String>> services = [
    {
      'title': 'Electrician',
      'image': Assets.imagesElectricity,
      'category': 'Electrician',
    },
    {'title': 'Plumber', 'image': Assets.imagesPlumber, 'category': 'Plumber'},
    {
      'title': 'Heating Engineer / Gas Engineer',
      'image': Assets.imagesHeatingEng,
      'category': 'Heating Engineer / Gas Engineer',
    },
    {
      'title': 'Carpenter / Joiner',
      'image': Assets.imagesSawing,
      'category': 'Carpenter / Joiner',
    },
    {
      'title': 'Painter & Decorator',
      'image': Assets.imagesPainter,
      'category': 'Painter & Decorator',
    },
    {'title': 'Tiler', 'image': Assets.imagesTilers, 'category': 'Tiler'},
    {
      'title': 'Plasterer',
      'image': Assets.imagesPlaster,
      'category': 'Plasterer',
    },
    {'title': 'Roofer', 'image': Assets.imagesRoofers, 'category': 'Roofer'},
    {
      'title': 'Flooring Specialist',
      'image': Assets.imagesFlooring,
      'category': 'Flooring Specialist',
    },
    {
      'title': 'Bricklayer / Builder',
      'image': Assets.imagesBricker,
      'category': 'Bricklayer / Builder',
    },
    {
      'title': 'Locksmith',
      'image': Assets.imagesBuilder,
      'category': 'Locksmith',
    },
    {
      'title': 'Window Fitter / Glazier',
      'image': Assets.imagesHome,
      'category': 'Window Fitter / Glazier',
    },
    {
      'title': 'Drainage Specialist',
      'image': Assets.imagesPipe,
      'category': 'Drainage Specialist',
    },
    {
      'title': 'Gutter Cleaner / Installer',
      'image': Assets.imagesBuilder,
      'category': 'Gutter Cleaner / Installer',
    },
    {
      'title': 'Fence Installer',
      'image': Assets.imagesBuilder,
      'category': 'Fence Installer',
    },
    {
      'title': 'Driveway / Paving Installer',
      'image': Assets.imagesBuilder,
      'category': 'Driveway / Paving Installer',
    },
    {
      'title': 'Scaffolder',
      'image': Assets.imagesBuilder,
      'category': 'Scaffolder',
    },
    {
      'title': 'Gardener / Landscaper',
      'image': Assets.imagesBuilder,
      'category': 'Gardener / Landscaper',
    },
    {
      'title': 'Tree Surgeon / Arborist',
      'image': Assets.imagesBuilder,
      'category': 'Tree Surgeon / Arborist',
    },
    {
      'title': 'Decking Installer',
      'image': Assets.imagesBuilder,
      'category': 'Decking Installer',
    },
    {
      'title': 'Pest Control',
      'image': Assets.imagesBuilder,
      'category': 'Pest Control',
    },
    {
      'title': 'Fire Alarm / Security System Installer',
      'image': Assets.imagesElectricity,
      'category': 'Fire Alarm / Security System Installer',
    },
    {
      'title': 'CCTV Installer',
      'image': Assets.imagesElectricity,
      'category': 'CCTV Installer',
    },
  ];
  String getImagePathByCategory(String category) {
    return services.firstWhere(
      (service) => service['category'] == category,
    )['image']!;
  }

  ServiceController controller = Get.put(ServiceController());
  @override
  Widget build(BuildContext context) {
    return TraderWhoScaffold(
      appBar: const HomeAppBar(),
      body: Stack(
        children: [
          Obx(
            () =>
                controller.isLoading.value
                    ? CircularProgressIndicator()
                    : SizedBox(
                      height: context.screenHeight,
                      width: context.screenWidth,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 15,
                            children: [
                              CustomText(
                                text: 'Select Category',
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
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
                                itemCount: controller.smallCategories.length,
                                itemBuilder: (context, index) {
                                  String categoryKey = controller
                                      .smallCategories
                                      .keys
                                      .elementAt(index);

                                  // Debug
                                  return HomeTiles(
                                    imagePath: getImagePathByCategory(
                                      categoryKey,
                                    ),
                                    title: categoryKey,
                                    onTap: () {
                                      controller.selectService(categoryKey);
                                      Get.toNamed(
                                        AppRoutes.jobPage,
                                        arguments: categoryKey,
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
          ),
        ],
      ),
    );
  }
}
