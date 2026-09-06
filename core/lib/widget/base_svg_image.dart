import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Thin wrapper around [SvgPicture.asset] so feature code doesn't need its
/// own `flutter_svg` dependency — all SVG asset rendering routes through
/// core, consistent with the rest of the SVG usages in `core/lib/widget/`.
class BaseSvgImage extends StatelessWidget {
  final String assetPath;
  final double? width;
  final double? height;
  final BoxFit fit;

  const BaseSvgImage({
    super.key,
    required this.assetPath,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(assetPath, width: width, height: height, fit: fit);
  }
}