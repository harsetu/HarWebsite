import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import '../base_widget/base_calendar_dialog.dart';
import '../constants/color_manager.dart';
import '../constants/date_format_constants.dart';
import '../constants/localization_keys.dart';
import '../utils/allowed_input_enum.dart';
import '../utils/formatting_utils.dart';
import 'base_text_view.dart';

class BaseEditText extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final Color? hintTextColor;
  final String? labelText;
  final bool isPassword;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int? maxLines;
  final int? minLines;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final Widget? prefixWidget;
  final Widget? suffixWidget;
  final VoidCallback? onSuffixTap;
  final VoidCallback? onPrefixTap;
  final VoidCallback? onTap;
  final bool autoFocus;
  final bool isEditable;
  final int? maxLength; // Maximum length for TextFormField (used for character counter)
  final bool isError;
  final FocusNode? focusNode;
  final String? errorText;
  final bool disableContextMenu;
  final bool showBorder;
  final AllowedInput allowedInput; // Automatic input configuration (defaults to everything)
  final DateTime? minSelectableDate; // For AllowedInput.dateField: earliest pickable date (e.g. disallow past dates)
  final List<TextInputFormatter>? inputFormatters; // Custom input formatters
  final int? minLength; // Custom minimum length (overrides allowedInput default)
  final int? maxLengthCustom; // Custom maximum length (overrides allowedInput default)
  final double? height; // Height of the TextFormField container
  final bool expands; // Whether the field should expand to fill the height
  final Color? backgroundColor; // Background color of the TextFormField container
  // Country code picker properties (only used with phoneWithCountryCode)
  final String? initialCountryCode; // Initial country code (e.g., 'IN')
  final String? initialDialCode; // Initial dial code (e.g., '+91')
  final List<String>? countryCodeList; // List of allowed country codes
  final Function(String countryCode, String dialCode)? onCountryChanged; // Callback when country changes

  const BaseEditText({
    super.key,
    required this.controller,
    required this.hintText,
    this.hintTextColor,
    this.labelText,
    this.isPassword = false,
    this.keyboardType,
    this.textInputAction,
    this.maxLines,
    this.minLines,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixWidget,
    this.suffixWidget,
    this.onSuffixTap,
    this.onPrefixTap,
    this.autoFocus = false,
    this.onTap,
    this.isEditable = true,
    this.maxLength,
    this.isError = false,
    this.focusNode,
    this.errorText,
    this.disableContextMenu = false,
    this.showBorder = true,
    this.allowedInput = AllowedInput.everything, // Default to everything
    this.inputFormatters, // Custom input formatters
    this.minLength, // Custom minimum length
    this.maxLengthCustom, // Custom maximum length override
    this.height, // Height of the TextFormField container
    this.expands = false, // Whether the field should expand to fill the height
    this.backgroundColor, // Background color of the TextFormField container
    this.initialCountryCode, // Initial country code
    this.initialDialCode, // Initial dial code
    this.countryCodeList, // List of allowed country codes
    this.onCountryChanged, // Callback when country changes
    this.minSelectableDate, // Earliest pickable date for AllowedInput.dateField
  });

  /// Factory constructor for borderless text field (replaces BaseEditTextWithoutBorder)
  const BaseEditText.withoutBorder({
    super.key,
    required this.controller,
    required this.hintText,
    this.hintTextColor,
    this.labelText,
    this.isPassword = false,
    this.keyboardType,
    this.textInputAction,
    this.maxLines,
    this.minLines,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixWidget,
    this.suffixWidget,
    this.onSuffixTap,
    this.onPrefixTap,
    this.autoFocus = false,
    this.onTap,
    this.isEditable = true,
    this.maxLength,
    this.isError = false,
    this.focusNode,
    this.errorText,
    this.disableContextMenu = false,
    this.allowedInput = AllowedInput.everything, // Default to everything
    this.inputFormatters, // Custom input formatters
    this.minLength, // Custom minimum length
    this.maxLengthCustom, // Custom maximum length override
    this.height, // Height of the TextFormField container
    this.expands = false, // Whether the field should expand to fill the height
    this.backgroundColor, // Background color of the TextFormField container
    this.initialCountryCode, // Initial country code
    this.initialDialCode, // Initial dial code
    this.countryCodeList, // List of allowed country codes
    this.onCountryChanged, // Callback when country changes
    this.minSelectableDate, // Earliest pickable date for AllowedInput.dateField
  }) : showBorder = false;

  @override
  State<BaseEditText> createState() => _BaseEditTextState();
}

