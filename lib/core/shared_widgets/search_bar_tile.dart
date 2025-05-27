import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../theme/app_color.dart';
import '../theme/assets.dart';

class SearchBarTile extends StatelessWidget {
  final TextEditingController? controller;
  final VoidCallback? onSearch;
  final String? hintText;
  final FocusNode? focusNode;
  final double? width;

  const SearchBarTile({
    super.key,
    this.controller,
    this.onSearch,
    this.hintText,
    this.focusNode,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveController = controller ?? TextEditingController();

    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColor.midGray.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: SvgPicture.asset(
              Assets.svgsSearch,
              color: AppColor.black,
              width: 20,
              height: 20,
            ),
          ),
          Expanded(
            child: TextField(
              controller: effectiveController,
              focusNode: focusNode,
              decoration: InputDecoration(
                hintText: hintText ?? 'Search...',
                hintStyle: TextStyle(
                  color: AppColor.customsLightGray,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onSubmitted: (value) => onSearch?.call(),
            ),
          ),
        ],
      ),
    );
  }
}
