import 'package:flutter/material.dart';

import '../constants/color_manager.dart';

/// Reusable shimmer effect. With no [child], renders a grey/white skeleton
/// placeholder box for content that's still loading. With a [child] (e.g. a
/// logo), instead sweeps a light highlight across it via a transparent
/// gradient — preserving the child's own colors — for a "shine" effect.
class BaseShimmer extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius borderRadius;
  final Widget? child;

  const BaseShimmer({
    super.key,
    this.width = double.infinity,
    this.height = 16,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.child,
  });

  @override
  State<BaseShimmer> createState() => _BaseShimmerState();
}

class _BaseShimmerState extends State<BaseShimmer> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasChild = widget.child != null;
    final content = widget.child ??
        Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: ColorManager.colorGrey,
            borderRadius: widget.borderRadius,
          ),
        );
    return AnimatedBuilder(
      animation: _controller,
      child: content,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: hasChild
                  ? [Colors.transparent, ColorManager.colorWhite.withAlpha(210), Colors.transparent]
                  : [ColorManager.colorGrey, ColorManager.colorWhite, ColorManager.colorGrey],
              stops: const [0.1, 0.5, 0.9],
              begin: Alignment(-1 - _controller.value * 2, 0),
              end: Alignment(1 - _controller.value * 2, 0),
            ).createShader(bounds);
          },
          child: child,
        );
      },
    );
  }
}
