import 'package:flutter/services.dart';

/// Enum defining the allowed input types for BaseEditText widget
enum AllowedInput {
  /// Allows all characters and symbols (default behavior)
  everything,

  /// Allows only numbers (0-9)
  numbersOnly,

  /// Allows numbers with decimal point
  decimal,

  /// Allows alphabetic characters only (a-z, A-Z)
  alphabetsOnly,

  /// Allows alphanumeric characters (a-z, A-Z, 0-9)
  alphanumeric,

  /// Allows phone number characters (0-9, +, -, (, ), space)
  phoneNumber,

  /// Allows email format characters (a-z, A-Z, 0-9, @, ., -, _)
  email,

  /// Allows alphabets with spaces
  alphabetsWithSpaces,

  /// Allows alphanumeric with spaces
  alphanumericWithSpaces,

  /// Date field that opens date picker and prevents keyboard input
  dateField,

  /// Date+time field that opens date picker then time picker, and prevents keyboard input
  dateTimeField,

  /// Time-only field that opens a time picker and prevents keyboard input
  timeField,

  /// Phone number input with country code picker UI
  phoneWithCountryCode,
}

/// Extension to get keyboard type for each allowed input
extension AllowedInputKeyboardExtension on AllowedInput {
  TextInputType get keyboardType {
    switch (this) {
      case AllowedInput.everything:
        return TextInputType.text;
      case AllowedInput.numbersOnly:
        return TextInputType.number;
      case AllowedInput.decimal:
        return const TextInputType.numberWithOptions(decimal: true);
      case AllowedInput.alphabetsOnly:
        return TextInputType.text;
      case AllowedInput.alphanumeric:
        return TextInputType.text;
      case AllowedInput.phoneNumber:
        return TextInputType.phone;
      case AllowedInput.email:
        return TextInputType.emailAddress;
      case AllowedInput.alphabetsWithSpaces:
        return TextInputType.text;
      case AllowedInput.alphanumericWithSpaces:
        return TextInputType.text;
      case AllowedInput.dateField:
        return TextInputType.none; // Prevents keyboard from showing
      case AllowedInput.dateTimeField:
        return TextInputType.none; // Prevents keyboard from showing
      case AllowedInput.timeField:
        return TextInputType.none; // Prevents keyboard from showing
      case AllowedInput.phoneWithCountryCode:
        return TextInputType.phone;
    }
  }
}

/// Extension to get regex pattern for input formatting
extension AllowedInputFormatterExtension on AllowedInput {
  String get regexPattern {
    switch (this) {
      case AllowedInput.everything:
        return r'[\s\S]'; // Matches any character including whitespace and newlines
      case AllowedInput.numbersOnly:
        return r'[0-9]';
      case AllowedInput.decimal:
        return r'[0-9.]';
      case AllowedInput.alphabetsOnly:
        return r'[a-zA-Z]';
      case AllowedInput.alphanumeric:
        return r'[a-zA-Z0-9]';
      case AllowedInput.phoneNumber:
        return r'[0-9+\-() ]';
      case AllowedInput.email:
        return r'[a-zA-Z0-9@.\-_]';
      case AllowedInput.alphabetsWithSpaces:
        return r'[a-zA-Z ]';
      case AllowedInput.alphanumericWithSpaces:
        return r'[a-zA-Z0-9 ]';
      case AllowedInput.dateField:
        return r'[\s\S]'; // Allow any character since date will be set programmatically
      case AllowedInput.dateTimeField:
        return r'[\s\S]'; // Allow any character since date/time will be set programmatically
      case AllowedInput.timeField:
        return r'[\s\S]'; // Allow any character since time will be set programmatically
      case AllowedInput.phoneWithCountryCode:
        return r'[0-9+\-() ]'; // Same as phoneNumber since only the number part will be in the text field
    }
  }

  /// Returns the FilteringTextInputFormatter for this input type
  FilteringTextInputFormatter? get inputFormatter {
    // For 'everything', 'dateField', 'dateTimeField' and 'timeField', we don't need any formatter
    if (this == AllowedInput.everything ||
        this == AllowedInput.dateField ||
        this == AllowedInput.dateTimeField ||
        this == AllowedInput.timeField) {
      return null;
    }
    return FilteringTextInputFormatter.allow(RegExp(regexPattern));
  }
}

