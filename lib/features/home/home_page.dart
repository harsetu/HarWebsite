import 'dart:async';

import 'package:core/constants/color_manager.dart';
import 'package:core/widget/base_button.dart';
import 'package:core/widget/base_screen.dart';
import 'package:core/widget/base_text_view.dart';
import 'package:core/widget/custom_page_indicator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../constants/site_content.dart';
import '../../routing/app_route.dart';
import '../../widgets/hover_lift.dart';
import '../../widgets/responsive_center.dart';
import '../../widgets/scroll_fade_in.dart';
import '../../widgets/site_scaffold.dart';

class HomePage extends BaseStatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SiteScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          _HeroSection(),
          _ServicesSection(),
          _MissionVisionSection(),
          _ValuesSection(),
          _HowWeWorkSection(),
          _ProjectShowcaseSection(),
          // _FaqSection(),
          // _CtaSection(),
        ],
      ),
    );
  }
}

/// Text-only hero — a single, punchy headline and supporting copy instead
/// of an image/banner pager, styled with the brand's dark-brown/gold
/// palette so it doesn't depend on banner artwork to feel premium.
class _HeroSection extends StatelessWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.sizeOf(context).width < 720;
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [ColorManager.colorPrimaryDark, ColorManager.colorBlack],
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: isCompact ? 64 : 100),
      child: ResponsiveCenter(
        maxWidth: 860,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: ColorManager.primaryColor.withAlpha(30),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: ColorManager.primaryColor.withAlpha(90)),
              ),
              child: BaseTextView(
                text: SiteContent.companyName.toUpperCase(),
                isLocalizeText: false,
                useAutoTranslation: false,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(color: ColorManager.primaryColor, letterSpacing: 1.2),
              ),
            ),
            const SizedBox(height: 24),
            BaseTextView(
              text: SiteContent.heroTagline,
              isLocalizeText: false,
              useAutoTranslation: false,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontSize: isCompact ? 30 : 42,
                    color: ColorManager.colorWhite,
                    height: 1.2,
                  ),
            ),
            const SizedBox(height: 20),
            BaseTextView(
              text: SiteContent.heroDescription,
              isLocalizeText: false,
              useAutoTranslation: false,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: ColorManager.colorWhite.withAlpha(200)),
            ),
            const SizedBox(height: 32),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 16,
              runSpacing: 16,
              children: [
                BaseButton(
                  buttonText: 'Get in Touch',
                  bgColor: ColorManager.primaryColor,
                  textColor: ColorManager.colorWhite,
                  buttonHorizontalPadding: 28,
                  onPressed: () => context.go(AppRoute.contact),
                ),
                BaseButton(
                  buttonText: 'Explore Har Setu Connect',
                  buttonTypeEnum: BaseButtonTypeEnum.buttonTypeOutline,
                  borderColor: ColorManager.colorWhite,
                  textColor: ColorManager.colorWhite,
                  bgColor: Colors.transparent,
                  buttonHorizontalPadding: 28,
                  onPressed: () => context.go(AppRoute.ourProduct),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

IconData _iconForService(String icon) {
  switch (icon) {
    case 'apps':
      return Icons.smartphone_outlined;
    case 'web':
      return Icons.language_outlined;
    case 'seo':
      return Icons.trending_up_outlined;
    case 'backend':
      return Icons.dns_outlined;
    default:
      return Icons.star_outline;
  }
}

/// One slide of the hero's service slider — stands in for a photo/screenshot
/// carousel with imagery drawn from what the company actually does, rather
/// than app screenshots.
class _HeroShowcaseCard extends StatelessWidget {
  final ServiceItem service;

  const _HeroShowcaseCard({required this.service});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ColorManager.primaryColor.withAlpha(230),
            ColorManager.colorPrimaryDark,
          ],
        ),
        border: Border.all(color: ColorManager.colorWhite.withAlpha(40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: ColorManager.colorWhite.withAlpha(35),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(_iconForService(service.icon), color: ColorManager.colorWhite, size: 28),
          ),
          const SizedBox(height: 24),
          BaseTextView(
            text: service.title,
            isLocalizeText: false,
            useAutoTranslation: false,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: ColorManager.colorWhite),
          ),
          const SizedBox(height: 10),
          BaseTextView(
            text: service.description,
            isLocalizeText: false,
            useAutoTranslation: false,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: ColorManager.colorWhite.withAlpha(200)),
          ),
        ],
      ),
    );
  }
}

