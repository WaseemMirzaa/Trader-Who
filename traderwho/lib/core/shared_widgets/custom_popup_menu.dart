import 'package:flutter/material.dart';

import '../theme/app_color.dart';
import '../theme/constant.dart';
import 'custom_text.dart';

/// A [CustomPopupMenu] widget that displays a menu with two options.
class CustomPopupMenu extends StatelessWidget {
  ///[onSelected] is a callback function that is called when an item is selected.
  final Function(String)? onSelected;

  ///[value1] is the value of the first item in the menu.
  final String value1;

  ///[value2] is the value of the second item in the menu.
  final String value2;

  ///[text1] is the text of the first item in the menu.
  final String text1;

  ///[text2] is the text of the second item in the menu.
  final String text2;

  ///[CustomPopupMenu] constructor that takes in the required parameters.

  const CustomPopupMenu({
    super.key,
    this.onSelected,
    required this.value1,
    required this.value2,
    required this.text1,
    required this.text2,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      elevation: 0,
      padding: EdgeInsets.zero,
      menuPadding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      icon: const Icon(Icons.more_vert, color: AppColor.white),
      onSelected: onSelected,
      itemBuilder:
          (BuildContext context) => <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              value: value1,
              child: Row(
                children: <Widget>[
                  // SvgPicture.asset(Assets.svgsEdit),
                  kGap10,
                  CustomText(text: text1, color: AppColor.navyBlue),
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: value2,
              child: Row(
                children: <Widget>[
                  // SvgPicture.asset(Assets.svgsDelete),
                  kGap10,
                  CustomText(text: text2, color: AppColor.red),
                ],
              ),
            ),
          ],
    );
  }
}
