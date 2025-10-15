part of 'pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final NewServiceController controller = Get.put(NewServiceController());

  @override
  Widget build(BuildContext context) {
    return TraderWhoScaffold(
      appBar: const HomeAppBar(),
      body: Stack(
        children: [
          Obx(
            () =>
                controller.isLoading.value
                    ? Center(
                      child: CircularProgressIndicator(
                        color: AppColor.orangeCustomColor,
                      ),
                    )
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
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 12,
                                      mainAxisSpacing: 12,
                                      childAspectRatio: 1,
                                    ),
                                itemCount: controller.categories.length,
                                itemBuilder: (context, index) {
                                  final category = controller.categories[index];

                                  return HomeTiles(
                                    iconUrl: category.iconUrl,
                                    fallbackImage: Assets.imagesBuilder,
                                    title: category.name,
                                    onTap: () {
                                      controller.selectCategory(category.id);
                                      Get.toNamed(
                                        AppRoutes.jobPage,
                                        arguments: {
                                          'categoryId': category.id,
                                          'categoryName': category.name,
                                        },
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
