import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants/color_manager.dart';
import 'base_text_view.dart';

class BaseButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback? onPressed;
  final IconData? icon;
  final AssetImage? imageIcon;
  final bool isDisabled;
  final bool isLoading;
  final SvgPicture? img;
  final TextStyle? textStyle;
  final BaseButtonTypeEnum buttonTypeEnum;
  final double buttonVerticalPadding;
  final double? buttonHorizontalPadding;
  final double buttonRadius;
  final Color? borderColor;
  final Color? textColor;
  final Color? bgColor;
  final Color? disableColor;
  final double? width;
  final double? height;
  final Widget? rightWidget;
  final bool hasShadow;

  const BaseButton({
    super.key,
    required this.buttonText,
    this.onPressed,
    this.icon,
    this.imageIcon,
    this.isDisabled = false,
    this.isLoading = false,
    this.img,
    this.textStyle,
    this.textColor,
    this.buttonTypeEnum = BaseButtonTypeEnum.buttonTypePrimary,
    this.buttonVerticalPadding = 16,
    this.buttonHorizontalPadding,
    this.buttonRadius = 16,
    this.borderColor,
    this.bgColor,
    this.disableColor,
    this.width,
    this.height,
    this.rightWidget,
    this.hasShadow = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: (isDisabled || isLoading) ? null : onPressed,
      child: Container(
        width: width,
        height: height,
        padding: EdgeInsets.symmetric(
          vertical: buttonVerticalPadding,
          horizontal: buttonHorizontalPadding ?? 0,
        ),
        decoration: _buildDecoration(theme),
        child: _buildContent(theme),
      ),
    );
  }

  BoxDecoration _buildDecoration(ThemeData theme) {
    return BoxDecoration(
      border: _getBorderColor() != null ? Border.all(color: _getBorderColor()!) : null,
      borderRadius: BorderRadius.circular(buttonRadius),
      color: buttonTypeEnum == BaseButtonTypeEnum.buttonTypeGradient ? null : _getBackgroundColor(ColorManager.primaryColor),
      gradient: buttonTypeEnum == BaseButtonTypeEnum.buttonTypeGradient
          ? LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: (isDisabled || isLoading)
            ? [
          theme.primaryColor.withAlpha(102),
          theme.primaryColorDark.withAlpha(102),
        ]
            : [
          theme.primaryColor,
          theme.primaryColorDark,
        ],
      )
          : null,
      boxShadow: hasShadow
          ? [
        BoxShadow(
          color: ColorManager.colorBlack.withAlpha(50),
          offset: const Offset(0, 4),
          blurRadius: 12,
        ),
      ]
          : null,
    );
  }

  Widget _buildContent(ThemeData theme) {
    if (isLoading) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(_getTextColor(theme.primaryColor)),
            ),
          ),
        ],
      );
    }

    final List<Widget> children = [];

    if (icon != null) {
      children.add(Icon(icon, color: _getIconColor(theme.primaryColor)));
    }

    if (imageIcon != null) {
      children.add(Image(image: imageIcon!, width: 16, height: 16));
    }

    children.add(
      BaseTextView(
        text: buttonText,
        style: textStyle?.copyWith(color: _getTextColor(theme.primaryColor)) ??
            theme.textTheme.titleLarge?.copyWith(color: _getTextColor(theme.primaryColor)),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
    if (img != null) {
      children.add(SizedBox(width: 16, height: 16, child: img));
    }

    if (rightWidget != null) {
      children.add(rightWidget!);
    }

    return Row(
      spacing: 8,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }

  Color _getTextColor(Color primaryColor) {
    if (textColor != null) return textColor!;

    switch (buttonTypeEnum) {
      case BaseButtonTypeEnum.buttonTypeSecondary:
      case BaseButtonTypeEnum.buttonTypeText:
        return primaryColor;
      case BaseButtonTypeEnum.buttonTypeOutline:
        return ColorManager.textColor;
      default:
        return ColorManager.colorWhite;
    }
  }

  Color _getBackgroundColor(Color primaryColor) {
    if (bgColor != null) return bgColor!;
    if (isDisabled && disableColor != null) return disableColor!;

    switch (buttonTypeEnum) {
      case BaseButtonTypeEnum.buttonTypeSecondary:
        return (isDisabled || isLoading) ? ColorManager.primaryCream.withAlpha(102) : ColorManager.primaryCream;
      case BaseButtonTypeEnum.buttonTypeText:
      case BaseButtonTypeEnum.buttonTypeOutline:
        return ColorManager.colorWhite;
      case BaseButtonTypeEnum.buttonTypeBlack:
        return (isDisabled || isLoading) ? ColorManager.textColor.withAlpha(102) : ColorManager.textColor;
      default:
        return (isDisabled || isLoading) ? primaryColor.withAlpha(102) : primaryColor;
    }
  }

  Color? _getBorderColor() {
    if (borderColor != null) return borderColor;

    switch (buttonTypeEnum) {
      case BaseButtonTypeEnum.buttonTypeSecondary:
        return ColorManager.primaryColor;
      case BaseButtonTypeEnum.buttonTypeOutline:
        return ColorManager.colorText70;
      default:
        return null;
    }
  }

  Color _getIconColor(Color primaryColor) {
    if (buttonTypeEnum == BaseButtonTypeEnum.buttonTypeSecondary) {
      return primaryColor;
    }
    return Colors.white;
  }
}

enum BaseButtonTypeEnum {
  buttonTypeSecondary,
  buttonTypePrimary,
  buttonTypeGradient,
  buttonTypeOutline,
  buttonTypeBlack,
  buttonTypeText,
}
