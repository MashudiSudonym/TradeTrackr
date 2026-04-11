import 'package:flutter/material.dart';

/// Shimmer loading placeholder following the TradeTrackr design system.
///
/// Provides card and text shimmer variants for loading states.
/// Uses surfaceContainerHigh as the base with surfaceContainerHighest
/// as the shimmer highlight color.
class ShimmerPlaceholder extends StatefulWidget {
  const ShimmerPlaceholder({
    super.key,
    required this.child,
  });

  /// Creates a rectangular card shimmer placeholder.
  factory ShimmerPlaceholder.card({
    Key? key,
    double width = double.infinity,
    double height = 80,
    double borderRadius = 12,
  }) {
    return ShimmerPlaceholder(
      key: key,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }

  /// Creates a text line shimmer placeholder.
  factory ShimmerPlaceholder.text({
    Key? key,
    double width = 120,
    double height = 14,
    double borderRadius = 4,
  }) {
    return ShimmerPlaceholder(
      key: key,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }

  /// Creates a circular shimmer placeholder (for avatars).
  factory ShimmerPlaceholder.circle({
    Key? key,
    double size = 40,
  }) {
    return ShimmerPlaceholder(
      key: key,
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  final Widget child;

  @override
  State<ShimmerPlaceholder> createState() => _ShimmerPlaceholderState();
}

class _ShimmerPlaceholderState extends State<ShimmerPlaceholder>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            final slidePercent = _controller.value * 2 - 0.5;
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.topRight,
              colors: [
                cs.surfaceContainerHigh,
                cs.surfaceContainerHighest,
                cs.surfaceContainerHigh,
              ],
              stops: [
                (slidePercent - 0.3).clamp(0.0, 1.0),
                slidePercent.clamp(0.0, 1.0),
                (slidePercent + 0.3).clamp(0.0, 1.0),
              ],
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

/// Animated builder that rebuilds on animation changes.
class AnimatedBuilder extends StatelessWidget {
  const AnimatedBuilder({
    super.key,
    required this.animation,
    required this.builder,
    this.child,
  });

  final Animation<double> animation;
  final Widget Function(BuildContext context, Widget? child) builder;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return _ShimmerAnimatedBuilder(
      listenable: animation,
      builder: builder,
      child: child,
    );
  }
}

class _ShimmerAnimatedBuilder extends AnimatedWidget {
  const _ShimmerAnimatedBuilder({
    required Animation<double> super.listenable,
    required this.builder,
    this.child,
  });

  final Widget Function(BuildContext context, Widget? child) builder;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return builder(context, child);
  }
}