/// Swipeable, auto-advancing slider for the hero — one service card visible
/// at a time (rather than a horizontal list showing neighbouring cards),
/// with a dot indicator beneath.
class _HeroShowcaseSlider extends StatefulWidget {
  final List<ServiceItem> services;

  const _HeroShowcaseSlider({required this.services});

  @override
  State<_HeroShowcaseSlider> createState() => _HeroShowcaseSliderState();
}

class _HeroShowcaseSliderState extends State<_HeroShowcaseSlider> {
  late final PageController _pageController;
  Timer? _timer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    if (widget.services.length > 1) {
      _timer = Timer.periodic(const Duration(seconds: 4), (_) => _goToNextPage());
    }
  }

  void _goToNextPage() {
    if (!_pageController.hasClients) return;
    final nextIndex = (_currentIndex + 1) % widget.services.length;
    _pageController.animateToPage(
      nextIndex,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.services.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.services.length,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemBuilder: (context, index) => _HeroShowcaseCard(service: widget.services[index]),
          ),
        ),
        if (widget.services.length > 1) ...[
          const SizedBox(height: 16),
          CustomPageIndicator(currentIndex: _currentIndex, count: widget.services.length),
        ],
      ],
    );
  }
}

class _ServicesSection extends StatelessWidget {
  const _ServicesSection();

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
            _SectionHeading(title: 'What We Do', subtitle: 'Services built for growing businesses'),
            const SizedBox(height: 40),
            Wrap(
              spacing: 24,
              runSpacing: 24,
              children: SiteContent.services.asMap().entries.map((entry) {
                final cardWidth = (width - 96 - (columns - 1) * 24) / columns;
                return SizedBox(
                  width: columns == 1 ? double.infinity : cardWidth.clamp(260, 400).toDouble(),
                  child: ScrollFadeIn(
                    delay: Duration(milliseconds: entry.key * 80),
                    child: _ServiceCard(service: entry.value),
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

class _ServiceCard extends StatelessWidget {
  final ServiceItem service;

  const _ServiceCard({required this.service});

  IconData get _icon => _iconForService(service.icon);

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
            BoxShadow(color: ColorManager.colorBlack.withAlpha(10), blurRadius: 16, offset: const Offset(0, 6)),
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
              child: Icon(_icon, color: ColorManager.primaryColor, size: 26),
            ),
            const SizedBox(height: 20),
            BaseTextView(
              text: service.title,
              isLocalizeText: false,
              useAutoTranslation: false,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 10),
            BaseTextView(
              text: service.description,
              isLocalizeText: false,
              useAutoTranslation: false,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: ColorManager.colorTextLight),
            ),
          ],
        ),
      ),
    );
  }
}

class _MissionVisionSection extends StatelessWidget {
  const _MissionVisionSection();

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.sizeOf(context).width < 800;
    final mission = const ScrollFadeIn(
      child: _MissionVisionCard(title: SiteContent.missionTitle, body: SiteContent.missionBody, icon: Icons.flag_outlined),
    );
    final vision = const ScrollFadeIn(
      delay: Duration(milliseconds: 100),
      child: _MissionVisionCard(title: SiteContent.visionTitle, body: SiteContent.visionBody, icon: Icons.visibility_outlined),
    );

