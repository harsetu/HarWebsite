import 'package:flutter/material.dart';

import '../../constants/color_manager.dart';

class BaseSwitcher extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const BaseSwitcher({
    super.key,
    required this.value,
    required this.onChanged,
  });

  Null get hintTextColor => null;

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: value,
      onChanged: onChanged,
      thumbColor: WidgetStateProperty.resolveWith<Color?>(
        (Set<WidgetState> states) {
          return ColorManager.colorWhite; // default
        },
      ),
      padding: EdgeInsets.zero,
      trackColor: WidgetStateProperty.resolveWith<Color?>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return ColorManager.textColor;
          }
          return ColorManager.colorGrey; // default
        },
      ),
    );
  }
}
