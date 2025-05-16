import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../theme/app_color.dart';
import '../theme/assets.dart';


class SearchBarTile extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSearch;
  final String? hintText;
  final FocusNode? focusNode;
  final double? width;  // <-- Add this

  const SearchBarTile({
    super.key,
    required this.controller,
    required this.onSearch,
    required this.hintText,
    this.focusNode,
    this.width,  // <-- Add this
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,  // <-- Apply custom width
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColor.midGray.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          // Search icon
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: SvgPicture.asset(
              Assets.svgsSearch,
              color: AppColor.black,
              width: 20,
              height: 20,
            ),
          ),
          // Search text field
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  color: AppColor.mutedGray,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onSubmitted: (value) => onSearch(),
            ),
          ),
        ],
      ),
    );
  }
}