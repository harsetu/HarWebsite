import 'package:core/widget/base_screen.dart';
import 'package:flutter/material.dart';

import '../../constants/site_content.dart';
import '../../widgets/legal_page_layout.dart';

class TermsConditionsPage extends BaseStatelessWidget {
  const TermsConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const LegalPageLayout(
      title: 'Terms & Conditions',
      lastUpdated: 'September 3, 2026',
      sections: [
        LegalSection(
          heading: '1. Acceptance of Terms',
          body:
              'By accessing this website or engaging ${SiteContent.companyName} for app '
              'development, web development, digital SEO, or Har Setu related services, you '
              'agree to these Terms & Conditions. If you do not agree, please do not use '
              'this website or our services.',
        ),
        LegalSection(
          heading: '2. Our Services',
          body:
              '${SiteContent.companyName} provides custom app development, web development, '
              'and digital SEO services to clients, and develops and maintains Har Setu, an '
              'in-house trust management system. Specific scope, timelines, and pricing for '
              'client project work are agreed separately in writing (e.g. a proposal or '
              'service agreement) before work begins.',
        ),
        LegalSection(
          heading: '3. Enquiries & Communication',
          body:
              'Submitting the enquiry form on this website does not create a binding '
              'contract. It is a request for us to contact you about a potential project. '
              'Engagement terms are finalised only once both parties agree in writing.',
        ),
        LegalSection(
          heading: '4. Intellectual Property',
          body:
              'Unless otherwise agreed in a signed contract, all content on this website — '
              'including the ${SiteContent.companyName} name, logo, and Har Setu branding — '
              'is our property and may not be copied or reused without permission. '
              'Ownership of deliverables built for clients is governed by the applicable '
              'project agreement.',
        ),
        LegalSection(
          heading: '5. Har Setu Usage',
          body:
              'Trusts and devotees using the Har Setu system agree to provide accurate '
              'information for tokens, donations, room bookings, yatra registrations, and '
              'puja bookings. Misuse of the system, including fraudulent donation or booking '
              'entries, may result in suspension of access.',
        ),
        LegalSection(
          heading: '6. Limitation of Liability',
          body:
              'We strive for accuracy and reliability in everything we build, but our '
              'services and this website are provided "as is" without warranties of any '
              'kind. To the extent permitted by law, ${SiteContent.companyName} is not '
              'liable for indirect or consequential losses arising from use of our website, '
              'products, or services.',
        ),
        LegalSection(
          heading: '7. Changes to These Terms',
          body:
              'We may revise these Terms & Conditions from time to time. Continued use of '
              'this website after changes are posted constitutes acceptance of the revised '
              'terms.',
        ),
        LegalSection(
          heading: '8. Contact Us',
          body:
              'Questions about these Terms & Conditions can be sent to '
              '${SiteContent.contactEmail} or ${SiteContent.contactPhone}.',
        ),
      ],
    );
  }
}