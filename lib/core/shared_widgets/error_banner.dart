import 'package:flutter/material.dart';

import '../extensions/context_extension.dart';
import '../theme/constant.dart';
import 'custom_text.dart';

/// A [ErrorBanner] widget that displays an error message in a banner style.
class ErrorBanner extends StatelessWidget {
  /// Creates an [ErrorBanner] widget with the given [message].
  const ErrorBanner({super.key, required this.message});

  /// The error [message] to be displayed in the banner.
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: kH15,
        child: Container(
          padding: kAll15,
          decoration: BoxDecoration(
            color: context.theme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            spacing: 5,
            children: [
              const Icon(Icons.error, size: 20),
              Flexible(child: CustomText(text: message)),
            ],
          ),
        ),
      ),
    );
  }
}
