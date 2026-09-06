import 'package:flutter/material.dart';

import '../constants/color_manager.dart';
import 'base_text_view.dart';

/// Reusable +/- quantity stepper (e.g. number of adults/children/rooms).
class BaseQuantityStepper extends StatelessWidget {
  final int value;
  final int minValue;
  final int? maxValue;
  final ValueChanged<int> onChanged;

  const BaseQuantityStepper({
    super.key,
    required this.value,
    required this.onChanged,
    this.minValue = 0,
    this.maxValue,
  });

  bool get _canDecrement => value > minValue;

  bool get _canIncrement => maxValue == null || value < maxValue!;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _StepperButton(
          icon: Icons.remove,
          onTap: _canDecrement ? () => onChanged(value - 1) : null,
        ),
        SizedBox(
          width: 40,
          child: BaseTextView(
            text: '$value',
            isLocalizeText: false,
            useAutoTranslation: false,
            textAlign: TextAlign.center,
          ),
        ),
        _StepperButton(
          icon: Icons.add,
          onTap: _canIncrement ? () => onChanged(value + 1) : null,
        ),
      ],
    );
  }
}

class _StepperButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _StepperButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isEnabled = onTap != null;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 36,
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: ColorManager.colorBorder),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 18,
          color: isEnabled ? ColorManager.primaryColor : ColorManager.colorHint,
        ),
      ),
    );
  }
}
