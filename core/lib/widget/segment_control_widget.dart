import 'package:flutter/material.dart';

import '../constants/color_manager.dart';
import 'base_text_view.dart';

enum SegmentType { today, other }

class SegmentItem {
  final String title;
  final String value;
  final SegmentType type;

  SegmentItem({required this.title, required this.value, this.type = SegmentType.other});
}

class SegmentControlWidget extends StatefulWidget {
  final List<SegmentItem> segments;
  final String selectedValue;
  final ValueChanged<String> onChanged;

  const SegmentControlWidget({super.key, required this.segments, required this.selectedValue, required this.onChanged});

  @override
  State<SegmentControlWidget> createState() => _SegmentControlWidgetState();
}

class _SegmentControlWidgetState extends State<SegmentControlWidget> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurveTween(curve: Curves.easeInOut).animate(_animationController);
  }

  @override
  void didUpdateWidget(SegmentControlWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedValue != widget.selectedValue) {
      _animationController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: ColorManager.colorWhite,
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFFFDAE3), // #FFDAE3
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: widget.segments.map((segment) {
          final isSelected = segment.value == widget.selectedValue;
          final isToday = segment.type == SegmentType.today;

          return Expanded(
            child: GestureDetector(
              onTap: () => widget.onChanged(segment.value),
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    decoration: BoxDecoration(
                      gradient: isSelected && isToday
                          ? LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                ColorManager.colorWhite,
                                Color.lerp(ColorManager.colorWhite, const Color(0xFFFFDAE3), _animation.value) ?? const Color(0xFFFFDAE3),
                              ],
                            )
                          : null,
                      border: isSelected
                          ? Border(
                              bottom: BorderSide(
                                color: ColorManager.primaryColor,
                                width: 4.0 * _animation.value,
                              ),
                            )
                          : null,
                    ),
                    child: Center(
                      child: BaseTextView(
                        text: isSelected ? segment.title.toUpperCase() : segment.title,
                        style: TextStyle(
                          fontFamily: "assets/fonts/Poppins-Bold.ttf",
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: Color.lerp(
                            ColorManager.colorText80,
                            ColorManager.primaryColor,
                            isSelected ? _animation.value : 0,
                          ) ?? (isSelected ? ColorManager.primaryColor : ColorManager.colorText80),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
