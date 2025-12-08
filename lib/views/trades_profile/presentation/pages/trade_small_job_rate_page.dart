part of 'pages.dart';

class TradeRatePage extends StatelessWidget {
  const TradeRatePage({super.key});

  @override
  Widget build(BuildContext context) {
    final NewServiceController controller = Get.put(NewServiceController());
    return TraderWhoScaffold(
      appBar: TradeRatesAppbar(title: "Set Fixed Prices for Small Jobs"),
      body: SafeArea(
        child: Obx(
          () =>
              controller.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CustomText(
                              text: 'SET YOUR QUICK JOB RATES',
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: AppColor.primaryText,
                            ),
                            const SizedBox(width: 8),
                            InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder:
                                      (context) => AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        title: const Text(
                                          'Quick Job Rates',
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: AppColor.primaryText,
                                          ),
                                        ),
                                        content: const Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Add set prices for quick jobs you\'re comfortable charging upfront. These jobs can be booked instantly by customers — you\'ll still quote for anything bigger or custom.',
                                              style: TextStyle(
                                                fontSize: 15,
                                                height: 1.5,
                                                color: AppColor.secondaryText,
                                              ),
                                            ),
                                            SizedBox(height: 16),
                                            Text(
                                              'Don\'t want to set prices? You can skip this step and quote for all jobs as they come in.',
                                              style: TextStyle(
                                                fontSize: 15,
                                                height: 1.5,
                                                color: AppColor.secondaryText,
                                              ),
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed:
                                                () =>
                                                    Navigator.of(context).pop(),
                                            child: const Text(
                                              'Got it',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color:
                                                    AppColor.orangeCustomColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                );
                              },
                              child: const Icon(
                                Icons.info_outline,
                                color: AppColor.orangeCustomColor,
                                size: 24,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        CustomText(
                          text:
                              'Save time by adding fixed prices for jobs you are comfortable with setting pre-made prices for. These jobs can be booked instantly by customers.',
                          fontSize: 13,
                          maxLines: 2,
                          color: AppColor.secondaryText,
                        ),
                        const SizedBox(height: 18),
                        if (controller.selectedCategory.isEmpty) ...[
                          const CustomText(
                            text: 'Select your trade category:',
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColor.primaryText,
                          ),
                          const SizedBox(height: 16),
                          ...controller.smallCategories.keys.map((categoryId) {
                            int enabledServices = controller
                                .getEnabledServicesCount(categoryId, 'small');
                            int totalServices = controller
                                .getTotalServicesCount(categoryId, 'small');
                            final category =
                                controller.categories
                                    .firstWhereOrNull((c) => c.id == categoryId)
                                    ?.name ??
                                categoryId;
                            return CategoryCard(
                              category: category,
                              icon: Icons.build, // Optionally map to icons
                              enabledServices: enabledServices,
                              totalServices: totalServices,
                              onTap: () {
                                print(
                                  '🔍 Tapping category: $category (ID: $categoryId)',
                                );
                                print(
                                  '🔍 smallCategories keys: ${controller.smallCategories.keys.toList()}',
                                );
                                print(
                                  '🔍 Selected category before: ${controller.selectedCategory.value}',
                                );
                                controller.selectCategory(categoryId);
                                print(
                                  '🔍 Selected category after: ${controller.selectedCategory.value}',
                                );
                                print(
                                  '🔍 smallCategories has key: ${controller.smallCategories.containsKey(categoryId)}',
                                );
                              },
                            );
                          }),
                          const SizedBox(height: 20),
                          if (!controller.fromProfile.value) ...[
                            const SizedBox(height: 20),
                            CustomButton(
                              onTap:
                                  () => Get.to(
                                    () => const TraderOnboardingPage(),
                                  ),
                              color: AppColor.primaryButton,
                              text: 'Continue',
                              textColor: AppColor.white,
                            ),
                          ],
                        ] else ...[
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  controller.selectCategory('');
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.arrow_back_ios,
                                    size: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFFFF6B35,
                                  ).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Builder(
                                  builder: (context) {
                                    final selectedCategoryName =
                                        controller.categories
                                            .firstWhereOrNull(
                                              (c) =>
                                                  c.id ==
                                                  controller
                                                      .selectedCategory
                                                      .value,
                                            )
                                            ?.name ??
                                        controller.selectedCategory.value;
                                    return Icon(
                                      controller.getCategoryIcon(
                                        selectedCategoryName,
                                      ),
                                      color: const Color(0xFFFF6B35),
                                      size: 20,
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Builder(
                                  builder: (context) {
                                    final selectedCategoryName =
                                        controller.categories
                                            .firstWhereOrNull(
                                              (c) =>
                                                  c.id ==
                                                  controller
                                                      .selectedCategory
                                                      .value,
                                            )
                                            ?.name ??
                                        controller.selectedCategory.value;
                                    return Text(
                                      selectedCategoryName,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1E3A8A),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Configure your services:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColor.secondaryText,
                              fontFamily: 'openSans',
                            ),
                          ),
                          const SizedBox(height: 16),
                          ...controller
                              .getJobsForCategory(
                                controller.selectedCategory.value,
                                'small',
                              )
                              .asMap()
                              .entries
                              .map((entry) {
                                int index = entry.key;
                                JobModel job = entry.value;
                                final price = controller.getJobPrice(job.id);
                                final isEnabled = controller.isJobEnabled(
                                  job.id,
                                );
                                return ServiceCardWidget(
                                  job: job,
                                  price: price,
                                  isEnabled: isEnabled,
                                  onEditPressed:
                                      () => _showPriceDialog(
                                        context,
                                        controller,
                                        job,
                                        index,
                                        controller.selectedCategory.value,
                                        null,
                                      ),
                                );
                              }),
                          // Custom Services logic removed
                          const SizedBox(height: 32),
                          CustomButton(
                            onTap: () {
                              controller.saveUserServices(
                                isFromLargeJob: false,
                              );
                            },
                            color: AppColor.primaryButton,
                            text: 'Save Configuration',
                            textColor: AppColor.white,
                          ),
                        ],
                      ],
                    ),
                  ),
        ),
      ),
    );
  }

  void _showPriceDialog(
    BuildContext context,
    NewServiceController controller,
    JobModel job,
    int index,
    String categoryId,
    TraderServiceModel? traderService,
  ) {
    final titleController = TextEditingController(text: job.title);
    final descController = TextEditingController(text: job.description ?? '');
    final priceController = TextEditingController(
      text: job.price?.toStringAsFixed(0) ?? '',
    );

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              job.isCustom ? 'Add Custom Service' : 'Set Fixed Price',
            ),
            content: SingleChildScrollView(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (job.isCustom) ...[
                      TextField(
                        style: TextStyle(color: AppColor.secondaryText),
                        controller: titleController,
                        cursorColor: AppColor.primaryText,
                        decoration: const InputDecoration(
                          labelText: 'Service Title',
                          labelStyle: TextStyle(color: AppColor.primaryText),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColor.primaryText),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColor.primaryText),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColor.primaryText),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColor.primaryText),
                          ),
                          contentPadding: EdgeInsets.all(12),
                        ),
                        autofocus: true,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        style: TextStyle(color: AppColor.secondaryText),
                        controller: descController,
                        cursorColor: AppColor.primaryText,
                        decoration: const InputDecoration(
                          labelText: 'Description (Optional)',
                          labelStyle: TextStyle(color: AppColor.primaryText),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColor.primaryText),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColor.primaryText),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColor.primaryText),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColor.primaryText),
                          ),
                          hintText: 'Brief description of what\'s included',
                          hintStyle: TextStyle(
                            color: AppColor.secondaryText,
                            fontFamily: 'openSans',
                          ),
                          contentPadding: EdgeInsets.all(12),
                        ),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 16),
                    ],
                    TextField(
                      style: TextStyle(color: AppColor.secondaryText),
                      controller: priceController,
                      cursorColor: AppColor.primaryText,
                      decoration: const InputDecoration(
                        labelText: 'Fixed Price (£)',
                        labelStyle: TextStyle(color: AppColor.primaryText),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColor.primaryText),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColor.primaryText),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColor.primaryText),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColor.primaryText),
                        ),
                        prefixText: '£ ',
                        contentPadding: EdgeInsets.all(12),
                      ),
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d{0,2}'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              if (job.isCustom)
                TextButton(
                  onPressed: () {
                    controller.removeCustomService(categoryId, index);
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryButton,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  final updatedService = job.copyWith(
                    title:
                        job.isCustom ? titleController.text.trim() : job.title,
                    description:
                        job.isCustom
                            ? (descController.text.trim().isEmpty
                                ? null
                                : descController.text.trim())
                            : job.description,
                    price: double.tryParse(priceController.text),
                    isEnabled:
                        double.tryParse(priceController.text) != null &&
                        double.tryParse(priceController.text)! > 0,
                  );
                  controller.updateService(categoryId, index, updatedService);
                  Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
            ],
          ),
    );
  }
}