class _BaseEditTextState extends State<BaseEditText> {
  // Cache computed values to prevent rebuilds
  late final TextInputType _effectiveKeyboardType;
  late final List<TextInputFormatter>? _effectiveInputFormatters;
  late final int? _effectiveMaxLength;
  late final int _effectiveMinLength;
  late final String? Function(String?)? _enhancedValidator;

  // Focus node for phone field to handle border states
  late FocusNode _phoneFocusNode;

  @override
  void initState() {
    super.initState();
    _initializeComputedValues();
    _phoneFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _phoneFocusNode.dispose();
    super.dispose();
  }

  /// Initialize all computed values once during initState to avoid recalculating on every build
  void _initializeComputedValues() {
    final declaredKeyboardType = widget.keyboardType;

    // Compute effective keyboard type
    if (declaredKeyboardType != null) {
      _effectiveKeyboardType = declaredKeyboardType;
    } else {
      _effectiveKeyboardType = widget.allowedInput.keyboardType;
    }

    // Compute effective input formatters
    final List<TextInputFormatter> formatters = [];
    final enumFormatter = widget.allowedInput.inputFormatter;
    if (enumFormatter != null) {
      formatters.add(enumFormatter);
    }

    // Add line limit formatter if maxLines is specified
    if (widget.maxLines != null && widget.maxLines! > 0) {
      formatters.add(_LineCountInputFormatter(widget.maxLines!));
    }

    if (widget.inputFormatters != null) {
      formatters.addAll(widget.inputFormatters!);
    }
    _effectiveInputFormatters = formatters.isEmpty ? null : formatters;

    // Compute effective max length
    if (widget.maxLengthCustom != null) {
      _effectiveMaxLength = widget.maxLengthCustom;
    } else {
      final enumMaxLength = widget.allowedInput.defaultMaxLength;
      if (enumMaxLength != null) {
        _effectiveMaxLength = enumMaxLength;
      } else if (widget.showBorder) {
        _effectiveMaxLength = widget.maxLength ?? 50;
      } else {
        _effectiveMaxLength = null;
      }
    }

    // Compute effective min length
    _effectiveMinLength = widget.minLength ?? widget.allowedInput.defaultMinLength;

    // Create enhanced validator function once
    _enhancedValidator = _createEnhancedValidator();
  }

  /// Creates the enhanced validator function once
  String? Function(String?)? _createEnhancedValidator() {
    return (String? value) {
      // First check length constraints
      final lengthError = _validateLength(value);
      if (lengthError != null) {
        return lengthError;
      }

      // Then run custom validator if provided
      if (widget.validator != null) {
        return widget.validator!(value);
      }

      return null;
    };
  }

  /// Validates length constraints and returns error message if invalid
  String? _validateLength(String? value) {
    if (value == null || value.isEmpty) {
      if (_effectiveMinLength > 0) {
        return _effectiveMinLength == 1 ? 'This field is required' : 'Minimum $_effectiveMinLength characters required';
      }
      return null;
    }

    return widget.allowedInput
        .getLengthErrorMessage(value, customMinLength: widget.minLength, customMaxLength: widget.maxLengthCustom);
  }

