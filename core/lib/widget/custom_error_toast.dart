import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/color_manager.dart';
import 'base_text_view.dart';

enum ToastType {
  error,
  warning,
  success,
}

class CustomErrorToast extends StatefulWidget {
  final String message;
  final VoidCallback? onClose;
  final Duration duration;
  final ToastType type;

  const CustomErrorToast({
    super.key,
    required this.message,
    this.onClose,
    this.duration = const Duration(seconds: 4),
    this.type = ToastType.error,
  });

  @override
  State<CustomErrorToast> createState() => _CustomErrorToastState();
}

class _CustomErrorToastState extends State<CustomErrorToast> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _animateOut() async {
    await _controller.reverse();
    widget.onClose?.call();
  }

  Gradient _getGradient() {
    switch (widget.type) {
      case ToastType.error:
        return const LinearGradient(
          colors: [
            ColorManager.supportingRed800,
            ColorManager.colorRed500,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case ToastType.warning:
        return const LinearGradient(
          colors: [
            ColorManager.supportingWarning600,
            ColorManager.supportingWarning400,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case ToastType.success:
        return const LinearGradient(
          colors: [
            ColorManager.supportingSuccess700,
            ColorManager.supportingSuccess500,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }

  //TODO need to see how to use IconManager
  String _getIcon() {
    switch (widget.type) {
      case ToastType.error:
      case ToastType.warning:
        return "IconManager.icAlert";
      case ToastType.success:
        return "IconManager.icTick";
    }
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: _getGradient(),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Icon
              SvgPicture.asset(
                height: 22,
                width: 22,
                _getIcon(),
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),

              const SizedBox(width: 8),
              // Message text
              Expanded(
                child: BaseTextView(
                  text: widget.message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              // Close button
              GestureDetector(
                onTap: _animateOut,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Helper class for showing error toasts
class CustomErrorToastHelper {
  /// Show the error toast as an overlay
  static OverlayEntry? _currentOverlay;

  static void show(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 4),
    ToastType type = ToastType.error,
  }) {
    // Remove existing toast if any
    hide();

    final overlay = Overlay.of(context);
    _currentOverlay = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 10,
        left: 0,
        right: 0,
        child: Material(
          color: Colors.transparent,
          child: CustomErrorToast(
            message: message,
            duration: duration,
            type: type,
            onClose: hide,
          ),
        ),
      ),
    );

    overlay.insert(_currentOverlay!);

    // Auto-hide after duration
    Future.delayed(duration, () {
      hide();
    });
  }

  static void hide() {
    _currentOverlay?.remove();
    _currentOverlay = null;
  }

  // Convenience methods for different toast types
  static void showError(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 4),
  }) {
    show(context, message, duration: duration, type: ToastType.error);
  }

  static void showWarning(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 4),
  }) {
    show(context, message, duration: duration, type: ToastType.warning);
  }

  static void showSuccess(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 4),
  }) {
    show(context, message, duration: duration, type: ToastType.success);
  }
}
