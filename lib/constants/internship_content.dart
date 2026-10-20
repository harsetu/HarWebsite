/// Content for the Flutter Development Internship page. Not linked from the
/// main navigation — reachable only via its direct URL.
class InternshipContent {
  InternshipContent._();

  static const String title = 'Flutter Development Internship';
  static const String tagline =
      'Learn Flutter from scratch, then build a real app with our team.';
  static const String overview =
      'An internship built in two parts: an 8-week, weekend-class Flutter '
      'course to take you from zero to job-ready, followed by 3/6 months '
      'building a real, live application alongside our team — the same way '
      'we built Har Setu.';

  static const String phase1Title = 'Phase 1 — Flutter Course';
  static const String phase1Duration = '8 weeks';
  static const String phase1Description =
      'A structured, week-by-week Flutter & Dart curriculum with weekend '
      'classes and hands-on practicals every week.';

  static const String phase2Title = 'Phase 2 — Real Application';
  static const String phase2Duration = '6 months';
  static const String phase2Description =
      'Work directly on a live application with our team — from '
      'requirements and UI to API integration, testing and deployment. '
      'This is real client/product work, not a toy project.';

  static const String classFormatTitle = 'Class Format';
  static const String classFormatDescription =
      'Weekend classes, 2 hours each, combining live teaching with hands-on '
      'coding. Every week also has a practical assignment to reinforce what '
      'was covered in class.';

  static const List<InternshipWeek> syllabus = [
    InternshipWeek(
      week: 1,
      title: 'Dart Fundamentals & Flutter Setup',
      topics: [
        'Dart basics: variables, functions, control flow, null safety',
        'Object-oriented Dart: classes, inheritance, mixins',
        'Installing Flutter SDK & setting up an editor',
        'Practical: your first "Hello World" Flutter app',
      ],
    ),
    InternshipWeek(
      week: 2,
      title: 'Flutter Widgets & Layout',
      topics: [
        'StatelessWidget vs StatefulWidget',
        'Layout widgets: Row, Column, Stack, Container, Expanded',
        'Styling: themes, colors, text styles',
        'Practical: build a static profile screen UI',
      ],
    ),
    InternshipWeek(
      week: 3,
      title: 'Navigation & Routing',
      topics: [
        'Navigator basics and named routes',
        'Declarative routing with go_router',
        'Passing data between screens',
        'Practical: multi-screen app with navigation',
      ],
    ),
    InternshipWeek(
      week: 4,
      title: 'State Management',
      topics: [
        'setState and when it falls short',
        'Intro to flutter_bloc / Cubit',
        'Separating UI from business logic',
        'Practical: a counter/todo app using Cubit',
      ],
    ),
    InternshipWeek(
      week: 5,
      title: 'Working with APIs',
      topics: [
        'HTTP requests with the http/dio packages',
        'JSON parsing and models',
        'Async/await, Futures and error handling',
        'Practical: fetch and display data from a public API',
      ],
    ),
    InternshipWeek(
      week: 6,
      title: 'Local Storage & Firebase',
      topics: [
        'SharedPreferences for simple local storage',
        'Firebase Authentication basics',
        'Firestore: reading and writing data',
        'Practical: a login flow backed by Firebase Auth',
      ],
    ),
    InternshipWeek(
      week: 7,
      title: 'Forms, Validation & Polish',
      topics: [
        'Forms and input validation',
        'Basic animations and transitions',
        'Responsive layouts across screen sizes',
        'Practical: a validated sign-up form',
      ],
    ),
    InternshipWeek(
      week: 8,
      title: 'Testing, Publishing & Capstone',
      topics: [
        'Widget testing basics',
        'Building a release APK',
        'Play Store publishing overview',
        'Capstone: present a mini-project built across the course',
      ],
    ),
  ];
}

class InternshipWeek {
  final int week;
  final String title;
  final List<String> topics;

  const InternshipWeek({
    required this.week,
    required this.title,
    required this.topics,
  });
}
