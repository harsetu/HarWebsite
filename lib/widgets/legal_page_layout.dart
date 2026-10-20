import 'package:core/constants/color_manager.dart';
import 'package:core/widget/base_text_view.dart';
import 'package:flutter/material.dart';

import 'responsive_center.dart';
import 'site_scaffold.dart';

class LegalSection {
  final String heading;
  final String body;

  const LegalSection({required this.heading, required this.body});
}

/// Shared layout for the Privacy Policy and Terms & Conditions pages:
/// a title, a last-updated line, and a sequence of heading/body sections.
class LegalPageLayout extends StatelessWidget {
  final String title;
  final String lastUpdated;
  final List<LegalSection> sections;

  const LegalPageLayout({
    super.key,
    required this.title,
    required this.lastUpdated,
    required this.sections,
  });

  @override
  Widget build(BuildContext context) {
    return SiteScaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 64),
        child: ResponsiveCenter(
          maxWidth: 820,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BaseTextView(
                text: title,
                isLocalizeText: false,
                useAutoTranslation: false,
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(height: 8),
              BaseTextView(
                text: 'Last updated: $lastUpdated',
                isLocalizeText: false,
                useAutoTranslation: false,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: ColorManager.colorTextLight,
                ),
              ),
              const SizedBox(height: 36),
              for (final section in sections) ...[
                BaseTextView(
                  text: section.heading,
                  isLocalizeText: false,
                  useAutoTranslation: false,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 10),
                BaseTextView(
                  text: section.body,
                  isLocalizeText: false,
                  useAutoTranslation: false,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: ColorManager.colorTextLight,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 28),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
