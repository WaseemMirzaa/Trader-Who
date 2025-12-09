import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:traderwho/core/theme/app_color.dart';

class CustomTimePicker extends StatefulWidget {
  final TimeOfDay? initialTime;
  final Function(TimeOfDay) onTimeSelected;

  const CustomTimePicker({
    super.key,
    this.initialTime,
    required this.onTimeSelected,
  });

  @override
  State<CustomTimePicker> createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker> {
  late TextEditingController hourController;
  late TextEditingController minuteController;
  late bool isAM;

  @override
  void initState() {
    super.initState();
    final now = widget.initialTime ?? TimeOfDay.now();
    final displayHour = now.hourOfPeriod == 0 ? 12 : now.hourOfPeriod;
    hourController = TextEditingController(
      text: displayHour.toString().padLeft(2, '0'),
    );
    minuteController = TextEditingController(
      text: now.minute.toString().padLeft(2, '0'),
    );
    isAM = now.period == DayPeriod.am;
  }

  @override
  void dispose() {
    hourController.dispose();
    minuteController.dispose();
    super.dispose();
  }

  bool _isValidTime() {
    final hour = int.tryParse(hourController.text) ?? -1;
    final minute = int.tryParse(minuteController.text) ?? -1;
    return hour >= 1 && hour <= 12 && minute >= 0 && minute <= 59;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            const Text(
              'Select time',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: AppColor.primaryText,
              ),
            ),
            const SizedBox(height: 24),

            // Time Input Row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Hour Input
                _buildTimeInput(controller: hourController, maxLength: 2),
                const SizedBox(width: 12),

                // Minute Input
                _buildTimeInput(controller: minuteController, maxLength: 2),
                const SizedBox(width: 12),

                // AM/PM Dropdown
                _buildAmPmDropdown(),
              ],
            ),
            const SizedBox(height: 24),

            // Buttons Row
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Cancel Button
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    'CANCEL',
                    style: TextStyle(
                      color: AppColor.primaryText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // OK Button
                ElevatedButton(
                  onPressed:
                      _isValidTime()
                          ? () {
                            final hour =
                                int.tryParse(hourController.text) ?? 12;
                            final minute =
                                int.tryParse(minuteController.text) ?? 0;

                            final convertedHour =
                                isAM
                                    ? (hour == 12 ? 0 : hour)
                                    : (hour == 12 ? 12 : hour + 12);

                            final time = TimeOfDay(
                              hour: convertedHour,
                              minute: minute,
                            );
                            widget.onTimeSelected(time);
                            Navigator.of(context).pop();
                          }
                          : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.orangeCustomColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'OK',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeInput({
    required TextEditingController controller,
    required int maxLength,
  }) {
    final isHour = controller == hourController;
    return Semantics(
      label:
          isHour
              ? 'Hour input, currently ${controller.text}'
              : 'Minute input, currently ${controller.text}',
      button: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          HapticFeedback.selectionClick();
          if (isHour) {
            _showHourPicker();
          } else {
            _showMinutePicker();
          }
        },
        child: Container(
          width: 80,
          height: 60,
          decoration: BoxDecoration(
            border: Border.all(color: AppColor.orangeCustomColor, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              controller.text,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w400,
                color: AppColor.primaryText,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showHourPicker() {
    HapticFeedback.lightImpact();
    showDialog(
      context: context,
      barrierDismissible: true,
      builder:
          (context) => AlertDialog(
            title: const Text('Select Hour'),
            content: SizedBox(
              width: 300,
              height: 250,
              child: CupertinoPicker(
                scrollController: FixedExtentScrollController(
                  initialItem: (int.tryParse(hourController.text) ?? 1) - 1,
                ),
                itemExtent: 40,
                onSelectedItemChanged: (index) {
                  setState(() {
                    hourController.text = (index + 1).toString().padLeft(
                      2,
                      '0',
                    );
                  });
                },
                children: List.generate(
                  12,
                  (index) => Center(
                    child: Text(
                      (index + 1).toString().padLeft(2, '0'),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'OK',
                  style: TextStyle(color: AppColor.orangeCustomColor),
                ),
              ),
            ],
          ),
    );
  }

  void _showMinutePicker() {
    HapticFeedback.lightImpact();
    showDialog(
      context: context,
      barrierDismissible: true,
      builder:
          (context) => AlertDialog(
            title: const Text('Select Minute'),
            content: SizedBox(
              width: 300,
              height: 250,
              child: CupertinoPicker(
                scrollController: FixedExtentScrollController(
                  initialItem: int.tryParse(minuteController.text) ?? 0,
                ),
                itemExtent: 40,
                onSelectedItemChanged: (index) {
                  setState(() {
                    minuteController.text = index.toString().padLeft(2, '0');
                  });
                },
                children: List.generate(
                  60,
                  (index) => Center(
                    child: Text(
                      index.toString().padLeft(2, '0'),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'OK',
                  style: TextStyle(color: AppColor.orangeCustomColor),
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildAmPmDropdown() {
    return Container(
      width: 70,
      height: 60,
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.orangeCustomColor, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<bool>(
          value: isAM,
          icon: const Icon(Icons.arrow_drop_down, color: AppColor.primaryText),
          isExpanded: true,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColor.primaryText,
          ),
          dropdownColor: Colors.white,
          items: const [
            DropdownMenuItem(
              value: true,
              child: Center(
                child: Text(
                  'AM',
                  style: TextStyle(color: AppColor.primaryText),
                ),
              ),
            ),
            DropdownMenuItem(
              value: false,
              child: Center(
                child: Text(
                  'PM',
                  style: TextStyle(color: AppColor.primaryText),
                ),
              ),
            ),
          ],
          onChanged: (value) {
            setState(() => isAM = value ?? true);
          },
        ),
      ),
    );
  }
}

// Helper function to show the custom time picker
Future<TimeOfDay?> showCustomTimePicker({
  required BuildContext context,
  TimeOfDay? initialTime,
}) async {
  TimeOfDay? selectedTime;

  await showDialog(
    context: context,
    builder:
        (context) => CustomTimePicker(
          initialTime: initialTime,
          onTimeSelected: (time) {
            selectedTime = time;
          },
        ),
  );

  return selectedTime;
}