    return Container(
      color: ColorManager.colorBackground,
      padding: const EdgeInsets.symmetric(vertical: 72),
      child: ResponsiveCenter(
        // Expanded needs a bounded main-axis constraint, which only holds in
        // the horizontal (desktop) case — inside the vertical/mobile Column
        // (itself in an unbounded scroll view) it would throw a render
        // overflow, so the two layouts are built explicitly instead of
        // sharing one Flex+Expanded tree.
        child: isCompact
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  mission,
                  const SizedBox(height: 24),
                  vision,
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: mission),
                  const SizedBox(width: 24),
                  Expanded(child: vision),
                ],
              ),
      ),
    );
  }
}

class _MissionVisionCard extends StatelessWidget {
  final String title;
  final String body;
  final IconData icon;

  const _MissionVisionCard({required this.title, required this.body, required this.icon});

  @override
  Widget build(BuildContext context) {
    return HoverLift(
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: ColorManager.colorWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: ColorManager.dividerColour),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: ColorManager.primaryColor, size: 32),
            const SizedBox(height: 16),
            BaseTextView(
              text: title,
              isLocalizeText: false,
              useAutoTranslation: false,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 12),
            BaseTextView(
              text: body,
              isLocalizeText: false,
              useAutoTranslation: false,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: ColorManager.colorTextLight),
            ),
          ],
        ),
      ),
    );
  }
}

class _ValuesSection extends StatelessWidget {
  const _ValuesSection();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final columns = width < 720 ? 1 : 3;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 72),
      child: ResponsiveCenter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const _SectionHeading(title: 'Our Values', subtitle: 'What drives how we work'),
            const SizedBox(height: 40),
            Wrap(
              spacing: 24,
              runSpacing: 24,
              children: SiteContent.values.asMap().entries.map((entry) {
                final cardWidth = (width - 96 - (columns - 1) * 24) / columns;
                return SizedBox(
                  width: columns == 1 ? double.infinity : cardWidth.clamp(260, 400).toDouble(),
                  child: ScrollFadeIn(
                    delay: Duration(milliseconds: entry.key * 80),
                    child: _ValueCard(value: entry.value),
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

class _ValueCard extends StatelessWidget {
  final ValueItem value;

  const _ValueCard({required this.value});

  IconData get _icon {
    switch (value.icon) {
      case 'innovation':
        return Icons.lightbulb_outline;
      case 'quality':
        return Icons.verified_outlined;
      case 'learning':
        return Icons.school_outlined;
      default:
        return Icons.star_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return HoverLift(
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: ColorManager.colorBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: ColorManager.dividerColour),
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
              child: Icon(_icon, color: ColorManager.primaryColor, size: 26),
            ),
            const SizedBox(height: 20),
            BaseTextView(
              text: value.title,
              isLocalizeText: false,
              useAutoTranslation: false,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 10),
            BaseTextView(
              text: value.description,
              isLocalizeText: false,
              useAutoTranslation: false,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: ColorManager.colorTextLight),
            ),
          ],
        ),
      ),
    );
  }
}

class _HowWeWorkSection extends StatelessWidget {
  const _HowWeWorkSection();

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
            const _SectionHeading(title: 'How We Work', subtitle: 'A clear process from idea to launch'),
            const SizedBox(height: 40),
            // See _MissionVisionSection for why Expanded can't be shared
            // across both the horizontal and vertical/mobile layouts here.
            if (isCompact)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (int i = 0; i < SiteContent.process.length; i++) ...[
                    ScrollFadeIn(
                      delay: Duration(milliseconds: i * 80),
                      child: _ProcessStepCard(step: SiteContent.process[i], index: i + 1),
                    ),
                    if (i != SiteContent.process.length - 1) const SizedBox(height: 24),
                  ],
                ],
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (int i = 0; i < SiteContent.process.length; i++) ...[
                    Expanded(
                      child: ScrollFadeIn(
                        delay: Duration(milliseconds: i * 80),
                        child: _ProcessStepCard(step: SiteContent.process[i], index: i + 1),
                      ),
                    ),
                    if (i != SiteContent.process.length - 1) const SizedBox(width: 16),
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
  final ProcessStep step;
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
            style: Theme.of(context).textTheme.titleLarge?.copyWith(color: ColorManager.colorWhite),
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
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: ColorManager.colorTextLight),
        ),
      ],
    );
  }
}

