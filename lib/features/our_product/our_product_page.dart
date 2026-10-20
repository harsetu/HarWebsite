import 'package:core/constants/color_manager.dart';
import 'package:core/widget/base_button.dart';
import 'package:core/widget/base_screen.dart';
import 'package:core/widget/base_text_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../constants/our_product_content.dart';
import '../../routing/app_route.dart';
import '../../widgets/hover_lift.dart';
import '../../widgets/responsive_center.dart';
import '../../widgets/scroll_fade_in.dart';
import '../../widgets/site_scaffold.dart';

/// Landing page for "Har Setu Connect" — the temple management system that
/// is our in-house flagship product. Reachable from the main nav's
/// "Our Product" link.
class OurProductPage extends BaseStatelessWidget {
  OurProductPage({super.key});

  final GlobalKey _whatIsSectionKey = GlobalKey();

  void _scrollToWhatIs() {
    final targetContext = _whatIsSectionKey.currentContext;
    if (targetContext == null) return;
    Scrollable.ensureVisible(
      targetContext,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SiteScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ProductHero(onExplore: _scrollToWhatIs),
          _WhatIsSection(key: _whatIsSectionKey),
          const _WhyHarSetuConnectSection(),
          const _FeatureGridSection(),
          const _HowItWorksSection(),
          const _AudienceSection(),
          const _EcosystemSection(),
          const _TechnologySection(),
          const _VisionSection(),
          const _DifferenceSection(),
          const _PurposeSection(),
          const _FinalCtaSection(),
        ],
      ),
    );
  }
}

class _ProductHero extends StatelessWidget {
  final VoidCallback onExplore;

