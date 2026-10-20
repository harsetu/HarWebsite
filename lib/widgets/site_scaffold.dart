import 'package:core/constants/color_manager.dart';
import 'package:flutter/material.dart';

import 'site_footer.dart';
import 'site_header.dart';

/// Common page shell: header, scrollable body, footer. Every top-level page
/// on the site is built on top of this so navigation stays consistent.
class SiteScaffold extends StatelessWidget {
  final Widget body;

  const SiteScaffold({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.colorWhite,
      appBar: const SiteHeader(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [body, const SiteFooter()],
        ),
      ),
    );
  }
}
