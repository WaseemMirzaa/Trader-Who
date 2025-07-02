part of 'pages.dart';

class TradeRatePage extends StatelessWidget {
  const TradeRatePage({super.key});

  @override
  Widget build(BuildContext context) {
    final TradeRateController controller = Get.put(TradeRateController());

    return TraderWhoScaffold(
      appBar: TradeRatesAppbar(),
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
                        CustomText(
                          text: 'Set Your Prices',
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: AppColor.primaryText,
                        ),
                        const SizedBox(height: 8),
                        CustomText(
                          text:
                              'Configure your small job services and set fixed prices for instant bookings.',
                          fontSize: 13,
                          maxLines: 2,
                          color: AppColor.secondaryText,
                        ),
                        const SizedBox(height: 18),
                        if (controller.selectedCategory.value.isEmpty) ...[
                          const CustomText(
                            text: 'Select your trade category:',
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColor.primaryText,
                          ),
                          const SizedBox(height: 16),
                          ...controller.categories.keys.map((category) {
                            int enabledServices = controller
                                .getEnabledServicesCount(category);
                            int totalServices = controller
                                .getTotalServicesCount(category);
                            return CategoryCard(
                              category: category,
                              icon: controller.getCategoryIcon(category),
                              enabledServices: enabledServices,
                              totalServices: totalServices,
                              onTap: () => controller.selectCategory(category),
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
                                onTap: () => controller.selectCategory(null),
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
                                child: Icon(
                                  controller.getCategoryIcon(
                                    controller.selectedCategory.value,
                                  ),
                                  color: const Color(0xFFFF6B35),
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  controller.selectedCategory.value,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1E3A8A),
                                  ),
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
                              .categories[controller.selectedCategory.value]!
                              .asMap()
                              .entries
                              .map((entry) {
                                int index = entry.key;
                                ServiceItem service = entry.value;
                                return ServiceCardWidget(
                                  service: service,
                                  onEditPressed:
                                      () => _showPriceDialog(
                                        context,
                                        controller,
                                        service,
                                        index,
                                        controller.selectedCategory.value,
                                      ),
                                );
                              }),
                          if (controller.selectedCategory.value ==
                              'Custom Services') ...[
                            const SizedBox(height: 16),
                            AddCustomServiceButton(
                              onPressed: controller.addCustomService,
                            ),
                          ],
                          const SizedBox(height: 32),
                          CustomButton(
                            onTap: controller.saveUserServices,
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
    TradeRateController controller,
    ServiceItem service,
    int index,
    String category,
  ) {
    final titleController = TextEditingController(text: service.title);
    final descController = TextEditingController(
      text: service.description ?? '',
    );
    final priceController = TextEditingController(
      text: service.price?.toStringAsFixed(0) ?? '',
    );

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              service.isCustom ? 'Add Custom Service' : 'Set Fixed Price',
            ),
            content: SingleChildScrollView(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (service.isCustom) ...[
                      TextField(
                        style: TextStyle(color: AppColor.secondaryText),
                        controller: titleController,
                        decoration: const InputDecoration(
                          labelText: 'Service Title',
                          labelStyle: TextStyle(
                            color: AppColor.secondaryText,
                            fontFamily: 'openSans',
                          ),
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.all(12),
                        ),
                        autofocus: true,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        style: TextStyle(color: AppColor.secondaryText),
                        controller: descController,
                        decoration: const InputDecoration(
                          labelText: 'Description (Optional)',
                          labelStyle: TextStyle(
                            color: AppColor.secondaryText,
                            fontFamily: 'openSans',
                          ),
                          border: OutlineInputBorder(),
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
                      decoration: const InputDecoration(
                        labelText: 'Fixed Price (£)',
                        border: OutlineInputBorder(),
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
              if (service.isCustom)
                TextButton(
                  onPressed: () {
                    controller.removeCustomService(category, index);
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
                  final updatedService = service.copyWith(
                    title:
                        service.isCustom
                            ? titleController.text.trim()
                            : service.title,
                    description:
                        service.isCustom
                            ? (descController.text.trim().isEmpty
                                ? null
                                : descController.text.trim())
                            : service.description,
                    price: double.tryParse(priceController.text),
                    isEnabled:
                        double.tryParse(priceController.text) != null &&
                        double.tryParse(priceController.text)! > 0,
                  );
                  controller.updateService(category, index, updatedService);
                  Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
            ],
          ),
    );
  }
}
