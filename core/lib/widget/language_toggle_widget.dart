import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/color_manager.dart';
import '../constants/localization_keys.dart';
import 'base_text_view.dart';
import 'language_selector_widget.dart';

/// Display mode for the language toggle widget
enum LanguageToggleMode {
  /// Shows language switch icon
  icon,

  /// Shows current language code (EN/HI)
  text,
}

/// A reusable language toggle widget that provides a circular button to switch between supported languages.
///
/// This widget automatically rebuilds the entire screen when language changes due to EasyLocalization's
/// context.setLocale() which triggers a rebuild of all widgets that depend on localization.
///
/// **Industry Standard Approach:**
/// - Uses EasyLocalization's built-in rebuild mechanism
/// - No need for additional state management (BLoC/Provider) for language changes
/// - Follows Material Design guidelines for language switcher UI
/// - Consistent with existing project architecture
///
/// **Usage:**
/// ```dart
/// // In AppBar actions
/// actions: [
///   LanguageToggleWidget(),
/// ],
///
/// // Custom styling
/// LanguageToggleWidget(
///   size: 45,
///   backgroundColor: Colors.blue,
///   iconSize: 22,
/// ),
///
/// // With margin
/// LanguageToggleWidget(
///   margin: EdgeInsets.only(right: 16),
/// ),
/// ```
class LanguageToggleWidget extends StatelessWidget {
  /// Size of the circular container (both width and height)
  final double size;

  /// Background color of the circular container
  /// If null, defaults to Color(0xFFF5F5F5)
  final Color? backgroundColor;

  /// Size of the language switch icon
  final double iconSize;

  /// External margin around the widget
  final EdgeInsetsGeometry? margin;

  /// Custom callback that gets called after language change (optional)
  /// Useful for analytics tracking or additional logic
  final VoidCallback? onLanguageChanged;

  /// Whether to show a subtle elevation/shadow
  final bool hasElevation;

  const LanguageToggleWidget({
    super.key,
    this.size = 40,
    this.backgroundColor = ColorManager.primaryMercury100,
    this.iconSize = 20,
    this.margin,
    this.onLanguageChanged,
    this.hasElevation = false,
  });

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Container(
      margin: margin,
      child: GestureDetector(
        onTap: () => _showLanguageSelector(context, textTheme),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: backgroundColor,
            shape: BoxShape.circle,
            boxShadow: hasElevation
                ? [BoxShadow(color: ColorManager.colorBlack.withAlpha(15), offset: const Offset(0, 2), blurRadius: 4, spreadRadius: 0)]
                : null,
          ),
          child: Center(
            //TODO need to see how to use IconManager
            child: SvgPicture.asset(
              "IconManager.icLanguageSwitch",
              width: iconSize,
              height: iconSize,
              colorFilter: ColorFilter.mode(ColorManager.primaryColor, BlendMode.srcIn),
            ),
          ),
        ),
      ),
    );
  }

  void _showLanguageSelector(BuildContext context, TextTheme textTheme) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Icon(Icons.language, color: ColorManager.primaryColor),
                  SizedBox(width: 12),
                  Expanded(
                    child: BaseTextView(
                      text: LocalizationKeys.selectLanguageLabel,
                      maxLines: 3,
                      useAutoTranslation: false,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleLarge?.copyWith(color: ColorManager.primaryColor),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close, color: Colors.grey.shade600),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.6),
                child: LanguageSelectorWidget(
                  showNativeNames: true,
                  onLanguageChanged: (languageCode) {
                    // Language change is handled by the widget itself
                    // This callback is just for additional actions if needed
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: BaseTextView(
                          text: 'All text will now be translated to the selected language',
                          isLocalizeText: false,
                          useAutoTranslation: false,
                        ),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
