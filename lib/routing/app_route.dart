/// Central registry of route path constants. Navigate via `context.go(AppRoute.x)`
/// and register each route's `GoRoute` against the same constant — never inline
/// route strings at call sites.
class AppRoute {
  AppRoute._();

  static const String home = '/';
  static const String ourProduct = '/our-product';
  static const String privacyPolicy = '/privacy-policy';
  static const String termsConditions = '/terms-conditions';
  static const String contact = '/contact';

  /// Deliberately not linked from the main nav — reachable only by URL.
  static const String flutterInternship = '/flutterinternship';
}