  @override
  Widget build(BuildContext context) {
    // Cache theme to prevent lookups on every build
    final textTheme = Theme.of(context).textTheme;

    Widget textFormField = TextFormField(
      textInputAction: widget.textInputAction ?? TextInputAction.done,
      controller: widget.controller,
      obscureText: widget.isPassword,
      keyboardType: _effectiveKeyboardType,
      inputFormatters: _effectiveInputFormatters,
      autofocus: widget.autoFocus,
      validator: _enhancedValidator,
      maxLength: _effectiveMaxLength,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      focusNode: widget.focusNode,
      cursorColor: ColorManager.primaryColor,
      textAlign: TextAlign.left,
      contextMenuBuilder: (context, editableTextState) {
        if (widget.disableContextMenu) {
          return AdaptiveTextSelectionToolbar.buttonItems(
            anchors: editableTextState.contextMenuAnchors,
            buttonItems: [],
          );
        } else {
          final defaultButtons = editableTextState.contextMenuButtonItems;
          return AdaptiveTextSelectionToolbar.buttonItems(
            anchors: editableTextState.contextMenuAnchors,
            buttonItems: defaultButtons,
          );
        }
      },
      style: textTheme.bodyLarge?.copyWith(
        color: widget.isEditable ? ColorManager.colorText90 : ColorManager.colorText70,
      ),
      readOnly: !widget.isEditable ||
          widget.allowedInput == AllowedInput.dateField ||
          widget.allowedInput == AllowedInput.dateTimeField ||
          widget.allowedInput == AllowedInput.timeField,
      onTap: widget.allowedInput == AllowedInput.dateField
          ? () async {
              final BaseCalendarDialog calendarDialog = BaseCalendarDialog();
              final selectedDate = await calendarDialog.showCalendar(
                context,
                firstSelectableDate: widget.minSelectableDate,
              );
              widget.controller.text = FormattingUtils.formatDate(selectedDate, format: DateFormatConstants.dayMonthYearSlash);
              if (widget.onTap != null) widget.onTap!();
            }
          : widget.allowedInput == AllowedInput.dateTimeField
              ? () async {
                  final BaseCalendarDialog calendarDialog = BaseCalendarDialog();
                  final selectedDateTime = await calendarDialog.showDateAndTime(context);
                  widget.controller.text =
                      FormattingUtils.formatDate(selectedDateTime, format: DateFormatConstants.ddMMMyyyyhhmmA);
                  if (widget.onTap != null) widget.onTap!();
                }
              : widget.allowedInput == AllowedInput.timeField
                  ? () async {
                      final BaseCalendarDialog calendarDialog = BaseCalendarDialog();
                      final selectedTime = await calendarDialog.showTime(context);
                      final now = DateTime.now();
                      widget.controller.text = FormattingUtils.formatDate(
                        DateTime(now.year, now.month, now.day, selectedTime.hour, selectedTime.minute),
                        format: DateFormatConstants.time,
                      );
                      if (widget.onTap != null) widget.onTap!();
                    }
                  : widget.onTap,
      decoration: InputDecoration(
        labelText: widget.labelText,
        counterText: '',
        // Always hide the character counter
        hintStyle: textTheme.bodyLarge?.copyWith(
          color: (widget.isEditable && widget.isError) ? ColorManager.colorError : widget.hintTextColor ?? ColorManager.colorHint,
        ),
        hintText: FormattingUtils.getLocalizeString(context, widget.hintText),
        border: widget.showBorder ? null : InputBorder.none,
        focusedBorder: widget.showBorder
            ? OutlineInputBorder(
                borderSide: BorderSide(
                    color: widget.isEditable ? ColorManager.primaryColor : ColorManager.colorBorder,
                    width: widget.isEditable ? 2 : 1),
                borderRadius: BorderRadius.circular(8),
              )
            : InputBorder.none,
        enabledBorder: widget.showBorder
            ? OutlineInputBorder(
                borderSide: BorderSide(color: ColorManager.colorBorder, width: 1),
                borderRadius: BorderRadius.circular(8),
              )
            : InputBorder.none,
        errorBorder: widget.showBorder && widget.isEditable
            ? OutlineInputBorder(
                borderSide: BorderSide(color: ColorManager.colorError, width: 1),
                borderRadius: BorderRadius.circular(8),
              )
            : widget.showBorder
                ? OutlineInputBorder(
                    borderSide: BorderSide(color: ColorManager.colorBorder, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  )
                : InputBorder.none,
        focusedErrorBorder: widget.showBorder && widget.isEditable
            ? OutlineInputBorder(
                borderSide: BorderSide(color: ColorManager.colorError, width: 2),
                borderRadius: BorderRadius.circular(8),
              )
            : widget.showBorder
                ? OutlineInputBorder(
                    borderSide: BorderSide(color: ColorManager.colorBorder, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  )
                : InputBorder.none,
        prefixIconConstraints: const BoxConstraints(
          minWidth: 20,
          minHeight: 20,
        ),
        suffixIconConstraints: const BoxConstraints(
          maxWidth: 40,
          maxHeight: 40,
        ),
        prefixIcon: widget.prefixWidget != null
            ? GestureDetector(
                onTap: widget.onPrefixTap,
                child: widget.prefixWidget,
              )
            : widget.prefixIcon != null
                ? GestureDetector(
                    onTap: widget.onPrefixTap,
                    child: Icon(widget.prefixIcon),
                  )
                : null,
        suffixIcon: widget.suffixWidget != null
            ? GestureDetector(
                onTap: widget.onSuffixTap,
                child: widget.suffixWidget,
              )
            : widget.suffixIcon != null
                ? GestureDetector(
                    onTap: widget.onSuffixTap,
                    child: Icon(widget.suffixIcon),
                  )
                : null,
      ),
      expands: widget.expands,
    );

    // Handle phone with country code UI
    if (widget.allowedInput == AllowedInput.phoneWithCountryCode) {
      // Create a borderless text field for the phone number part
      final phoneTextField = TextFormField(
        textInputAction: widget.textInputAction ?? TextInputAction.done,
        controller: widget.controller,
        keyboardType: _effectiveKeyboardType,
        inputFormatters: _effectiveInputFormatters,
        autofocus: widget.autoFocus,
        validator: _enhancedValidator,
        maxLength: _effectiveMaxLength,
        maxLines: widget.maxLines,
        minLines: widget.minLines,
        focusNode: _phoneFocusNode,
        cursorColor: ColorManager.primaryColor,
        textAlign: TextAlign.left,
        style: textTheme.bodyLarge?.copyWith(
          color: widget.isEditable ? ColorManager.colorText90 : ColorManager.colorText70,
        ),
        readOnly: !widget.isEditable,
        onTap: widget.onTap,
        decoration: InputDecoration(
          counterText: '',
          hintStyle: textTheme.bodyLarge?.copyWith(
            color: widget.isError ? ColorManager.colorError : widget.hintTextColor ?? ColorManager.colorHint,
          ),
          hintText: FormattingUtils.getLocalizeString(context, widget.hintText),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
        ),
      );

      // Wrap the entire phone field in a container with border that responds to focus
      textFormField = AnimatedBuilder(
        animation: _phoneFocusNode,
        builder: (context, child) {
          final bool isFocused = _phoneFocusNode.hasFocus;
          final bool hasError = widget.isEditable && (widget.isError || (widget.errorText != null));

          Color borderColor;
          double borderWidth;

          if (hasError) {
            borderColor = ColorManager.colorError;
            borderWidth = isFocused ? 2 : 1;
          } else if (isFocused && widget.isEditable) {
            borderColor = ColorManager.primaryColor;
            borderWidth = 2;
          } else {
            borderColor = ColorManager.colorBorder;
            borderWidth = 1;
          }

          final phoneWidget = Container(
            decoration: BoxDecoration(
              color: ColorManager.colorWhite,
              border: widget.showBorder ? Border.all(color: borderColor, width: borderWidth) : null,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                CountryCodePicker(
                  showDropDownButton: false,
                  topBarPadding: EdgeInsets.zero,
                  onChanged: (val) {
                    if (widget.onCountryChanged != null) {
                      widget.onCountryChanged!(val.code ?? 'IN', val.dialCode ?? '+91');
                    }
                  },
                  dialogItemPadding: const EdgeInsets.all(10),
                  hideSearch: true,
                  hideCloseIcon: true,
                  hideHeaderText: true,
                  padding: const EdgeInsets.only(right: 15),
                  initialSelection: widget.initialCountryCode ?? 'IN',
                  flagWidth: 25,
                  showCountryOnly: false,
                  showOnlyCountryWhenClosed: false,
                  textStyle: textTheme.bodyLarge?.copyWith(color: ColorManager.colorText70),
                  alignLeft: false,
                  dialogTextStyle: textTheme.bodyMedium?.copyWith(color: ColorManager.colorText90),
                  searchPadding: EdgeInsets.only(left: 0, right: 12, top: 12, bottom: 12),
                  searchStyle: textTheme.titleSmall,
                  searchDecoration: InputDecoration(
                    icon: SizedBox.shrink(),
                    hintStyle: textTheme.bodyMedium?.copyWith(color: ColorManager.colorHint),
                    prefixIconConstraints: BoxConstraints(maxWidth: 0),
                    prefixIcon: SizedBox.shrink(),
                    prefix: SizedBox(
                      width: 10,
                    ),
                    hintText: FormattingUtils.getLocalizeString(context, LocalizationKeys.searchLabel),
                    suffixIcon: SvgPicture.asset(
                      'assets/res/search.svg',
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: ColorManager.colorBorder,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(30.0),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: ColorManager.primaryColor,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(30.0),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: ColorManager.colorBorder,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(30.0),
                      ),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: ColorManager.colorBorder,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(30.0),
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: ColorManager.colorBorder,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(30.0),
                      ),
                    ),
                  ),
                  dialogSize: Size(400, (40 * (widget.countryCodeList?.length ?? 10)).toDouble()),
                  countryFilter: widget.countryCodeList,
                ),
                Container(
                  width: 1,
                  height: 48,
                  color: ColorManager.colorBorder,
                ),
                const SizedBox(width: 12),
                Expanded(child: phoneTextField),
              ],
            ),
          );

          return (widget.height != null && widget.maxLines == null)
            ? SizedBox(
                height: widget.height,
                child: phoneWidget,
              )
            : phoneWidget;
        },
      );
    }