  const _ProductHero({required this.onExplore});

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.sizeOf(context).width < 720;
    return Container(
      color: ColorManager.colorPrimaryDark,
      padding: EdgeInsets.symmetric(vertical: isCompact ? 56 : 96),
      child: ResponsiveCenter(
        maxWidth: 860,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: ColorManager.colorWhite.withAlpha(25),
                borderRadius: BorderRadius.circular(20),
              ),
              child: BaseTextView(
                text: OurProductContent.heroEyebrow.toUpperCase(),
                isLocalizeText: false,
                useAutoTranslation: false,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: ColorManager.colorWhite,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 20),
            BaseTextView(
              text: OurProductContent.heroTitle,
              isLocalizeText: false,
              useAutoTranslation: false,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontSize: isCompact ? 28 : 38,
                color: ColorManager.colorWhite,
              ),
            ),
            const SizedBox(height: 20),
            BaseTextView(
              text: OurProductContent.heroDescription,
              isLocalizeText: false,
              useAutoTranslation: false,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: ColorManager.colorWhite.withAlpha(210),
              ),
            ),
            const SizedBox(height: 16),
            BaseTextView(
              text: OurProductContent.heroTagline,
              isLocalizeText: false,
              useAutoTranslation: false,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: ColorManager.colorWhite.withAlpha(240),
              ),
            ),
            const SizedBox(height: 32),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 16,
              runSpacing: 16,
              children: [
                BaseButton(
                  buttonText: 'Explore Har Setu Connect',
                  bgColor: ColorManager.colorWhite,
                  textColor: ColorManager.colorPrimaryDark,
                  buttonHorizontalPadding: 28,
                  onPressed: onExplore,
                ),
                BaseButton(
                  buttonText: 'Request a Demo',
                  buttonTypeEnum: BaseButtonTypeEnum.buttonTypeOutline,
                  borderColor: ColorManager.colorWhite,
                  textColor: ColorManager.colorWhite,
                  bgColor: Colors.transparent,
                  buttonHorizontalPadding: 28,
                  onPressed: () => context.go(AppRoute.contact),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _WhatIsSection extends StatelessWidget {
  const _WhatIsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final columns = width < 640 ? 1 : (width < 960 ? 2 : 3);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 72),
      child: ResponsiveCenter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ScrollFadeIn(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 780),
                child: Column(
                  children: [
                    BaseTextView(
                      text: OurProductContent.whatIsTitle,
                      isLocalizeText: false,
                      useAutoTranslation: false,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    const SizedBox(height: 20),
                    for (final body in [
                      OurProductContent.whatIsBody1,
                      OurProductContent.whatIsBody2,
                      OurProductContent.whatIsBody3,
                    ]) ...[
                      BaseTextView(
                        text: body,
                        isLocalizeText: false,
                        useAutoTranslation: false,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: ColorManager.colorTextLight,
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 48),
            ScrollFadeIn(
              child: BaseTextView(
                text: OurProductContent.platformNeedsTitle,
                isLocalizeText: false,
                useAutoTranslation: false,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            const SizedBox(height: 28),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: OurProductContent.platformNeeds.asMap().entries.map((
                entry,
              ) {
                final chipWidth = (width - 96 - (columns - 1) * 12) / columns;
                return ScrollFadeIn(
                  delay: Duration(milliseconds: (entry.key % 6) * 60),
                  child: SizedBox(
                    width: columns == 1
                        ? double.infinity
                        : chipWidth.clamp(200, 340).toDouble(),
                    child: _PlatformNeedChip(text: entry.value),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlatformNeedChip extends StatelessWidget {
  final String text;

  const _PlatformNeedChip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: ColorManager.colorBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorManager.dividerColour),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 18,
            color: ColorManager.primaryColor,
          ),
          const SizedBox(width: 10),
          Flexible(
            child: BaseTextView(
              text: text,
              isLocalizeText: false,
              useAutoTranslation: false,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class _WhyHarSetuConnectSection extends StatelessWidget {
  const _WhyHarSetuConnectSection();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final columns = width < 720 ? 1 : (width < 1000 ? 2 : 3);

    return Container(
      color: ColorManager.colorBackground,
      padding: const EdgeInsets.symmetric(vertical: 72),
      child: ResponsiveCenter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const _SectionHeading(
              title: 'Why Har Setu Connect',
              subtitle: 'Built to make temple life simpler for everyone',
            ),
            const SizedBox(height: 40),
            Wrap(
              spacing: 24,
              runSpacing: 24,
              children: OurProductContent.whyReasons.asMap().entries.map((
                entry,
              ) {
                final cardWidth = (width - 96 - (columns - 1) * 24) / columns;
                return SizedBox(
                  width: columns == 1
                      ? double.infinity
                      : cardWidth.clamp(260, 400).toDouble(),
                  child: ScrollFadeIn(
                    delay: Duration(milliseconds: entry.key * 80),
                    child: _WhyReasonCard(
                      index: entry.key + 1,
                      reason: entry.value,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _WhyReasonCard extends StatelessWidget {
  final int index;
  final WhyReasonItem reason;

  const _WhyReasonCard({required this.index, required this.reason});

  @override
  Widget build(BuildContext context) {
    return HoverLift(
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: ColorManager.colorWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: ColorManager.dividerColour),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BaseTextView(
              text: index.toString().padLeft(2, '0'),
              isLocalizeText: false,
              useAutoTranslation: false,
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: ColorManager.primaryColor.withAlpha(90),
              ),
            ),
            const SizedBox(height: 12),
            BaseTextView(
              text: reason.title,
              isLocalizeText: false,
              useAutoTranslation: false,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 10),
            BaseTextView(
              text: reason.description,
              isLocalizeText: false,
              useAutoTranslation: false,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: ColorManager.colorTextLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

IconData _iconForFeature(String icon) {
  switch (icon) {
    case 'temple':
      return Icons.temple_hindu_outlined;
    case 'seva':
      return Icons.volunteer_activism_outlined;
    case 'token':
      return Icons.confirmation_number_outlined;
    case 'donation':
      return Icons.favorite_outline;
    case 'receipt':
      return Icons.receipt_long_outlined;
    case 'yatra':
      return Icons.hiking_outlined;
    case 'announcement':
      return Icons.campaign_outlined;
    case 'notification':
      return Icons.notifications_active_outlined;
    case 'reports':
      return Icons.insights_outlined;
    case 'devotee':
      return Icons.groups_outlined;
    default:
      return Icons.star_outline;
  }
}

class _FeatureGridSection extends StatelessWidget {
  const _FeatureGridSection();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final columns = width < 720 ? 1 : (width < 1000 ? 2 : 3);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 72),
      child: ResponsiveCenter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const _SectionHeading(
              title: 'What Can You Manage With Har Setu Connect?',
              subtitle: 'Every day-to-day temple need, covered',
            ),
            const SizedBox(height: 40),
            Wrap(
              spacing: 24,
              runSpacing: 24,
              children: OurProductContent.features.asMap().entries.map((entry) {
                final cardWidth = (width - 96 - (columns - 1) * 24) / columns;
                return SizedBox(
                  width: columns == 1
                      ? double.infinity
                      : cardWidth.clamp(260, 400).toDouble(),
                  child: ScrollFadeIn(
                    delay: Duration(milliseconds: (entry.key % 6) * 70),
                    child: _FeatureCard(feature: entry.value),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final FeatureItem feature;

  const _FeatureCard({required this.feature});

  @override
  Widget build(BuildContext context) {
    return HoverLift(
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: ColorManager.colorWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: ColorManager.dividerColour),
          boxShadow: [
            BoxShadow(
              color: ColorManager.colorBlack.withAlpha(10),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: ColorManager.primaryColor.withAlpha(30),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                _iconForFeature(feature.icon),
                color: ColorManager.primaryColor,
                size: 26,
              ),
            ),
            const SizedBox(height: 20),
            BaseTextView(
              text: feature.title,
              isLocalizeText: false,
              useAutoTranslation: false,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 10),
            BaseTextView(
              text: feature.description,
              isLocalizeText: false,
              useAutoTranslation: false,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: ColorManager.colorTextLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HowItWorksSection extends StatelessWidget {
  const _HowItWorksSection();

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.sizeOf(context).width < 900;
    return Container(
      color: ColorManager.colorBackground,
      padding: const EdgeInsets.symmetric(vertical: 72),
      child: ResponsiveCenter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const _SectionHeading(
              title: 'How Har Setu Connect Works',
              subtitle: 'A simple four-step journey',
            ),
            const SizedBox(height: 40),
            // See _MissionVisionSection in home_page.dart for why Expanded
            // can't be shared across both the horizontal and vertical layouts.
            if (isCompact)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (
                    int i = 0;
                    i < OurProductContent.howItWorks.length;
                    i++
                  ) ...[
                    ScrollFadeIn(
                      delay: Duration(milliseconds: i * 80),
                      child: _ProcessStepCard(
                        step: OurProductContent.howItWorks[i],
                        index: i + 1,
                      ),
                    ),
                    if (i != OurProductContent.howItWorks.length - 1)
                      const SizedBox(height: 24),
                  ],
                ],
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (
                    int i = 0;
                    i < OurProductContent.howItWorks.length;
                    i++
                  ) ...[
                    Expanded(
                      child: ScrollFadeIn(
                        delay: Duration(milliseconds: i * 80),
                        child: _ProcessStepCard(
                          step: OurProductContent.howItWorks[i],
                          index: i + 1,
                        ),
                      ),
                    ),
                    if (i != OurProductContent.howItWorks.length - 1)
                      const SizedBox(width: 16),
                  ],
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _ProcessStepCard extends StatelessWidget {
  final ProcessStepItem step;
  final int index;

  const _ProcessStepCard({required this.step, required this.index});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: ColorManager.primaryColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: BaseTextView(
            text: '$index',
            isLocalizeText: false,
            useAutoTranslation: false,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: ColorManager.colorWhite),
          ),
        ),
        const SizedBox(height: 16),
        BaseTextView(
          text: step.title,
          isLocalizeText: false,
          useAutoTranslation: false,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        BaseTextView(
          text: step.description,
          isLocalizeText: false,
          useAutoTranslation: false,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: ColorManager.colorTextLight),
        ),
      ],
    );
  }
}

class _AudienceSection extends StatelessWidget {
  const _AudienceSection();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final columns = width < 720 ? 1 : (width < 1000 ? 2 : 4);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 72),
      child: ResponsiveCenter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const _SectionHeading(
              title: 'Built For Temples & Trusts',
              subtitle:
                  'Designed to support every kind of religious organization',
            ),
            const SizedBox(height: 40),
            Wrap(
              spacing: 24,
              runSpacing: 24,
              children: OurProductContent.audiences.asMap().entries.map((
                entry,
              ) {
                final cardWidth = (width - 96 - (columns - 1) * 24) / columns;
                return SizedBox(
                  width: columns == 1
                      ? double.infinity
                      : cardWidth.clamp(220, 320).toDouble(),
                  child: ScrollFadeIn(
                    delay: Duration(milliseconds: entry.key * 80),
                    child: _AudienceCard(audience: entry.value),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _AudienceCard extends StatelessWidget {
  final AudienceItem audience;

  const _AudienceCard({required this.audience});

  @override
  Widget build(BuildContext context) {
    return HoverLift(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: ColorManager.colorBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: ColorManager.dividerColour),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BaseTextView(
              text: audience.title,
              isLocalizeText: false,
              useAutoTranslation: false,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 10),
            BaseTextView(
              text: audience.description,
              isLocalizeText: false,
              useAutoTranslation: false,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: ColorManager.colorTextLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EcosystemSection extends StatelessWidget {
  const _EcosystemSection();

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.sizeOf(context).width < 800;
    final nodes = OurProductContent.ecosystemFlow;

    return Container(
      color: ColorManager.colorBackground,
      padding: const EdgeInsets.symmetric(vertical: 72),
      child: ResponsiveCenter(
        maxWidth: 900,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const _SectionHeading(
              title: 'One Ecosystem. Multiple Experiences.',
              subtitle: '',
            ),
            const SizedBox(height: 40),
            ScrollFadeIn(
              child: isCompact
                  ? Column(
                      children: [
                        for (int i = 0; i < nodes.length; i++) ...[
                          _EcosystemNode(label: nodes[i]),
                          if (i != nodes.length - 1)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Icon(
                                Icons.arrow_downward,
                                color: ColorManager.primaryColor,
                              ),
                            ),
                        ],
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (int i = 0; i < nodes.length; i++) ...[
                          Expanded(child: _EcosystemNode(label: nodes[i])),
                          if (i != nodes.length - 1)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: Icon(
                                Icons.arrow_forward,
                                color: ColorManager.primaryColor,
                              ),
                            ),
                        ],
                      ],
                    ),
            ),
            const SizedBox(height: 32),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: BaseTextView(
                text: OurProductContent.ecosystemDescription,
                isLocalizeText: false,
                useAutoTranslation: false,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: ColorManager.colorTextLight,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EcosystemNode extends StatelessWidget {
  final String label;

  const _EcosystemNode({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: ColorManager.colorWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: ColorManager.dividerColour),
      ),
      child: BaseTextView(
        text: label,
        isLocalizeText: false,
        useAutoTranslation: false,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}

class _TechnologySection extends StatelessWidget {
  const _TechnologySection();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final columns = width < 640 ? 1 : (width < 960 ? 2 : 3);

    return Container(
      color: ColorManager.colorPrimaryDark,
      padding: const EdgeInsets.symmetric(vertical: 72),
      child: ResponsiveCenter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ScrollFadeIn(
              child: Column(
                children: [
                  BaseTextView(
                    text: 'Technology Behind Har Setu'.toUpperCase(),
                    isLocalizeText: false,
                    useAutoTranslation: false,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: ColorManager.colorWhite.withAlpha(200),
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  BaseTextView(
                    text: OurProductContent.technologyEyebrow,
                    isLocalizeText: false,
                    useAutoTranslation: false,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: ColorManager.colorWhite,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 640),
                    child: BaseTextView(
                      text: OurProductContent.technologyDescription,
                      isLocalizeText: false,
                      useAutoTranslation: false,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: ColorManager.colorWhite.withAlpha(210),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: OurProductContent.technologyCapabilities
                  .asMap()
                  .entries
                  .map((entry) {
                    final chipWidth =
                        (width - 96 - (columns - 1) * 16) / columns;
                    return ScrollFadeIn(
                      delay: Duration(milliseconds: (entry.key % 6) * 60),
                      child: SizedBox(
                        width: columns == 1
                            ? double.infinity
                            : chipWidth.clamp(220, 340).toDouble(),
                        child: _TechCapabilityChip(text: entry.value),
                      ),
                    );
                  })
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _TechCapabilityChip extends StatelessWidget {
  final String text;

  const _TechCapabilityChip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: ColorManager.colorWhite.withAlpha(18),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorManager.colorWhite.withAlpha(35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.bolt, size: 18, color: ColorManager.colorWhite),
          const SizedBox(width: 10),
          Flexible(
            child: BaseTextView(
              text: text,
              isLocalizeText: false,
              useAutoTranslation: false,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: ColorManager.colorWhite),
            ),
          ),
        ],
      ),
    );
  }
}

class _VisionSection extends StatelessWidget {
  const _VisionSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 72),
      child: ResponsiveCenter(
        maxWidth: 780,
        child: ScrollFadeIn(
          child: Column(
            children: [
              BaseTextView(
                text: 'Our Vision'.toUpperCase(),
                isLocalizeText: false,
                useAutoTranslation: false,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: ColorManager.primaryColor,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              BaseTextView(
                text: OurProductContent.visionTitle,
                isLocalizeText: false,
                useAutoTranslation: false,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(height: 20),
              BaseTextView(
                text: OurProductContent.visionBody1,
                isLocalizeText: false,
                useAutoTranslation: false,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: ColorManager.colorTextLight,
                ),
              ),
              const SizedBox(height: 4),
              BaseTextView(
                text: OurProductContent.visionBody2,
                isLocalizeText: false,
                useAutoTranslation: false,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: ColorManager.primaryColor,
                ),
              ),
              const SizedBox(height: 16),
              BaseTextView(
                text: OurProductContent.visionBody3,
                isLocalizeText: false,
                useAutoTranslation: false,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: ColorManager.colorTextLight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DifferenceSection extends StatelessWidget {
  const _DifferenceSection();

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.sizeOf(context).width < 800;
    final traditional = ScrollFadeIn(
      child: _DifferenceCard(
        title: 'Traditional Approach',
        items: OurProductContent.traditionalApproach,
        isHighlighted: false,
      ),
    );
    final withHarSetu = ScrollFadeIn(
      delay: const Duration(milliseconds: 100),
      child: _DifferenceCard(
        title: 'With Har Setu Connect',
        items: OurProductContent.withHarSetuConnect,
        isHighlighted: true,
      ),
    );

    return Container(
      color: ColorManager.colorBackground,
      padding: const EdgeInsets.symmetric(vertical: 72),
      child: ResponsiveCenter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const _SectionHeading(
              title: 'The Har Setu Difference',
              subtitle: 'Before and after digitizing temple operations',
            ),
            const SizedBox(height: 40),
            // See _MissionVisionSection in home_page.dart for why Expanded
            // can't be shared across both the horizontal and vertical layouts.
            isCompact
                ? Column(
                    children: [
                      traditional,
                      const SizedBox(height: 24),
                      withHarSetu,
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: traditional),
                      const SizedBox(width: 24),
                      Expanded(child: withHarSetu),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}

class _DifferenceCard extends StatelessWidget {
  final String title;
  final List<String> items;
  final bool isHighlighted;

  const _DifferenceCard({
    required this.title,
    required this.items,
    required this.isHighlighted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: isHighlighted
            ? ColorManager.primaryColor
            : ColorManager.colorWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isHighlighted
              ? ColorManager.primaryColor
              : ColorManager.dividerColour,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BaseTextView(
            text: title,
            isLocalizeText: false,
            useAutoTranslation: false,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: isHighlighted ? ColorManager.colorWhite : null,
            ),
          ),
          const SizedBox(height: 20),
          for (final item in items)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    isHighlighted
                        ? Icons.check_circle
                        : Icons.remove_circle_outline,
                    size: 18,
                    color: isHighlighted
                        ? ColorManager.colorWhite
                        : ColorManager.colorTextLight,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: BaseTextView(
                      text: item,
                      isLocalizeText: false,
                      useAutoTranslation: false,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isHighlighted
                            ? ColorManager.colorWhite.withAlpha(230)
                            : ColorManager.colorTextLight,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _PurposeSection extends StatelessWidget {
  const _PurposeSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 72),
      child: ResponsiveCenter(
        maxWidth: 780,
        child: ScrollFadeIn(
          child: Column(
            children: [
              BaseTextView(
                text: 'Built With Purpose'.toUpperCase(),
                isLocalizeText: false,
                useAutoTranslation: false,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: ColorManager.primaryColor,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              BaseTextView(
                text: OurProductContent.purposeTitle,
                isLocalizeText: false,
                useAutoTranslation: false,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(height: 20),
              BaseTextView(
                text: OurProductContent.purposeBody1,
                isLocalizeText: false,
                useAutoTranslation: false,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: ColorManager.colorTextLight,
                ),
              ),
              const SizedBox(height: 8),
              BaseTextView(
                text: OurProductContent.purposeBody2,
                isLocalizeText: false,
                useAutoTranslation: false,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: ColorManager.primaryColor,
                ),
              ),
              const SizedBox(height: 20),
              BaseTextView(
                text: OurProductContent.purposeBody3,
                isLocalizeText: false,
                useAutoTranslation: false,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: ColorManager.colorTextLight,
                ),
              ),
              const SizedBox(height: 4),
              BaseTextView(
                text: OurProductContent.purposeBody4,
                isLocalizeText: false,
                useAutoTranslation: false,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FinalCtaSection extends StatelessWidget {
  const _FinalCtaSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorManager.primaryColor,
      padding: const EdgeInsets.symmetric(vertical: 64),
      child: ResponsiveCenter(
        maxWidth: 720,
        child: Column(
          children: [
            BaseTextView(
              text: OurProductContent.finalCtaTitle,
              isLocalizeText: false,
              useAutoTranslation: false,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: ColorManager.colorWhite,
              ),
            ),
            const SizedBox(height: 12),
            BaseTextView(
              text: OurProductContent.finalCtaBody,
              isLocalizeText: false,
              useAutoTranslation: false,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: ColorManager.colorWhite.withAlpha(220),
              ),
            ),
            const SizedBox(height: 4),
            BaseTextView(
              text: OurProductContent.finalCtaTagline,
              isLocalizeText: false,
              useAutoTranslation: false,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: ColorManager.colorWhite),
            ),
            const SizedBox(height: 28),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 16,
              runSpacing: 16,
              children: [
                BaseButton(
                  buttonText: 'Request a Demo',
                  bgColor: ColorManager.colorWhite,
                  textColor: ColorManager.primaryColor,
                  buttonHorizontalPadding: 32,
                  onPressed: () => context.go(AppRoute.contact),
                ),
                BaseButton(
                  buttonText: 'Talk to Our Team',
                  buttonTypeEnum: BaseButtonTypeEnum.buttonTypeOutline,
                  borderColor: ColorManager.colorWhite,
                  textColor: ColorManager.colorWhite,
                  bgColor: Colors.transparent,
                  buttonHorizontalPadding: 32,
                  onPressed: () => context.go(AppRoute.contact),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionHeading({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return ScrollFadeIn(
      offset: 16,
      child: Column(
        children: [
          BaseTextView(
            text: title,
            isLocalizeText: false,
            useAutoTranslation: false,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displaySmall,
          ),
          if (subtitle.isNotEmpty) ...[
            const SizedBox(height: 8),
            BaseTextView(
              text: subtitle,
              isLocalizeText: false,
              useAutoTranslation: false,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: ColorManager.colorTextLight,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
