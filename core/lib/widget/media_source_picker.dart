import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../constants/color_manager.dart';
import 'base_text_view.dart';

/// Reusable media source picker that shows a bottom sheet
/// allowing users to choose between Camera and Gallery
class MediaSourcePicker {
  /// Shows a bottom sheet to select image source (Camera or Gallery)
  /// Returns the selected [ImageSource] or null if cancelled
  static Future<ImageSource?> showImageSourcePicker(
    BuildContext context, {
    String? title,
  }) async {
    final themeData = Theme.of(context);
    return showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) {
        return Container(
          decoration: const BoxDecoration(
            color: ColorManager.colorWhite,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BaseTextView(
                text: title ?? 'Select Image Source',
                style: themeData.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: ColorManager.colorBlack,
                ),
              ),
              const SizedBox(height: 24),
              ListTile(
                leading: Icon(
                  Icons.camera_alt,
                  color: ColorManager.primaryColor,
                ),
                title: BaseTextView(
                  text: 'Camera',
                  style: themeData.textTheme.bodyLarge,
                ),
                onTap: () {
                  Navigator.pop(bottomSheetContext, ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.photo_library,
                  color: ColorManager.primaryColor,
                ),
                title: BaseTextView(
                  text: 'Gallery',
                  style: themeData.textTheme.bodyLarge,
                ),
                onTap: () {
                  Navigator.pop(bottomSheetContext, ImageSource.gallery);
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  /// Shows a bottom sheet to select video source (Camera or Gallery)
  /// Returns the selected [ImageSource] or null if cancelled
  static Future<ImageSource?> showVideoSourcePicker(
    BuildContext context, {
    String? title,
  }) async {
    final themeData = Theme.of(context);
    return showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) {
        return Container(
          decoration: const BoxDecoration(
            color: ColorManager.colorWhite,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title ?? 'Select Video Source',
                style: themeData.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: ColorManager.colorBlack,
                ),
              ),
              const SizedBox(height: 24),
              ListTile(
                leading: Icon(Icons.videocam, color: ColorManager.primaryColor),
                title: Text('Camera', style: themeData.textTheme.bodyLarge),
                onTap: () {
                  Navigator.pop(bottomSheetContext, ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.video_library,
                  color: ColorManager.primaryColor,
                ),
                title: Text('Gallery', style: themeData.textTheme.bodyLarge),
                onTap: () {
                  Navigator.pop(bottomSheetContext, ImageSource.gallery);
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
