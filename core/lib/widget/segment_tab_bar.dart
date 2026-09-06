import 'package:flutter/material.dart';

import '../constants/color_manager.dart';
import '../utils/formatting_utils.dart';

class SegmentTab {
  final String text;
  final bool isToday;

  const SegmentTab({required this.text, this.isToday = false});
}

class SegmentTabBar extends StatefulWidget {
  final TabController controller;
  final List<SegmentTab> tabs;
  final Color? dividerColor;
  final Color? indicatorStartColor;
  final Color? indicatorEndColor;
  final Color? indicatorBorderColor;
  final Color? selectedLabelColor;
  final Decoration? indicator;

  const SegmentTabBar({
    super.key,
    required this.controller,
    required this.tabs,
    this.dividerColor,
    this.indicatorStartColor,
    this.indicatorEndColor,
    this.indicatorBorderColor,
    this.selectedLabelColor,
    this.indicator,
  });

  @override
  State<SegmentTabBar> createState() => _SegmentTabBarState();
}

class _SegmentTabBarState extends State<SegmentTabBar> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  Color _getSelectedColor() {
    return widget.selectedLabelColor ?? ColorManager.primaryColor;
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final selectedColor = _getSelectedColor();

    return Container(
      color: ColorManager.colorWhite,
      child: TabBar(
        dividerColor: widget.dividerColor ?? const Color(0xFFFFDAE3),
        controller: widget.controller,
        indicator:
            widget.indicator ??
            BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  widget.indicatorStartColor ?? ColorManager.colorWhite,
                  widget.indicatorEndColor ?? const Color(0xFFFFDAE3),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              border: Border(
                bottom: BorderSide(
                  color: widget.indicatorBorderColor ?? selectedColor,
                  width: 4,
                ),
              ),
            ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: selectedColor,
        unselectedLabelColor: ColorManager.colorText80,
        labelStyle: themeData.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: themeData.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w500,
        ),
        tabs: widget.tabs
            .map(
              (tab) => Tab(
                text: FormattingUtils.getLocalizeString(context, tab.text),
              ),
            )
            .toList(),
      ),
    );
  }
}
