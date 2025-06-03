import 'package:flutter/material.dart';
import 'package:traderwho/core/shared_widgets/custom_button.dart';
import 'package:traderwho/core/shared_widgets/custom_text.dart';
import 'package:traderwho/core/shared_widgets/custom_textfield.dart';
import 'package:traderwho/core/theme/app_color.dart';
import 'package:traderwho/views/trades_profile/presentation/widgets/widgets.dart';

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
                fontWeight: FontWeight.bold,
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
                  fontWeight: FontWeight.bold, // Custom weight
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
                  fontWeight: FontWeight.bold, // Custom weight
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
                  CustomButton(
                    text: 'CANCEL',
                    onTap: () => onSave(null),
                    color: AppColor.orangecustomColor,
                    textColor: AppColor.black,
                    height: 40,
                    width: 100, // Explicit width to constrain the button
                    radius: 8,
                  ),
                  const SizedBox(width: 8),
                  CustomButton(
                    text: 'SAVE',
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        final newService = Service(
                          title: titleController.text.trim(),
                          price: double.parse(priceController.text.trim()),
                        );
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
}
