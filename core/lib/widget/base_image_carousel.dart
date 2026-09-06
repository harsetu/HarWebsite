import 'dart:async';

import 'package:flutter/material.dart';

import 'custom_page_indicator.dart';

/// Full-screen, auto-rotating image carousel with a [CustomPageIndicator]
/// overlay. StatefulWidget only to own the [PageController]/[Timer]/current
/// page — purely local animation state, no business logic.
class BaseImageCarousel extends StatefulWidget {
  final List<String> imagePaths;
  final Duration autoRotateDuration;
  final Duration animationDuration;

  const BaseImageCarousel({
    super.key,
    required this.imagePaths,
    this.autoRotateDuration = const Duration(seconds: 4),
    this.animationDuration = const Duration(milliseconds: 500),
  });

  @override
  State<BaseImageCarousel> createState() => _BaseImageCarouselState();
}

class _BaseImageCarouselState extends State<BaseImageCarousel> {
  late final PageController _pageController;
  Timer? _timer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    if (widget.imagePaths.length > 1) {
      _timer = Timer.periodic(widget.autoRotateDuration, (_) => _goToNextPage());
    }
  }

  void _goToNextPage() {
    if (!_pageController.hasClients) return;
    final nextIndex = (_currentIndex + 1) % widget.imagePaths.length;
    _pageController.animateToPage(
      nextIndex,
      duration: widget.animationDuration,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imagePaths.isEmpty) return const SizedBox.shrink();

    return Stack(
      fit: StackFit.expand,
      children: [
        PageView.builder(
          controller: _pageController,
          itemCount: widget.imagePaths.length,
          onPageChanged: (index) => setState(() => _currentIndex = index),
          itemBuilder: (context, index) {
            return Image.asset(
              widget.imagePaths[index],
              fit: BoxFit.cover,
            );
          },
        ),
        if (widget.imagePaths.length > 1)
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Center(
              child: CustomPageIndicator(
                currentIndex: _currentIndex,
                count: widget.imagePaths.length,
              ),
            ),
          ),
      ],
    );
  }
}
