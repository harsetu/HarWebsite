import 'package:flutter/material.dart';

/// Endlessly bobs [child] up and down by [distance] px. Purely decorative;
/// holds still when the user prefers reduced motion.
class GentleFloat extends StatefulWidget {
  final Widget child;
  final double distance;
  final Duration period;
  final Duration delay;

  const GentleFloat({
    super.key,
    required this.child,
    this.distance = 10,
    this.period = const Duration(seconds: 4),
    this.delay = Duration.zero,
  });

  @override
  State<GentleFloat> createState() => _GentleFloatState();
}

class _GentleFloatState extends State<GentleFloat>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.period);
    Future.delayed(widget.delay, () {
      if (mounted) _controller.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return widget.child;
    final curve = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    return AnimatedBuilder(
      animation: curve,
      child: widget.child,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, (curve.value - 0.5) * 2 * widget.distance),
        child: child,
      ),
    );
  }
}
