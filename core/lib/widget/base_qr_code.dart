import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../constants/color_manager.dart';

/// Renders [data] as a scannable QR code inside a bordered card, e.g. for a
/// UPI payment deep link.
class BaseQrCode extends StatelessWidget {
  final String data;
  final double size;

  const BaseQrCode({super.key, required this.data, this.size = 200});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ColorManager.colorWhite,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: ColorManager.colorText20),
      ),
      child: QrImageView(
        data: data,
        version: QrVersions.auto,
        size: size,
        backgroundColor: ColorManager.colorWhite,
      ),
    );
  }
}