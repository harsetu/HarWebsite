import 'package:core/constants/color_manager.dart';
import 'package:core/widget/base_svg_image.dart';
import 'package:core/widget/base_text_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/site_content.dart';
import '../routing/app_route.dart';
import 'responsive_center.dart';

class SiteFooter extends StatelessWidget {
  const SiteFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isCompact = width < 720;

    final about = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _footerText(context, SiteContent.companyName, isTitle: true),
        const SizedBox(height: 8),
        _footerText(context, SiteContent.tagline),
      ],
    );

    final company = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _footerText(context, 'Company', isTitle: true),
        const SizedBox(height: 12),
        _footerLink(context, 'Home', AppRoute.home),
        const SizedBox(height: 8),
        _footerLink(context, 'Our Product', AppRoute.ourProduct),
        const SizedBox(height: 8),
        _footerLink(context, 'Contact Us', AppRoute.contact),
      ],
    );

    final legal = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _footerText(context, 'Legal', isTitle: true),
        const SizedBox(height: 12),
        _footerLink(context, 'Privacy Policy', AppRoute.privacyPolicy),
        const SizedBox(height: 8),
        _footerLink(context, 'Terms & Conditions', AppRoute.termsConditions),
      ],
    );

    final connect = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _footerText(context, 'Get in touch', isTitle: true),
        const SizedBox(height: 12),
        _footerText(context, SiteContent.contactEmail),
        const SizedBox(height: 8),
        _footerText(context, SiteContent.contactPhone),
        const SizedBox(height: 16),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _SocialIconButton(assetPath: 'assets/images/icon_instagram.svg', url: SiteContent.instagramUrl),
            const SizedBox(width: 12),
            _SocialIconButton(assetPath: 'assets/images/icon_facebook.svg', url: SiteContent.facebookUrl),
            const SizedBox(width: 12),
            _SocialIconButton(assetPath: 'assets/images/icon_linkedin.svg', url: SiteContent.linkedinUrl),
          ],
        ),
      ],
    );

    return Container(
      color: ColorManager.colorPrimaryDark,
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: ResponsiveCenter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Expanded needs a bounded main-axis constraint, which only
            // holds in the horizontal (desktop) case — inside the
            // vertical/mobile Column (itself in an unbounded scroll view)
            // it would throw a render overflow, so the two layouts are
            // built explicitly instead of sharing one Flex+Expanded tree.
            if (isCompact)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  about,
                  const SizedBox(height: 28),
                  company,
                  const SizedBox(height: 28),
                  legal,
                  const SizedBox(height: 28),
                  connect,
                ],
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 2, child: about),
                  Expanded(child: company),
                  Expanded(child: legal),
                  Expanded(child: connect),
                ],
              ),
            const SizedBox(height: 32),
            Divider(color: ColorManager.colorWhite.withAlpha(40)),
            const SizedBox(height: 16),
            _footerText(context, '© 2026 ${SiteContent.companyName}. All rights reserved.'),
          ],
        ),
      ),
    );
  }

  Widget _footerText(BuildContext context, String text, {bool isTitle = false}) {
    return BaseTextView(
      text: text,
      isLocalizeText: false,
      useAutoTranslation: false,
      style: (isTitle ? Theme.of(context).textTheme.titleMedium : Theme.of(context).textTheme.bodyMedium)
          ?.copyWith(color: isTitle ? ColorManager.colorWhite : ColorManager.colorWhite.withAlpha(200)),
    );
  }

  Widget _footerLink(BuildContext context, String text, String route) {
    return InkWell(
      onTap: () => context.go(route),
      child: _footerText(context, text),
    );
  }
}

class _SocialIconButton extends StatelessWidget {
  final String assetPath;
  final String url;

  const _SocialIconButton({required this.assetPath, required this.url});

  Future<void> _open() => launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _open,
      customBorder: const CircleBorder(),
      child: Container(
        width: 44,
        height: 44,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: ColorManager.colorWhite.withAlpha(25),
        ),
        child: BaseSvgImage(assetPath: assetPath),
      ),
    );
  }
}