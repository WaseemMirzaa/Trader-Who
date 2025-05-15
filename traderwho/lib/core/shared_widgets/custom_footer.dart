import 'package:flutter/material.dart';

import 'custom_text.dart';

/// A [CustomFooter]widget that displays a powered by message and an image.
class CustomFooter extends StatefulWidget {
  /// [CustomFooter] constructor.
  const CustomFooter({super.key});

  @override
  State<CustomFooter> createState() => _CustomFooterState();
}

class _CustomFooterState extends State<CustomFooter> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      spacing: 2,
      children: <Widget>[
        CustomText(text: 'Powered by', fontSize: 13),
        // Image.asset(
        //   Assets.imagesSplash,
        //   width: 90,
        //   fit: BoxFit.fill,
        // ),
      ],
    );
  }
}
