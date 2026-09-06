import 'package:flutter/material.dart';

import '../constants/app_text_styles.dart';
import '../constants/color_manager.dart';
import 'base_text_view.dart';

/// Horizontal-scrolling grid of tappable cards used to let the user pick one
/// item (e.g. a trust property) out of several.
///
/// Callers should only render this when [items] has more than one entry —
/// a single item should be auto-selected instead, and an empty list should
/// be handled with an explanatory message rather than an empty grid.
class BasePropertyGrid<T> extends StatelessWidget {
  final List<T> items;
  final bool Function(T item) isSelected;
  final String Function(T item) labelBuilder;
  final ValueChanged<T> onSelected;
  final double height;

  const BasePropertyGrid({
    super.key,
    required this.items,
    required this.isSelected,
    required this.labelBuilder,
    required this.onSelected,
    this.height = 56,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          // childAspectRatio is cross-axis/main-axis extent — with a
          // horizontal scroll direction that's height/width, so this value
          // is inverted from the usual "width divided by height" intuition.
          childAspectRatio: 0.4,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return _PropertyGridItem(
            label: labelBuilder(item),
            isSelected: isSelected(item),
            onTap: () => onSelected(item),
          );
        },
      ),
    );
  }
}

class _PropertyGridItem extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _PropertyGridItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? ColorManager.primaryColor.withAlpha(20) : ColorManager.colorWhite,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? ColorManager.primaryColor : ColorManager.colorBorder,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: BaseTextView(
          text: label,
          isLocalizeText: false,
          useAutoTranslation: false,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.bodySemibold,
          textColor: isSelected ? ColorManager.primaryColor : ColorManager.colorText70,
        ),
      ),
    );
  }
}
