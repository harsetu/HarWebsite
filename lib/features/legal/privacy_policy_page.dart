import 'package:core/widget/base_screen.dart';
import 'package:flutter/material.dart';

import '../../constants/site_content.dart';
import '../../widgets/legal_page_layout.dart';

class PrivacyPolicyPage extends BaseStatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const LegalPageLayout(
      title: 'Privacy Policy',
      lastUpdated: 'September 3, 2026',
      sections: [
        LegalSection(
          heading: '1. Introduction',
          body:
              '${SiteContent.companyName} ("we", "us", "our") builds app development, web '
              'development and digital SEO solutions for clients, and operates our own '
              'in-house product, Har Setu, a trust management system. This Privacy Policy '
              'explains how we collect, use, and protect information when you visit this '
              'website, submit an enquiry, or use products we build, including Har Setu.',
        ),
        LegalSection(
          heading: '2. Information We Collect',
          body:
              'When you contact us through our enquiry form, we collect the details you '
              'provide — such as your name, email address, phone number, and the contents '
              'of your message. If you use Har Setu, we (or the trust operating it) may '
              'collect information such as your name, mobile number, and transaction '
              'details for tokens, donations, room bookings, yatra registrations, and puja '
              'bookings, solely to provide those services. We do not collect payment card '
              'details directly; donation payments are processed via UPI or recorded as '
              'cash by trust staff.',
        ),
        LegalSection(
          heading: '3. How We Use Your Information',
          body:
              'We use the information you share with us to respond to enquiries, discuss '
              'and deliver project work, and — for Har Setu — to operate the token, '
              'donation, room booking, yatra, announcement and puja features on behalf of '
              'the trust using the system. We do not sell your personal information to '
              'third parties.',
        ),
        LegalSection(
          heading: '4. Data Sharing',
          body:
              'We do not share your personal information with third parties except: (a) '
              'with your consent, (b) with service providers who help us operate our '
              'website or products (such as hosting and analytics providers) under '
              'confidentiality obligations, or (c) where required by law.',
        ),
        LegalSection(
          heading: '5. Data Retention & Security',
          body:
              'We retain enquiry and product data only as long as needed for the purposes '
              'described above, or as required by law, and take reasonable technical and '
              'organisational measures to protect it against unauthorised access, loss, or '
              'misuse.',
        ),
        LegalSection(
          heading: '6. Your Rights',
          body:
              'You may ask us to access, correct, or delete the personal information we '
              'hold about you by contacting us at ${SiteContent.contactEmail}. We will '
              'respond within a reasonable timeframe.',
        ),
        LegalSection(
          heading: '7. Changes to This Policy',
          body:
              'We may update this Privacy Policy from time to time. Material changes will '
              'be reflected by updating the "Last updated" date at the top of this page.',
        ),
        LegalSection(
          heading: '8. Contact Us',
          body:
              'If you have questions about this Privacy Policy, reach us at '
              '${SiteContent.contactEmail} or ${SiteContent.contactPhone}.',
        ),
      ],
    );
  }
}
