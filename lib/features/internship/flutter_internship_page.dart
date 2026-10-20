import 'package:core/constants/color_manager.dart';
import 'package:core/widget/base_button.dart';
import 'package:core/widget/base_screen.dart';
import 'package:core/widget/base_text_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../constants/internship_content.dart';
import '../../routing/app_route.dart';
import '../../widgets/hover_lift.dart';
import '../../widgets/responsive_center.dart';
import '../../widgets/scroll_fade_in.dart';
import '../../widgets/site_scaffold.dart';

class FlutterInternshipPage extends BaseStatelessWidget {
  const FlutterInternshipPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SiteScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          _InternshipHero(),
          _PhasesSection(),
          _ClassFormatSection(),
          _SyllabusSection(),
          _ApplyCtaSection(),
        ],
      ),
    );
  }
}

class _InternshipHero extends StatelessWidget {
  const _InternshipHero();

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.sizeOf(context).width < 720;
    return Container(
      color: ColorManager.colorPrimaryDark,
      padding: EdgeInsets.symmetric(vertical: isCompact ? 56 : 88),
      child: ResponsiveCenter(
        maxWidth: 820,
        child: Column(
          children: [
            BaseTextView(
              text: InternshipContent.title,
              isLocalizeText: false,
              useAutoTranslation: false,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontSize: isCompact ? 28 : 36,
                color: ColorManager.colorWhite,
              ),
            ),
            const SizedBox(height: 16),
            BaseTextView(
              text: InternshipContent.tagline,
              isLocalizeText: false,
              useAutoTranslation: false,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: ColorManager.colorWhite.withAlpha(210),
              ),
            ),
            const SizedBox(height: 20),
            BaseTextView(
              text: InternshipContent.overview,
              isLocalizeText: false,
              useAutoTranslation: false,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: ColorManager.colorWhite.withAlpha(180),
              ),
            ),
            const SizedBox(height: 28),
            BaseButton(
              buttonText: 'Apply Now',
              buttonHorizontalPadding: 32,
              onPressed: () => context.go(AppRoute.contact),
            ),
          ],
        ),
      ),
    );
  }
}

class _PhasesSection extends StatelessWidget {
  const _PhasesSection();

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.sizeOf(context).width < 800;
    final phase1 = const _PhaseCard(
      badge: 'Phase 1',
      title: InternshipContent.phase1Title,
      duration: InternshipContent.phase1Duration,
      description: InternshipContent.phase1Description,
      icon: Icons.menu_book_outlined,
    );
    final phase2 = const _PhaseCard(
      badge: 'Phase 2',
      title: InternshipContent.phase2Title,
      duration: InternshipContent.phase2Duration,
      description: InternshipContent.phase2Description,
      icon: Icons.rocket_launch_outlined,
    );

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 64),
      child: ResponsiveCenter(
        // Expanded needs a bounded main-axis constraint — only safe in the
        // horizontal (desktop) case here; see _MissionVisionSection in
        // home_page.dart for the full explanation.
        child: isCompact
            ? Column(children: [phase1, const SizedBox(height: 24), phase2])
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: phase1),
                  const SizedBox(width: 24),
                  Expanded(child: phase2),
                ],
              ),
      ),
    );
  }
}

class _PhaseCard extends StatelessWidget {
  final String badge;
  final String title;
  final String duration;
  final String description;
  final IconData icon;

  const _PhaseCard({
    required this.badge,
    required this.title,
    required this.duration,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ScrollFadeIn(
      child: HoverLift(
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
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: ColorManager.primaryColor.withAlpha(30),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      icon,
                      color: ColorManager.primaryColor,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: ColorManager.primaryColor.withAlpha(20),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: BaseTextView(
                      text: '$badge · $duration',
                      isLocalizeText: false,
                      useAutoTranslation: false,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: ColorManager.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              BaseTextView(
                text: title,
                isLocalizeText: false,
                useAutoTranslation: false,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 10),
              BaseTextView(
                text: description,
                isLocalizeText: false,
                useAutoTranslation: false,
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

class _ClassFormatSection extends StatelessWidget {
  const _ClassFormatSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorManager.colorBackground,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: ResponsiveCenter(
        maxWidth: 820,
        child: ScrollFadeIn(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.event_available_outlined,
                color: ColorManager.primaryColor,
                size: 32,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BaseTextView(
                      text: InternshipContent.classFormatTitle,
                      isLocalizeText: false,
                      useAutoTranslation: false,
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: 8),
                    BaseTextView(
                      text: InternshipContent.classFormatDescription,
                      isLocalizeText: false,
                      useAutoTranslation: false,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: ColorManager.colorTextLight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SyllabusSection extends StatelessWidget {
  const _SyllabusSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 64),
      child: ResponsiveCenter(
        maxWidth: 820,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ScrollFadeIn(
              child: BaseTextView(
                text: 'Week-by-Week Syllabus',
                isLocalizeText: false,
                useAutoTranslation: false,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ),
            const SizedBox(height: 32),
            for (final week in InternshipContent.syllabus) ...[
              ScrollFadeIn(
                delay: Duration(milliseconds: (week.week - 1) * 40),
                child: _WeekTile(week: week),
              ),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }
}

class _WeekTile extends StatelessWidget {
  final InternshipWeek week;

  const _WeekTile({required this.week});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ColorManager.colorWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorManager.dividerColour),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: ColorManager.primaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: BaseTextView(
              text: '${week.week}',
              isLocalizeText: false,
              useAutoTranslation: false,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: ColorManager.colorWhite),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BaseTextView(
                  text: 'Week ${week.week}: ${week.title}',
                  isLocalizeText: false,
                  useAutoTranslation: false,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                for (final topic in week.topics)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 7),
                          child: Container(
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              color: ColorManager.primaryColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: BaseTextView(
                            text: topic,
                            isLocalizeText: false,
                            useAutoTranslation: false,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: ColorManager.colorTextLight),
                          ),
                        ),
                      ],
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

class _ApplyCtaSection extends StatelessWidget {
  const _ApplyCtaSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorManager.primaryColor,
      padding: const EdgeInsets.symmetric(vertical: 56),
      child: ResponsiveCenter(
        maxWidth: 720,
        child: Column(
          children: [
            BaseTextView(
              text: 'Ready to start?',
              isLocalizeText: false,
              useAutoTranslation: false,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: ColorManager.colorWhite,
              ),
            ),
            const SizedBox(height: 12),
            BaseTextView(
              text:
                  'Send us an enquiry and we\'ll get back to you with the next batch details.',
              isLocalizeText: false,
              useAutoTranslation: false,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: ColorManager.colorWhite.withAlpha(220),
              ),
            ),
            const SizedBox(height: 24),
            BaseButton(
              buttonText: 'Apply Now',
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
