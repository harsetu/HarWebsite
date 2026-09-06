import 'dart:convert';

import 'package:flutter/material.dart';

/// Theme configuration models for the hk_package
/// Simplified to handle only the 4 core brand colors from app level

class ThemeConfig {
  final Color primary;
  final Color secondary;
  final Color error;
  final Color success;

  ThemeConfig({
    required this.primary,
    required this.secondary,
    required this.error,
    required this.success,
  });

  /// Parse theme configuration from simplified JSON structure
  /// Expected format: {"primary": "#800020", "secondary": "#0C73B9", "error": "#FF4F4F", "success": "#030450"}
  factory ThemeConfig.fromJson(Map<String, dynamic> json) {
    try {
      return ThemeConfig(
        primary: _parseColor(json['primary'], const Color(0xffB97912)),
        secondary: _parseColor(json['secondary'], const Color(0xffB97912)),
        error: _parseColor(json['error'], const Color(0xffFF4F4F)),
        success: _parseColor(json['success'], const Color(0xff030450)),
      );
    } catch (e) {
      throw Exception('Failed to parse ThemeConfig from JSON: $e');
    }
  }

  /// Parse configuration directly from JSON string
  static ThemeConfig fromJsonString(String jsonString) {
    try {
      final dynamic parsed = jsonDecode(jsonString);
      if (parsed is Map<String, dynamic>) {
        return ThemeConfig.fromJson(parsed);
      } else {
        throw Exception('JSON string does not contain a valid object');
      }
    } catch (e) {
      throw Exception('Failed to parse theme JSON string: $e');
    }
  }
}

/// Helper function to parse color from hex string with fallback
Color _parseColor(dynamic colorValue, Color fallback) {
  if (colorValue == null) return fallback;

  try {
    if (colorValue is String) {
      // Remove # if present and ensure it's 6 or 8 characters
      String hex = colorValue.replaceAll('#', '');

      if (hex.length == 6) {
        // Add alpha if not present
        hex = 'FF$hex';
      }

      if (hex.length == 8) {
        return Color(int.parse(hex, radix: 16));
      }
    }
  } catch (e) {
    // Return fallback if parsing fails
  }

  return fallback;
}
