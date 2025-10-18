import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:traderwho/controller/new_service_controller.dart';
// legacy imports removed - using NewServiceController
import 'package:traderwho/core/shared_widgets/custom_button.dart';
import 'package:traderwho/core/shared_widgets/custom_sccfold.dart';
import 'package:traderwho/core/shared_widgets/custom_text.dart';
import 'package:traderwho/core/theme/app_color.dart';
import 'package:traderwho/models/models.dart';
import 'package:traderwho/views/trade_onboarding/presentation/pages/pages.dart';
import 'package:traderwho/views/trades_profile/presentation/widgets/widgets.dart';

class TradeLargerRatePage extends StatelessWidget {
  const TradeLargerRatePage({super.key});

  @override
  Widget build(BuildContext context) {
    final NewServiceController controller = Get.put(NewServiceController());

    return TraderWhoScaffold(
      appBar: TradeRatesAppbar(title: "Set Fixed Prices for large Jobs"),
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
                              'Configure your large job services and set fixed prices for instant bookings.',
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
                          ...controller.largeCategories.keys.map((categoryId) {
                            int enabledServices = controller
                                .getEnabledLargeServicesCount(categoryId);
                            int totalServices = controller
                                .getTotalLargeServicesCount(categoryId);
                            final categoryName =
                                controller.categories
                                    .firstWhereOrNull((c) => c.id == categoryId)
                                    ?.name ??
                                categoryId;
                            return CategoryCard(
                              category: categoryName,
                              icon: controller.getCategoryIcon(categoryName),
                              enabledServices: enabledServices,
                              totalServices: totalServices,
                              onTap: () {
                                print(
                                  '🔍 Tapping category: $categoryName (ID: $categoryId)',
                                );
                                print(
                                  '🔍 largeCategories keys: ${controller.largeCategories.keys.toList()}',
                                );
                                print(
                                  '🔍 Selected category before: ${controller.selectedCategory.value}',
                                );
                                controller.selectCategory(categoryId);
                                print(
                                  '🔍 Selected category after: ${controller.selectedCategory.value}',
                                );
                                print(
                                  '🔍 largeCategories has key: ${controller.largeCategories.containsKey(categoryId)}',
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
                                onTap: () => controller.selectCategory(''),
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
                                'large',
                              )
                              .asMap()
                              .entries
                              .map((entry) {
                                int index = entry.key;
                                JobModel service = entry.value;
                                return ServiceCardWidget(
                                  job: service,
                                  price: controller.getJobPrice(service.id),
                                  isEnabled: controller.isJobEnabled(
                                    service.id,
                                  ),
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
                          // if (controller.selectedCategory.value ==
                          //     'Custom Services') ...[
                          //   const SizedBox(height: 16),
                          //   AddCustomServiceButton(
                          //     onPressed: controller.addCustomService,
                          //   ),
                          // ],
                          const SizedBox(height: 32),
                          CustomButton(
                            onTap: () {
                              controller.saveUserServices(isFromLargeJob: true);
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
    JobModel service,
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
            title: Text('Set Fixed Price'),
            content: SingleChildScrollView(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // if (service.isCustom) ...[
                    //   TextField(
                    //     style: TextStyle(color: AppColor.secondaryText),
                    //     controller: titleController,
                    //     cursorColor: AppColor.primaryText,
                    //     decoration: const InputDecoration(
                    //       labelText: 'Service Title',
                    //       labelStyle: TextStyle(color: AppColor.primaryText),
                    //       border: OutlineInputBorder(
                    //         borderSide: BorderSide(color: AppColor.primaryText),
                    //       ),
                    //       focusedBorder: OutlineInputBorder(
                    //         borderSide: BorderSide(color: AppColor.primaryText),
                    //       ),
                    //       disabledBorder: OutlineInputBorder(
                    //         borderSide: BorderSide(color: AppColor.primaryText),
                    //       ),
                    //       enabledBorder: OutlineInputBorder(
                    //         borderSide: BorderSide(color: AppColor.primaryText),
                    //       ),
                    //       contentPadding: EdgeInsets.all(12),
                    //     ),
                    //     autofocus: true,
                    //   ),
                    //   const SizedBox(height: 16),
                    //   TextField(
                    //     style: TextStyle(color: AppColor.secondaryText),
                    //     controller: descController,
                    //     cursorColor: AppColor.primaryText,
                    //     decoration: const InputDecoration(
                    //       labelText: 'Description (Optional)',
                    //       labelStyle: TextStyle(color: AppColor.primaryText),
                    //       border: OutlineInputBorder(
                    //         borderSide: BorderSide(color: AppColor.primaryText),
                    //       ),
                    //       focusedBorder: OutlineInputBorder(
                    //         borderSide: BorderSide(color: AppColor.primaryText),
                    //       ),
                    //       disabledBorder: OutlineInputBorder(
                    //         borderSide: BorderSide(color: AppColor.primaryText),
                    //       ),
                    //       enabledBorder: OutlineInputBorder(
                    //         borderSide: BorderSide(color: AppColor.primaryText),
                    //       ),
                    //       hintText: 'Brief description of what\'s included',
                    //       hintStyle: TextStyle(
                    //         color: AppColor.secondaryText,
                    //         fontFamily: 'openSans',
                    //       ),
                    //       contentPadding: EdgeInsets.all(12),
                    //     ),
                    //     maxLines: 2,
                    //   ),
                    //   const SizedBox(height: 16),
                    // ],
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
