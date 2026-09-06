import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../constants/color_manager.dart';
import 'base_text_view.dart';
import 'language_toggle_widget.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? handleBack;
  final String? title;
  final String? titleKey;
  final List<Widget>? actions;
  final double? elevation;
  final Color? backgroundColor;
  final bool showLanguageIcon;
  final bool hasGradient;
  final Color? languageToggleBackground;
  final Color? gradientStartColor;
  final Color? gradientEndColor;
  final PreferredSizeWidget? bottom;
  final bool showBackButton;
  final Widget? leadingWidget;

  /// Overrides the width of the [leading] slot (default ~56, per
  /// [AppBar.leadingWidth]) — needed when [leadingWidget] is larger than a
  /// standard icon, e.g. a wide logo.
  final double? leadingWidth;

  /// Overrides the app bar's height (default [kToolbarHeight]). Also feeds
  /// [preferredSize] so the [Scaffold] actually reserves the extra space,
  /// not just the inner [AppBar].
  final double? toolbarHeight;

  const BaseAppBar({
    super.key,
    this.actions,
    this.title,
    this.titleKey,
    this.handleBack,
    this.elevation,
    this.backgroundColor,
    this.showLanguageIcon = false,
    this.hasGradient = false,
    this.languageToggleBackground = ColorManager.primaryMercury100,
    this.gradientStartColor,
    this.gradientEndColor,
    this.bottom,
    this.showBackButton = true,
    this.leadingWidget,
    this.leadingWidth,
    this.toolbarHeight,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    // Build the default actions list
    List<Widget> appBarActions = [];

    // Add custom actions first
    if (actions != null) {
      appBarActions.addAll(actions!);
    }

    // Add language toggle if enabled
    if (showLanguageIcon) {
      appBarActions.add(
        Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: LanguageToggleWidget(
            size: 42,
            iconSize: 20,
            backgroundColor: languageToggleBackground ?? ColorManager.colorWhite,
            hasElevation: true,
          ),
        ),
      );
    }

    return AppBar(
      backgroundColor: hasGradient ? null : (backgroundColor ?? ColorManager.colorWhite),
      elevation: elevation ?? 4,
      shadowColor: hasGradient ? null : ColorManager.colorBlack.withAlpha(60),
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      leading: leadingWidget ??
          (showBackButton
              ? IconButton(
                  icon: Icon(Icons.arrow_back, color: ColorManager.primaryIconColor),
                  onPressed: handleBack,
                )
              : null),
      leadingWidth: leadingWidth,
      toolbarHeight: toolbarHeight,
      titleSpacing: 0,
      title: (titleKey != null)
          ? BaseTextView(text: tr(titleKey!), style: themeData.textTheme.titleMedium)
          : (title == null ? null : BaseTextView(text: title!, style: themeData.textTheme.titleMedium)),
      actions: appBarActions.isEmpty ? null : appBarActions,
      flexibleSpace: hasGradient
          ? Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topCenter,
                  radius: 30,
                  colors: [gradientStartColor ?? ColorManager.colorPeachNav, gradientEndColor ?? ColorManager.colorWhite],
                  stops: const [0.0, 0.1],
                ),
              ),
            )
          : null,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight((toolbarHeight ?? kToolbarHeight) + (bottom?.preferredSize.height ?? 0.0));
}