    if (!widget.showBorder) {
      // If maxLines is specified, don't constrain height to allow natural text field sizing
      return (widget.height != null && widget.maxLines == null)
        ? SizedBox(
            height: widget.height,
            child: textFormField,
          )
        : textFormField;
    }

    return LayoutBuilder(
      builder: (context, covariant) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            (widget.height != null && widget.maxLines == null)
              ? SizedBox(
                  height: widget.height,
                  child: Container(
                    decoration: BoxDecoration(
                      color: widget.backgroundColor ?? ColorManager.colorWhite,
                    ),
                    child: textFormField,
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                    color: widget.backgroundColor ?? ColorManager.colorWhite,
                  ),
                  child: textFormField,
                ),
            Visibility(
              maintainAnimation: true,
              maintainState: true,
              visible: widget.isEditable && widget.errorText != null,
              child: BaseTextView(
                text: widget.errorText ?? '',
                style: textTheme.bodySmall?.copyWith(color: ColorManager.colorError),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Input formatter that limits the number of lines in a text field
class _LineCountInputFormatter extends TextInputFormatter {
  final int maxLines;

  _LineCountInputFormatter(this.maxLines);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Count the number of newline characters in the new value
    final newLineCount = '\n'.allMatches(newValue.text).length + 1;

    // If the new line count exceeds maxLines, reject the change
    if (newLineCount > maxLines) {
      return oldValue;
    }

    return newValue;
  }
}

