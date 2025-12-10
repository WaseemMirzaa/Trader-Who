import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traderou/core/shared_widgets/custom_button.dart';
import 'package:traderou/core/shared_widgets/custom_text.dart';
import 'package:traderou/core/shared_widgets/custom_textfield.dart';
import 'package:traderou/core/theme/app_color.dart';
import 'package:traderou/views/trades_profile/presentation/widgets/widgets.dart';

class CustomDialogs {
  static Widget addService({required Function(Service?) onSave}) {
    final titleController = TextEditingController();
    final priceController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Custom Title
              const CustomText(
                text: 'Add New Service',
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: AppColor.black,
              ),
              const SizedBox(height: 20),
              // Custom TextField for Service Title
              CustomTextField(
                controller: titleController,
                hintText: ' Title',
                headingStyle: TextStyle(
                  color: Colors.black, // Custom color
                  fontSize: 14, // Custom size
                  fontWeight: FontWeight.w500, // Custom weight
                ),
                hintStyle: const TextStyle(
                  color: AppColor.mediumGray, // Custom hint text color
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
                fieldHeading: 'Service Title',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Custom TextField for Price
              CustomTextField(
                controller: priceController,
                hintText: '£0.00',
                fieldHeading: 'Price',
                headingStyle: TextStyle(
                  color: Colors.black, // Custom color
                  fontSize: 14, // Custom size
                  fontWeight: FontWeight.w500, // Custom weight
                ),
                hintStyle: const TextStyle(
                  color: AppColor.mediumGray, // Custom hint text color
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                // prefixLabel: '£',
              ),
              const SizedBox(height: 24),
              // Buttons Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(fontSize: 16, color: AppColor.black),
                    ),
                  ),

                  const SizedBox(width: 8),
                  CustomButton(
                    text: 'SAVE',
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        final newService = Service(
                          title: titleController.text.trim(),
                          price:
                              double.tryParse(priceController.text.trim()) ??
                              0.0,
                        );
                        // Call the onSave callback with the new service
                        onSave(newService);
                      }
                    },
                    color: AppColor.darkBlue,
                    textColor: Colors.white,
                    height: 40,
                    width: 100, // Explicit width to constrain the button
                    radius: 8,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Edit Service Dialog
  static Widget editService({
    required Service service,
    required Function(Service?) onSave,
  }) {
    final titleController = TextEditingController(text: service.title);
    final priceController = TextEditingController(
      text: service.price.toStringAsFixed(2),
    );
    final formKey = GlobalKey<FormState>();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Custom Title
              const CustomText(
                text: 'Edit Service',
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: AppColor.black,
              ),
              const SizedBox(height: 20),
              // Custom TextField for Service Title
              CustomTextField(
                controller: titleController,
                hintText: 'Title',
                headingStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                hintStyle: const TextStyle(
                  color: AppColor.mediumGray,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
                fieldHeading: 'Service Title',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Custom TextField for Price
              CustomTextField(
                controller: priceController,
                hintText: '£0.00',
                fieldHeading: 'Price',
                headingStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                hintStyle: const TextStyle(
                  color: AppColor.mediumGray,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
              const SizedBox(height: 24),
              // Buttons Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(fontSize: 16, color: AppColor.black),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CustomButton(
                    text: 'UPDATE',
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        final updatedService = Service(
                          title: titleController.text.trim(),
                          price:
                              double.tryParse(priceController.text.trim()) ??
                              0.0,
                          description: service.description,
                        );
                        onSave(updatedService);
                      }
                    },
                    color: AppColor.darkBlue,
                    textColor: Colors.white,
                    height: 40,
                    width: 100,
                    radius: 8,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Delete Service Dialog
  static Widget deleteServiceConfirmation({
    required String serviceName,
    required Function() onConfirm,
  }) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Custom Title
            const CustomText(
              text: 'Delete Service',
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppColor.black,
            ),
            const SizedBox(height: 16),
            // Confirmation message
            Text(
              'Are you sure you want to delete "$serviceName"?',
              style: const TextStyle(
                fontSize: 16,
                color: AppColor.darkBlueText,
              ),
            ),
            const SizedBox(height: 24),
            // Buttons Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(fontSize: 16, color: AppColor.black),
                  ),
                ),
                const SizedBox(width: 8),
                CustomButton(
                  text: 'DELETE',
                  onTap: () {
                    onConfirm();
                    Get.back();
                  },
                  color: Colors.red,
                  textColor: Colors.white,
                  height: 40,
                  width: 100,
                  radius: 8,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
