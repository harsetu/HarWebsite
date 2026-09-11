/// Marketing copy shared across pages, kept in one place so it's easy to update.
class SiteContent {
  SiteContent._();

  static const String companyName = 'HarSetu Tech';
  static const String tagline = 'Building digital bridges for growing businesses';
  static const String heroTagline = 'Focus on Your Idea. For the Tech, We\'re Here.';
  static const String heroDescription =
      'HarSetu Tech is a startup software studio building app development, '
      'web development and digital SEO solutions for businesses — and the '
      'technology behind our own in-house product, the Har Setu trust '
      'management system.';

  static const String contactEmail = 'har.setu51@gmail.com';
  static const String contactPhone = '+91 9053230525';

  static const String instagramUrl = 'https://www.instagram.com/har.setu51/';
  static const String facebookUrl = 'https://www.facebook.com/profile.php?id=61591480475028';
  static const String linkedinUrl = 'https://www.linkedin.com/in/har-setu-35135742a/';

  /// Web app URL from the Google Apps Script deployment (see
  /// google_apps_script/Code.gs) that saves enquiries to a Google Sheet and
  /// emails a notification. Replace with your own deployment's URL.
  static const String contactFormEndpoint =
      'https://script.google.com/macros/s/AKfycbzhMaQHblvdK-NZbta0F2VxonObVCdf_2YJTqRQLT-PkgCsMcyN4TGv0eKjbsOX78bk/exec';

  static const String missionTitle = 'Our Mission';
  static const String missionBody =
      'To help businesses and institutions go digital without friction — by '
      'building reliable, easy-to-use apps and websites. We proved this '
      'approach on our own in-house product, Har Setu, a trust management '
      'system that replaced paper registers and manual queues at temples '
      'with simple digital tools for tokens, donations, room bookings, '
      'yatra coordination, announcements and puja bookings.';

  static const String visionTitle = 'Our Vision';
  static const String visionBody =
      'To be the technology partner of choice for startups, businesses and '
      'trusts across India — known for shipping dependable software fast, '
      'and for building products, like Har Setu, that make everyday '
      'operations simpler for the people who run them and the people they serve.';

  static const List<ServiceItem> services = [
    ServiceItem(
      icon: 'apps',
      title: 'App Development',
      description:
          'Native and cross-platform mobile apps for Android and iOS, from '
          'concept and design through to launch and support.',
    ),
    ServiceItem(
      icon: 'web',
      title: 'Web Development',
      description:
          'Fast, responsive websites and web applications built to convert '
          'visitors and scale with your business.',
    ),
    ServiceItem(
      icon: 'seo',
      title: 'Digital SEO',
      description:
          'Search-engine optimisation and digital marketing strategy to help '
          'your business get found and grow online.',
    ),
    ServiceItem(
      icon: 'backend',
      title: 'Backend Development',
      description:
          'Reliable APIs, databases and cloud infrastructure that power your '
          'apps and websites — built to scale with your business.',
    ),
  ];

  static const List<String> appScreenshots = [
    'assets/images/app_login.png',
    'assets/images/app_dashboard.png',
    'assets/images/app_token.png',
    'assets/images/app_donation.png',
    'assets/images/app_room_config.png',
  ];

  static const String projectTitle = 'Har Setu — Trust Management System';
  static const String projectDescription =
      'Our in-house product: a complete trust and temple management system '
      'covering devotee tokens, donations, room bookings, yatra scheduling, '
      'announcements and puja bookings — built end-to-end by our team.';

  static const List<String> projectHighlights = [
    'Token & queue management for devotees',
    'Donation collection with UPI and cash tracking',
    'Room / stay booking and configuration',
    'Yatra scheduling and coordination',
    'Announcements broadcast to devotees',
    'Puja booking and management',
  ];

  static const List<ValueItem> values = [
    ValueItem(
      icon: 'innovation',
      title: 'Innovation',
      description:
          'We stay ahead of the curve, adopting new tools and technologies to '
          'build solutions that give our clients a genuine edge.',
    ),
    ValueItem(
      icon: 'quality',
      title: 'Quality & Reliability',
      description:
          'We ship code we\'re proud of and stand behind it — dependable '
          'software, delivered on time, every time.',
    ),
    ValueItem(
      icon: 'learning',
      title: 'Continuous Learning',
      description:
          'Technology moves fast. We invest in learning constantly so our '
          'clients always get our best, most current thinking.',
    ),
  ];

  static const List<ProcessStep> process = [
    ProcessStep(
      title: 'Discover',
      description: 'We understand your goals, users, and constraints before writing a line of code.',
    ),
    ProcessStep(
      title: 'Design',
      description: 'Wireframes and UI/UX designs that make the solution intuitive and on-brand.',
    ),
    ProcessStep(
      title: 'Build',
      description: 'Agile development with regular check-ins, so you always know where things stand.',
    ),
    ProcessStep(
      title: 'Launch',
      description: 'Rigorous testing and a smooth rollout to production.',
    ),
    ProcessStep(
      title: 'Support',
      description: 'Ongoing maintenance, monitoring, and improvements after launch.',
    ),
  ];

  static const List<FaqItem> faqs = [
    FaqItem(
      question: 'How long does a typical project take?',
      answer:
          'It depends on scope — a simple website might take 2-3 weeks, while a full mobile app can take '
          '2-3 months. We\'ll give you a clear timeline after understanding your requirements.',
    ),
    FaqItem(
      question: 'What technologies do you work with?',
      answer:
          'We build cross-platform apps with Flutter, modern web stacks for websites, and integrate with '
          'cloud backends — choosing the right tool for each project rather than a one-size-fits-all stack.',
    ),
    FaqItem(
      question: 'How does pricing work?',
      answer:
          'We scope every project individually based on complexity and timeline, and share a clear quote '
          'upfront — no hidden costs.',
    ),
    FaqItem(
      question: 'What\'s the engagement model?',
      answer:
          'You can engage us for a fixed-scope project or on an ongoing retainer basis for continuous '
          'development and support.',
    ),
    FaqItem(
      question: 'Do you provide support after launch?',
      answer: 'Yes — we offer post-launch maintenance and support packages to keep your product running smoothly.',
    ),
  ];
}

class ServiceItem {
  final String icon;
  final String title;
  final String description;

  const ServiceItem({
    required this.icon,
    required this.title,
    required this.description,
  });
}

class ValueItem {
  final String icon;
  final String title;
  final String description;

  const ValueItem({
    required this.icon,
    required this.title,
    required this.description,
  });
}

class ProcessStep {
  final String title;
  final String description;

  const ProcessStep({
    required this.title,
    required this.description,
  });
}

class FaqItem {
  final String question;
  final String answer;

  const FaqItem({
    required this.question,
    required this.answer,
  });
}
