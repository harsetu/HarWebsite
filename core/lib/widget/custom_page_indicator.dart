import 'package:flutter/material.dart';

class CustomPageIndicator extends StatelessWidget {
  final int currentIndex;
  final int count;
  final Color activeColor;
  final Color inactiveColor;
  final double inactiveSize;
  final double activeWidth;
  final double activeHeight;
  final double spacing;

  const CustomPageIndicator({
    super.key,
    required this.currentIndex,
    required this.count,
    this.activeColor = const Color(0xffB97912), // Default primary color
    this.inactiveColor = const Color(0xffEDE7E3),
    this.inactiveSize = 5.0,
    this.activeWidth = 60.0,
    this.activeHeight = 5.0,
    this.spacing = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate the total available width for indicators
    final screenWidth = MediaQuery.of(context).size.width;
    final totalSpacing = spacing * (count - 1);
    final availableWidth = screenWidth - totalSpacing - 32; // 32 for padding
    final calculatedActiveWidth = availableWidth * 0.1456; // 14.56% of available width

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (index) {
        final isActive = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: EdgeInsets.symmetric(horizontal: spacing / 2),
          width: isActive ? calculatedActiveWidth : inactiveSize,
          height: isActive ? activeHeight : inactiveSize,
          decoration: BoxDecoration(
            color: isActive ? activeColor : inactiveColor,
            borderRadius: BorderRadius.circular(
              isActive ? activeHeight / 2 : inactiveSize / 2,
            ),
          ),
        );
      }),
    );
  }
}
