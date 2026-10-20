import 'package:core/constants/color_manager.dart';
import 'package:flutter/material.dart';

/// Classic "line – diamond – line" flourish. The lines draw outward from the
/// diamond on first build (skipped when the user prefers reduced motion).
class OrnamentDivider extends StatelessWidget {
  final Color? color;
  final double width;

  const OrnamentDivider({super.key, this.color, this.width = 160});

  @override
  Widget build(BuildContext context) {
    final tone = color ?? ColorManager.primaryColor;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    return ExcludeSemantics(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: reduceMotion ? 1 : 0, end: 1),
        duration: const Duration(milliseconds: 900),
        curve: Curves.easeOutCubic,
        builder: (context, t, _) => SizedBox(
          width: width,
          child: Row(
            children: [
              Expanded(child: _line(tone, t, toRight: false)),
              const SizedBox(width: 10),
              Transform.rotate(
                angle: 0.785398,
                child: Container(width: 8, height: 8, color: tone),
              ),
              const SizedBox(width: 10),
              Expanded(child: _line(tone, t, toRight: true)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _line(Color tone, double t, {required bool toRight}) {
    return Align(
      alignment: toRight ? Alignment.centerLeft : Alignment.centerRight,
      child: FractionallySizedBox(
        widthFactor: t,
        child: Container(height: 1, color: tone.withAlpha(150)),
      ),
    );
  }
}
