import 'package:core/constants/color_manager.dart';
import 'package:core/widget/base_button.dart';
import 'package:core/widget/base_screen.dart';
import 'package:core/widget/base_text_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/site_content.dart';
import '../../routing/app_route.dart';
import '../../widgets/gentle_float.dart';
import '../../widgets/hover_lift.dart';
import '../../widgets/ornament_divider.dart';
import '../../widgets/responsive_center.dart';
import '../../widgets/scroll_fade_in.dart';
import '../../widgets/site_scaffold.dart';

const double _wideBreakpoint = 960;
const double _compactBreakpoint = 720;
const Color _inkDark = Color(0xFF1A0E05);
const Color _goldSoft = Color(0xFFE9B955);
const Color _parchment = Color(0xFFFBF6EC);

/// Classic serif for display headings; body copy keeps the app font.
TextStyle? _serif(TextStyle? base) =>
    GoogleFonts.playfairDisplay(textStyle: base, fontWeight: FontWeight.w700);

class HomePage extends BaseStatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SiteScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          _HeroSection(),
          _ProofStrip(),
          _ServicesSection(),
          _ProductSpotlightSection(),
          _MissionVisionSection(),
          _HowWeWorkSection(),
          _ValuesSection(),
          _CtaSection(),
        ],
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