/// Extension to get default length constraints for each input type
extension AllowedInputLengthExtension on AllowedInput {
  /// Default minimum length for this input type
  int get defaultMinLength {
    switch (this) {
      case AllowedInput.everything:
        return 0;
      case AllowedInput.numbersOnly:
        return 0;
      case AllowedInput.decimal:
        return 0;
      case AllowedInput.alphabetsOnly:
        return 0;
      case AllowedInput.alphanumeric:
        return 0;
      case AllowedInput.phoneNumber:
        return 8; // Minimum phone number length
      case AllowedInput.email:
        return 0; // Email can be very short like "a@b.c"
      case AllowedInput.alphabetsWithSpaces:
        return 0;
      case AllowedInput.alphanumericWithSpaces:
        return 0;
      case AllowedInput.dateField:
        return 0; // Date is set programmatically, no minimum length required
      case AllowedInput.dateTimeField:
        return 0; // Date/time is set programmatically, no minimum length required
      case AllowedInput.timeField:
        return 0; // Time is set programmatically, no minimum length required
      case AllowedInput.phoneWithCountryCode:
        return 8; // Minimum phone number length (same as phoneNumber)
    }
  }

  /// Default maximum length for this input type (null means no limit)
  int? get defaultMaxLength {
    switch (this) {
      case AllowedInput.everything:
        return null; // No limit
      case AllowedInput.numbersOnly:
        return null; // No limit
      case AllowedInput.decimal:
        return null; // No limit
      case AllowedInput.alphabetsOnly:
        return null; // No limit
      case AllowedInput.alphanumeric:
        return null; // No limit
      case AllowedInput.phoneNumber:
        return 15; // Maximum phone number length (including country code)
      case AllowedInput.email:
        return 255; // RFC 5321 limit for email addresses
      case AllowedInput.alphabetsWithSpaces:
        return null; // No limit
      case AllowedInput.alphanumericWithSpaces:
        return null; // No limit
      case AllowedInput.dateField:
        return null; // No limit - date format is controlled by the date picker
      case AllowedInput.dateTimeField:
        return null; // No limit - date/time format is controlled by the pickers
      case AllowedInput.timeField:
        return null; // No limit - time format is controlled by the picker
      case AllowedInput.phoneWithCountryCode:
        return 15; // Maximum phone number length (same as phoneNumber)
    }
  }

  /// Validates if the given text length is within the allowed range
  bool isLengthValid(String text, {int? customMinLength, int? customMaxLength}) {
    final minLength = customMinLength ?? defaultMinLength;
    final maxLength = customMaxLength ?? defaultMaxLength;

    if (text.length < minLength) {
      return false;
    }

    if (maxLength != null && text.length > maxLength) {
      return false;
    }

    return true;
  }

  /// Gets the error message for length validation
  String? getLengthErrorMessage(String text, {int? customMinLength, int? customMaxLength}) {
    final minLength = customMinLength ?? defaultMinLength;
    final maxLength = customMaxLength ?? defaultMaxLength;

    if (text.length < minLength) {
      if (minLength == 1) {
        return 'This field is required';
      }
      return 'Minimum $minLength characters required';
    }

    if (maxLength != null && text.length > maxLength) {
      return 'Maximum $maxLength characters allowed';
    }

    return null;
  }
}

/// Extension to get display name for each allowed input (for debugging/documentation)
extension AllowedInputDisplayExtension on AllowedInput {
  String get displayName {
    switch (this) {
      case AllowedInput.everything:
        return 'Everything';
      case AllowedInput.numbersOnly:
        return 'Numbers Only';
      case AllowedInput.decimal:
        return 'Decimal Numbers';
      case AllowedInput.alphabetsOnly:
        return 'Alphabets Only';
      case AllowedInput.alphanumeric:
        return 'Alphanumeric';
      case AllowedInput.phoneNumber:
        return 'Phone Number';
      case AllowedInput.email:
        return 'Email';
      case AllowedInput.alphabetsWithSpaces:
        return 'Alphabets with Spaces';
      case AllowedInput.alphanumericWithSpaces:
        return 'Alphanumeric with Spaces';
      case AllowedInput.dateField:
        return 'Date Field';
      case AllowedInput.dateTimeField:
        return 'Date Time Field';
      case AllowedInput.timeField:
        return 'Time Field';
      case AllowedInput.phoneWithCountryCode:
        return 'Phone with Country Code';
    }
  }
}