class _ProjectShowcaseSection extends StatelessWidget {
  const _ProjectShowcaseSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 72),
      child: ResponsiveCenter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const _SectionHeading(title: 'In-House Product', subtitle: SiteContent.projectTitle),
            const SizedBox(height: 16),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: BaseTextView(
                text: SiteContent.projectDescription,
                isLocalizeText: false,
                useAutoTranslation: false,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: ColorManager.colorTextLight),
              ),
            ),
            const SizedBox(height: 28),
            ScrollFadeIn(
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 12,
                runSpacing: 12,
                children: SiteContent.projectHighlights
                    .map((highlight) => _HighlightChip(text: highlight))
                    .toList(),
              ),
            ),
            const SizedBox(height: 40),
            ScrollFadeIn(
              delay: const Duration(milliseconds: 150),
              child: SizedBox(
                height: 420,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: SiteContent.appScreenshots.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 20),
                  itemBuilder: (context, index) => HoverLift(
                    liftPixels: 0,
                    scale: 1.03,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: ColorManager.dividerColour),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Image.asset(SiteContent.appScreenshots[index], height: 420, fit: BoxFit.cover),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HighlightChip extends StatelessWidget {
  final String text;

  const _HighlightChip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: ColorManager.primaryColor.withAlpha(20),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, size: 16, color: ColorManager.primaryColor),
          const SizedBox(width: 8),
          BaseTextView(
            text: text,
            isLocalizeText: false,
            useAutoTranslation: false,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _FaqSection extends StatelessWidget {
  const _FaqSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 72),
      child: ResponsiveCenter(
        maxWidth: 820,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const _SectionHeading(title: 'FAQ', subtitle: 'Frequently asked questions'),
            const SizedBox(height: 32),
            ...SiteContent.faqs.map((faq) => _FaqTile(faq: faq)),
          ],
        ),
      ),
    );
  }
}

class _FaqTile extends StatefulWidget {
  final FaqItem faq;

  const _FaqTile({required this.faq});

  @override
  State<_FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<_FaqTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: ColorManager.colorWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorManager.dividerColour),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: _isExpanded,
          onExpansionChanged: (expanded) => setState(() => _isExpanded = expanded),
          iconColor: ColorManager.primaryColor,
          collapsedIconColor: ColorManager.colorTextLight,
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          title: BaseTextView(
            text: widget.faq.question,
            isLocalizeText: false,
            useAutoTranslation: false,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          expandedAlignment: Alignment.topLeft,
          children: [
            BaseTextView(
              text: widget.faq.answer,
              isLocalizeText: false,
              useAutoTranslation: false,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: ColorManager.colorTextLight),
            ),
          ],
        ),
      ),
    );
  }
}

class _CtaSection extends StatelessWidget {
  const _CtaSection();

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
              text: 'Have a project in mind?',
              isLocalizeText: false,
              useAutoTranslation: false,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displaySmall?.copyWith(color: ColorManager.colorWhite),
            ),
            const SizedBox(height: 12),
            BaseTextView(
              text: 'Tell us about your app, website or SEO needs — we\'d love to help.',
              isLocalizeText: false,
              useAutoTranslation: false,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: ColorManager.colorWhite.withAlpha(220)),
            ),
            const SizedBox(height: 28),
            BaseButton(
              buttonText: 'Contact Us',
              bgColor: ColorManager.colorWhite,
              textColor: ColorManager.primaryColor,
              buttonHorizontalPadding: 32,
              onPressed: () => context.go(AppRoute.contact),
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
            text: title.toUpperCase(),
            isLocalizeText: false,
            useAutoTranslation: false,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(color: ColorManager.primaryColor, letterSpacing: 1.2),
          ),
          const SizedBox(height: 8),
          BaseTextView(
            text: subtitle,
            isLocalizeText: false,
            useAutoTranslation: false,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displaySmall,
          ),
        ],
      ),
    );
  }
}