import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class CustomShimmer extends StatelessWidget {
  final Widget child;
  final bool isActive;
  final Duration duration;
  final Color color;
  final double colorOpacity;
  final Duration interval;
  final ShimmerDirection direction;

  const CustomShimmer({
    super.key,
    required this.child,
    this.isActive = true,
    this.duration = const Duration(seconds: 3),
    this.color = Colors.white,
    this.colorOpacity = 0.3,
    this.interval = const Duration(seconds: 0),
    this.direction = const ShimmerDirection.fromLTRB(),
  });

  @override
  Widget build(BuildContext context) {
    if (!isActive) return child;

    return Shimmer(
      enabled: isActive,
      color: color,
      colorOpacity: colorOpacity,
      duration: duration,
      interval: interval,
      direction: direction,
      child: child,
    );
  }
}

// Helper extension for easy shimmer usage
extension ShimmerExtensions on Widget {
  Widget applyShimmer({
    bool isActive = true,
    Duration duration = const Duration(seconds: 3),
    Color color = Colors.white,
    double colorOpacity = 0.3,
    Duration interval = const Duration(seconds: 0),
    ShimmerDirection direction = const ShimmerDirection.fromLTRB(),
  }) {
    return CustomShimmer(
      isActive: isActive,
      duration: duration,
      color: color,
      colorOpacity: colorOpacity,
      interval: interval,
      direction: direction,
      child: this,
    );
  }
}
