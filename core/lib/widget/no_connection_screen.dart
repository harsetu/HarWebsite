import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/localization_keys.dart';
import 'base_button.dart';

class NoConnectionScreen extends StatelessWidget {
  final VoidCallback? onRetry;
  static const String routeName = '/NoConnectionScreen';

  const NoConnectionScreen({super.key, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/res/images/connection_error.svg',
            ),
            const SizedBox(height: 20),
            const SizedBox(height: 10),
            const SizedBox(height: 20),
            BaseButton(buttonText: LocalizationKeys.tryAgainLabel, onPressed: onRetry)
          ],
        ),
      ),
    );
  }
}
