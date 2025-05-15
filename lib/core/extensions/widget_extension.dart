import 'package:flutter/material.dart';

/// Widget Extension methods
extension WidgetExtensions on Widget {
  /// Adds padding around the widget.
  Widget withPadding(EdgeInsets padding) =>
      Padding(padding: padding, child: this);

  /// Wraps the widget in a `Center` widget.
  Widget center() => Center(child: this);

  /// Adds a tooltip to the widget.
  Widget withTooltip(String message) => Tooltip(message: message, child: this);

  /// Adds a background color to the widget using a `Container`.
  Widget withBackgroundColor(Color color) =>
      Container(color: color, child: this);
}
