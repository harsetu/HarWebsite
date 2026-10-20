import 'package:flutter/material.dart';

/// Wraps [child] with a subtle lift + shadow-growth on pointer hover —
/// a no-op on touch devices since no hover event ever fires there.
class HoverLift extends StatefulWidget {
  final Widget child;
  final double liftPixels;
  final double scale;

  const HoverLift({
    super.key,
    required this.child,
    this.liftPixels = 6,
    this.scale = 1.02,
  });

  @override
  State<HoverLift> createState() => _HoverLiftState();
}

class _HoverLiftState extends State<HoverLift> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedSlide(
        offset: _isHovered ? Offset(0, -widget.liftPixels / 100) : Offset.zero,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: AnimatedScale(
          scale: _isHovered ? widget.scale : 1.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          child: widget.child,
        ),
      ),
    );
  }
}
