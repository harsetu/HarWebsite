import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Fades and slides [child] in the first time it becomes meaningfully
/// visible while scrolling, then leaves it alone — a lightweight,
/// scroll-triggered reveal used to give sections some entrance motion
/// without re-triggering every time the user scrolls back past them.
class ScrollFadeIn extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final double offset;

  const ScrollFadeIn({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.offset = 32,
  });

  @override
  State<ScrollFadeIn> createState() => _ScrollFadeInState();
}

class _ScrollFadeInState extends State<ScrollFadeIn> {
  // A detector needs a key that's unique across the whole tree but stable
  // across this State's own rebuilds — UniqueKey() created once here (rather
  // than derived from `widget`) guarantees both.
  final Key _detectorKey = UniqueKey();
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: _detectorKey,
      onVisibilityChanged: (info) {
        if (!_isVisible && info.visibleFraction > 0.15) {
          if (widget.delay == Duration.zero) {
            setState(() => _isVisible = true);
          } else {
            Future.delayed(widget.delay, () {
              if (mounted) setState(() => _isVisible = true);
            });
          }
        }
      },
      child: AnimatedOpacity(
        opacity: _isVisible ? 1 : 0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
        child: AnimatedSlide(
          offset: _isVisible ? Offset.zero : Offset(0, widget.offset / 100),
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
          child: widget.child,
        ),
      ),
    );
  }
}