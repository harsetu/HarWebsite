import 'package:core/constants/color_manager.dart';
import 'package:core/widget/base_button.dart';
import 'package:core/widget/base_text_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../routing/app_route.dart';
import 'responsive_center.dart';

class SiteHeader extends StatelessWidget implements PreferredSizeWidget {
  const SiteHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isCompact = width < 720;
    final currentPath = GoRouterState.of(context).uri.path;

    return Material(
      color: ColorManager.colorWhite,
      elevation: 2,
      shadowColor: ColorManager.colorBlack.withAlpha(25),
      child: SafeArea(
        bottom: false,
        child: ResponsiveCenter(
          child: SizedBox(
            height: 72,
            child: Row(
              children: [
                InkWell(
                  onTap: () => context.go(AppRoute.home),
                  child: Row(
                    children: [
                      Image.asset('assets/images/logo.png', height: 40, fit: BoxFit.contain),
                    ],
                  ),
                ),
                const Spacer(),
                if (!isCompact) ...[
                  _NavLink(label: 'Home', route: AppRoute.home, isActive: currentPath == AppRoute.home),
                  const SizedBox(width: 28),
                  _NavLink(label: 'Our Product', route: AppRoute.ourProduct, isActive: currentPath == AppRoute.ourProduct),
                  const SizedBox(width: 28),
                ],
                BaseButton(
                  buttonText: 'Get in touch',
                  buttonVerticalPadding: 12,
                  buttonHorizontalPadding: 20,
                  buttonRadius: 24,
                  onPressed: () => context.go(AppRoute.contact),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(72);
}

class _NavLink extends StatelessWidget {
  final String label;
  final String route;
  final bool isActive;

  const _NavLink({required this.label, required this.route, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.go(route),
      child: BaseTextView(
        text: label,
        isLocalizeText: false,
        useAutoTranslation: false,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: isActive ? ColorManager.primaryColor : ColorManager.textColor,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            ),
      ),
    );
  }
}