IconData _iconForValue(String icon) {
  switch (icon) {
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

/// Dark hero with a warm gold glow, a two-tone headline and a pair of
/// overlapping phone screenshots of the in-house product on wide screens.
class _HeroSection extends StatelessWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isWide = width >= _wideBreakpoint;
    final isCompact = width < _compactBreakpoint;

    final copy = Column(
      crossAxisAlignment: isWide
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      children: [
        const ScrollFadeIn(
          offset: 12,
          child: _Eyebrow(label: SiteContent.companyName, onDark: true),
        ),
        const SizedBox(height: 24),
        ScrollFadeIn(
          delay: const Duration(milliseconds: 120),
          child: Text.rich(
            TextSpan(
              children: [
                const TextSpan(text: 'Focus on your idea.\n'),
                TextSpan(
                  text: 'For the tech, we\'re here.',
                  style: const TextStyle(color: _goldSoft),
                ),
              ],
            ),
            textAlign: isWide ? TextAlign.left : TextAlign.center,
            style: _serif(
              Theme.of(context).textTheme.displayMedium?.copyWith(
                fontSize: isCompact ? 34 : (isWide ? 56 : 46),
                height: 1.12,
                color: ColorManager.colorWhite,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        ScrollFadeIn(
          delay: const Duration(milliseconds: 260),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 540),
            child: BaseTextView(
              text: SiteContent.heroDescription,
              isLocalizeText: false,
              useAutoTranslation: false,
              textAlign: isWide ? TextAlign.left : TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: ColorManager.colorWhite.withAlpha(215),
                height: 1.6,
              ),
            ),
          ),
        ),
        const SizedBox(height: 32),
        ScrollFadeIn(
          delay: const Duration(milliseconds: 400),
          child: Wrap(
            alignment: isWide ? WrapAlignment.start : WrapAlignment.center,
            spacing: 16,
            runSpacing: 16,
            children: [
              BaseButton(
                buttonText: 'Start a project',
                bgColor: ColorManager.primaryColor,
                textColor: ColorManager.colorWhite,
                buttonHorizontalPadding: 28,
                onPressed: () => context.go(AppRoute.contact),
              ),
              BaseButton(
                buttonText: 'See Har Setu Connect',
                buttonTypeEnum: BaseButtonTypeEnum.buttonTypeOutline,
                borderColor: ColorManager.colorWhite.withAlpha(160),
                textColor: ColorManager.colorWhite,
                bgColor: Colors.transparent,
                buttonHorizontalPadding: 28,
                onPressed: () => context.go(AppRoute.ourProduct),
              ),
            ],
          ),
        ),
      ],
    );

    return Container(
      width: double.infinity,
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [ColorManager.colorPrimaryDark, _inkDark],
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: isCompact ? 56 : 96),
      child: Stack(
        children: [
          // Decorative glow behind the content.
          Positioned(
            right: -120,
            top: -140,
            child: IgnorePointer(
              child: Container(
                width: 520,
                height: 520,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      ColorManager.primaryColor.withAlpha(110),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
          ResponsiveCenter(
            child: isWide
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(flex: 6, child: copy),
                      const SizedBox(width: 48),
                      const Expanded(flex: 5, child: _HeroPhones()),
                    ],
                  )
                : copy,
          ),
        ],
      ),
    );
  }
}

class _HeroPhones extends StatelessWidget {
  const _HeroPhones();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 460,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 12,
            top: 40,
            child: GentleFloat(
              distance: 8,
              delay: const Duration(milliseconds: 600),
              child: _PhoneShot(
                asset: SiteContent.appScreenshots[1],
                height: 380,
                label: 'Har Setu dashboard screen',
              ),
            ),
          ),
          Positioned(
            right: 12,
            top: 0,
            child: GentleFloat(
              distance: 10,
              period: const Duration(milliseconds: 4600),
              child: _PhoneShot(
                asset: SiteContent.appScreenshots[2],
                height: 400,
                label: 'Har Setu token screen',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PhoneShot extends StatelessWidget {
  final String asset;
  final double height;
  final String label;

  const _PhoneShot({
    required this.asset,
    required this.height,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      image: true,
      label: label,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: ColorManager.colorWhite.withAlpha(60),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: ColorManager.colorBlack.withAlpha(120),
              blurRadius: 40,
              offset: const Offset(0, 20),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(26),
          child: Image.asset(asset, height: height, fit: BoxFit.cover),
        ),
      ),
    );
  }
}

/// Slim trust strip directly below the hero: facts drawn from the product.
class _ProofStrip extends StatelessWidget {
  const _ProofStrip();

  static const _items = [
    (Icons.verified_outlined, 'Shipped in-house product'),
    (Icons.phone_android_outlined, 'Android, iOS & Web'),
    (Icons.payments_outlined, 'UPI & cash donation tracking'),
    (Icons.support_agent_outlined, 'Post-launch support'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorManager.colorWhite,
      padding: const EdgeInsets.symmetric(vertical: 28),
      child: ResponsiveCenter(
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: 40,
          runSpacing: 16,
          children: [
            for (final item in _items)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ExcludeSemantics(
                    child: Icon(
                      item.$1,
                      size: 22,
                      color: ColorManager.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 10),
                  BaseTextView(
                    text: item.$2,
                    isLocalizeText: false,
                    useAutoTranslation: false,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: _inkDark,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _ServicesSection extends StatelessWidget {
  const _ServicesSection();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isWide = width >= _wideBreakpoint;
    final services = SiteContent.services;

    return Container(
      color: _parchment,
      padding: const EdgeInsets.symmetric(vertical: 88),
      child: ResponsiveCenter(
        child: Column(
          children: [
            const _SectionHeading(
              title: 'What we do',
              subtitle: 'Services built for growing businesses',
            ),
            const SizedBox(height: 48),
            if (isWide)
              // Bento layout: one featured card beside a 2x... stack.
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 5,
                      child: ScrollFadeIn(
                        child: _ServiceCard(
                          service: services[0],
                          featured: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      flex: 7,
                      child: Column(
                        children: [
                          for (int i = 1; i < services.length; i++) ...[
                            Expanded(
                              child: ScrollFadeIn(
                                delay: Duration(milliseconds: i * 80),
                                child: _ServiceCard(
                                  service: services[i],
                                  horizontal: true,
                                ),
                              ),
                            ),
                            if (i != services.length - 1)
                              const SizedBox(height: 24),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              )
            else
              Column(
                children: [
                  for (int i = 0; i < services.length; i++) ...[
                    ScrollFadeIn(
                      delay: Duration(milliseconds: i * 60),
                      child: _ServiceCard(service: services[i]),
                    ),
                    if (i != services.length - 1) const SizedBox(height: 16),
                  ],
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final ServiceItem service;
  final bool featured;
  final bool horizontal;

  const _ServiceCard({
    required this.service,
    this.featured = false,
    this.horizontal = false,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final fg = featured ? ColorManager.colorWhite : _inkDark;
    final bodyColor = featured
        ? ColorManager.colorWhite.withAlpha(215)
        : ColorManager.colorTextLight;

    final iconBox = Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: featured
            ? ColorManager.colorWhite.withAlpha(36)
            : ColorManager.primaryColor.withAlpha(30),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ExcludeSemantics(
        child: Icon(
          _iconForService(service.icon),
          size: 28,
          color: featured ? _goldSoft : ColorManager.primaryColor,
        ),
      ),
    );

    final text = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        BaseTextView(
          text: service.title,
          isLocalizeText: false,
          useAutoTranslation: false,
          style: _serif(
            (featured ? textTheme.headlineLarge : textTheme.headlineSmall)
                ?.copyWith(color: fg),
          ),
        ),
        const SizedBox(height: 10),
        BaseTextView(
          text: service.description,
          isLocalizeText: false,
          useAutoTranslation: false,
          style: textTheme.bodyMedium?.copyWith(color: bodyColor, height: 1.6),
        ),
      ],
    );

    return HoverLift(
      liftPixels: 4,
      scale: 1.01,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(featured ? 36 : 28),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: featured ? null : ColorManager.colorWhite,
          gradient: featured
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [ColorManager.colorPrimaryDark, _inkDark],
                )
              : null,
          border: Border.all(
            color: featured
                ? _goldSoft.withAlpha(120)
                : ColorManager.primaryColor.withAlpha(60),
          ),
          boxShadow: [
            BoxShadow(
              color: ColorManager.colorBlack.withAlpha(14),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: horizontal
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  iconBox,
                  const SizedBox(width: 20),
                  Expanded(child: text),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: featured
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                children: [
                  iconBox,
                  SizedBox(height: featured ? 80 : 20),
                  text,
                ],
              ),
      ),
    );
  }
}

/// Dark showcase for the in-house product: copy + highlights on one side,
/// a row of real app screenshots on the other.
class _ProductSpotlightSection extends StatelessWidget {
  const _ProductSpotlightSection();

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= _wideBreakpoint;

    final copy = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _Eyebrow(label: 'In-house product', onDark: true),
        const SizedBox(height: 20),
        BaseTextView(
          text: SiteContent.projectTitle,
          isLocalizeText: false,
          useAutoTranslation: false,
          style: _serif(
            Theme.of(context).textTheme.displaySmall?.copyWith(
              color: ColorManager.colorWhite,
              height: 1.2,
            ),
          ),
        ),
        const SizedBox(height: 16),
        BaseTextView(
          text: SiteContent.projectDescription,
          isLocalizeText: false,
          useAutoTranslation: false,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: ColorManager.colorWhite.withAlpha(215),
            height: 1.6,
          ),
        ),
        const SizedBox(height: 24),
        for (final highlight in SiteContent.projectHighlights)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ExcludeSemantics(
                  child: Icon(
                    Icons.check_circle_outline,
                    size: 20,
                    color: _goldSoft,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: BaseTextView(
                    text: highlight,
                    isLocalizeText: false,
                    useAutoTranslation: false,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: ColorManager.colorWhite,
                    ),
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 16),
        BaseButton(
          buttonText: 'Explore the product',
          bgColor: ColorManager.primaryColor,
          textColor: ColorManager.colorWhite,
          buttonHorizontalPadding: 28,
          onPressed: () => context.go(AppRoute.ourProduct),
        ),
      ],
    );

    final shots = SizedBox(
      height: 440,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: SiteContent.appScreenshots.length,
        separatorBuilder: (_, _) => const SizedBox(width: 16),
        itemBuilder: (context, index) => HoverLift(
          liftPixels: 6,
          scale: 1.02,
          child: _PhoneShot(
            asset: SiteContent.appScreenshots[index],
            height: 420,
            label: 'Har Setu app screenshot ${index + 1}',
          ),
        ),
      ),
    );

    return Container(
      color: _inkDark,
      padding: const EdgeInsets.symmetric(vertical: 88),
      child: ResponsiveCenter(
        child: ScrollFadeIn(
          child: isWide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(flex: 5, child: copy),
                    const SizedBox(width: 56),
                    Expanded(flex: 6, child: shots),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [copy, const SizedBox(height: 40), shots],
                ),
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
    const mission = ScrollFadeIn(
      child: _MissionVisionCard(
        title: SiteContent.missionTitle,
        body: SiteContent.missionBody,
        icon: Icons.flag_outlined,
      ),
    );
    const vision = ScrollFadeIn(
      delay: Duration(milliseconds: 100),
      child: _MissionVisionCard(
        title: SiteContent.visionTitle,
        body: SiteContent.visionBody,
        icon: Icons.visibility_outlined,
      ),
    );

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 88),
      child: ResponsiveCenter(
        // Expanded needs a bounded main axis, which only holds in the
        // horizontal layout, so the two layouts are built explicitly.
        child: isCompact
            ? const Column(children: [mission, SizedBox(height: 24), vision])
            : const IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: mission),
                    SizedBox(width: 24),
                    Expanded(child: vision),
                  ],
                ),
              ),
      ),
    );
  }
}

class _MissionVisionCard extends StatelessWidget {
  final String title;
  final String body;
  final IconData icon;

  const _MissionVisionCard({
    required this.title,
    required this.body,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(36),
      decoration: BoxDecoration(
        color: ColorManager.colorWhite,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: ColorManager.primaryColor.withAlpha(60)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: ColorManager.primaryColor.withAlpha(30),
              borderRadius: BorderRadius.circular(14),
            ),
            child: ExcludeSemantics(
              child: Icon(icon, color: ColorManager.primaryColor, size: 26),
            ),
          ),
          const SizedBox(height: 20),
          BaseTextView(
            text: title,
            isLocalizeText: false,
            useAutoTranslation: false,
            style: _serif(Theme.of(context).textTheme.headlineLarge),
          ),
          const SizedBox(height: 12),
          BaseTextView(
            text: body,
            isLocalizeText: false,
            useAutoTranslation: false,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: ColorManager.colorTextLight,
              height: 1.65,
            ),
          ),
        ],
      ),
    );
  }
}

/// Numbered timeline: a connector line runs behind the step markers on wide
/// screens; on narrow screens the steps stack vertically.
class _HowWeWorkSection extends StatelessWidget {
  const _HowWeWorkSection();

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.sizeOf(context).width < 900;
    final steps = SiteContent.process;

    return Container(
      color: _parchment,
      padding: const EdgeInsets.symmetric(vertical: 88),
      child: ResponsiveCenter(
        child: Column(
          children: [
            const _SectionHeading(
              title: 'How we work',
              subtitle: 'A clear process from idea to launch',
            ),
            const SizedBox(height: 48),
            if (isCompact)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (int i = 0; i < steps.length; i++) ...[
                    ScrollFadeIn(
                      delay: Duration(milliseconds: i * 60),
                      child: _ProcessStep(step: steps[i], index: i + 1),
                    ),
                    if (i != steps.length - 1) const SizedBox(height: 28),
                  ],
                ],
              )
            else
              Stack(
                children: [
                  Positioned(
                    left: 24,
                    right: 24,
                    top: 24,
                    child: Container(
                      height: 2,
                      color: ColorManager.primaryColor.withAlpha(60),
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (int i = 0; i < steps.length; i++) ...[
                        Expanded(
                          child: ScrollFadeIn(
                            delay: Duration(milliseconds: i * 80),
                            child: _ProcessStep(step: steps[i], index: i + 1),
                          ),
                        ),
                        if (i != steps.length - 1) const SizedBox(width: 20),
                      ],
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _ProcessStep extends StatelessWidget {
  final ProcessStep step;
  final int index;

  const _ProcessStep({required this.step, required this.index});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48,
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: ColorManager.primaryColor,
            shape: BoxShape.circle,
            border: Border.all(color: ColorManager.colorBackground, width: 4),
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
          style: _serif(Theme.of(context).textTheme.headlineSmall),
        ),
        const SizedBox(height: 8),
        BaseTextView(
          text: step.description,
          isLocalizeText: false,
          useAutoTranslation: false,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: ColorManager.colorTextLight,
            height: 1.55,
          ),
        ),
      ],
    );
  }
}

class _ValuesSection extends StatelessWidget {
  const _ValuesSection();

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.sizeOf(context).width < _compactBreakpoint;
    final values = SiteContent.values;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 88),
      child: ResponsiveCenter(
        child: Column(
          children: [
            const _SectionHeading(
              title: 'Our values',
              subtitle: 'What drives how we work',
            ),
            const SizedBox(height: 48),
            if (isCompact)
              Column(
                children: [
                  for (int i = 0; i < values.length; i++) ...[
                    ScrollFadeIn(child: _ValueTile(value: values[i])),
                    if (i != values.length - 1) const SizedBox(height: 16),
                  ],
                ],
              )
            else
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (int i = 0; i < values.length; i++) ...[
                      Expanded(
                        child: ScrollFadeIn(
                          delay: Duration(milliseconds: i * 80),
                          child: _ValueTile(value: values[i]),
                        ),
                      ),
                      if (i != values.length - 1) const SizedBox(width: 24),
                    ],
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ValueTile extends StatelessWidget {
  final ValueItem value;

  const _ValueTile({required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: ColorManager.primaryColor.withAlpha(14),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ColorManager.primaryColor.withAlpha(50)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ExcludeSemantics(
            child: Icon(
              _iconForValue(value.icon),
              size: 28,
              color: ColorManager.primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          BaseTextView(
            text: value.title,
            isLocalizeText: false,
            useAutoTranslation: false,
            style: _serif(Theme.of(context).textTheme.headlineSmall),
          ),
          const SizedBox(height: 8),
          BaseTextView(
            text: value.description,
            isLocalizeText: false,
            useAutoTranslation: false,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: ColorManager.colorTextLight,
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }
}

class _CtaSection extends StatelessWidget {
  const _CtaSection();

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.sizeOf(context).width < _compactBreakpoint;
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, isCompact ? 56 : 88),
      child: ResponsiveCenter(
        child: ScrollFadeIn(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: isCompact ? 24 : 64,
              vertical: isCompact ? 40 : 64,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [ColorManager.colorPrimaryDark, _inkDark],
              ),
            ),
            child: Column(
              children: [
                BaseTextView(
                  text: 'Have a project in mind?',
                  isLocalizeText: false,
                  useAutoTranslation: false,
                  textAlign: TextAlign.center,
                  style: _serif(
                    Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: ColorManager.colorWhite,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: BaseTextView(
                    text:
                        'Tell us about your app, website or SEO needs — we\'d love to help.',
                    isLocalizeText: false,
                    useAutoTranslation: false,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: ColorManager.colorWhite.withAlpha(220),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                BaseButton(
                  buttonText: 'Contact us',
                  bgColor: ColorManager.primaryColor,
                  textColor: ColorManager.colorWhite,
                  buttonHorizontalPadding: 36,
                  onPressed: () => context.go(AppRoute.contact),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Eyebrow extends StatelessWidget {
  final String label;
  final bool onDark;

  const _Eyebrow({required this.label, this.onDark = false});

  @override
  Widget build(BuildContext context) {
    final color = onDark ? _goldSoft : ColorManager.primaryColor;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: color.withAlpha(28),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withAlpha(90)),
      ),
      child: BaseTextView(
        text: label.toUpperCase(),
        isLocalizeText: false,
        useAutoTranslation: false,
        style: Theme.of(
          context,
        ).textTheme.labelLarge?.copyWith(color: color, letterSpacing: 1.2),
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
          _Eyebrow(label: title),
          const SizedBox(height: 16),
          BaseTextView(
            text: subtitle,
            isLocalizeText: false,
            useAutoTranslation: false,
            textAlign: TextAlign.center,
            style: _serif(Theme.of(context).textTheme.displaySmall),
          ),
          const SizedBox(height: 20),
          const OrnamentDivider(),
        ],
      ),
    );
  }
}
