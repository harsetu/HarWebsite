import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/contact/contact_page.dart';
import '../features/home/home_page.dart';
import '../features/internship/flutter_internship_page.dart';
import '../features/legal/privacy_policy_page.dart';
import '../features/legal/terms_conditions_page.dart';
import '../features/our_product/our_product_page.dart';
import 'app_route.dart';

/// A GoRoute whose transition is a simple cross-fade instead of the
/// platform's default slide-in — reads as a smoother, more "website-like"
/// page change than a mobile-style push animation.
CustomTransitionPage<void> _fadeTransitionPage(Widget child) {
  return CustomTransitionPage<void>(
    child: child,
    transitionDuration: const Duration(milliseconds: 250),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  );
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoute.home,
  routes: [
    GoRoute(
      path: AppRoute.home,
      pageBuilder: (context, state) => _fadeTransitionPage(const HomePage()),
    ),
    GoRoute(
      path: AppRoute.ourProduct,
      pageBuilder: (context, state) => _fadeTransitionPage(OurProductPage()),
    ),
    GoRoute(
      path: AppRoute.privacyPolicy,
      pageBuilder: (context, state) => _fadeTransitionPage(const PrivacyPolicyPage()),
    ),
    GoRoute(
      path: AppRoute.termsConditions,
      pageBuilder: (context, state) => _fadeTransitionPage(const TermsConditionsPage()),
    ),
    GoRoute(
      path: AppRoute.contact,
      pageBuilder: (context, state) => _fadeTransitionPage(const ContactPage()),
    ),
    // Not linked from the main nav — reachable only via its direct URL.
    GoRoute(
      path: AppRoute.flutterInternship,
      pageBuilder: (context, state) => _fadeTransitionPage(const FlutterInternshipPage()),
    ),
  ],
);