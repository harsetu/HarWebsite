import 'package:flutter/material.dart';

import '../../constants/color_manager.dart';
import '../utils/formatting_utils.dart';

class BaseDropdown extends StatefulWidget {
  final List<String> items;
  final TextEditingController controller;
  final String hintText;
  final bool isError;
  final ValueChanged<String?> onChanged;
  final String Function(String) itemToString;

  const BaseDropdown({
    super.key,
    required this.items,
    required this.controller,
    required this.hintText,
    required this.isError,
    required this.onChanged,
    required this.itemToString,
  });

  @override
  State<BaseDropdown> createState() => _BaseDropdownState();
}

class _BaseDropdownState extends State<BaseDropdown> {
  String? controllerText;

  @override
  void initState() {
    controllerText = widget.controller.text;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return LayoutBuilder(builder: (context, constraints) {
      return DropdownMenu(
        controller: widget.controller,
        enableFilter: false,
        initialSelection: widget.controller.text,
        requestFocusOnTap: false,
        leadingIcon: null,
        label: null,
        width: constraints.maxWidth,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          suffixIconColor: widget.isError ? ColorManager.colorError : ColorManager.colorBorder,
          fillColor: Colors.white,
          isDense: true,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: widget.isError ? ColorManager.colorError : ColorManager.colorBorder),
            borderRadius: BorderRadius.circular(8),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: widget.isError ? ColorManager.colorError : ColorManager.colorBorder),
            borderRadius: BorderRadius.circular(8),
          ),
          constraints: BoxConstraints(
            minHeight: 48, // shrink the input height
            maxHeight: 48,
          ),
          hintStyle:
              themeData.textTheme.bodyLarge?.copyWith(color: widget.isError ? ColorManager.colorError : ColorManager.colorHint),
        ),
        hintText: FormattingUtils.getLocalizeString(context, widget.hintText),
        textStyle: themeData.textTheme.bodyLarge,
        onSelected: (value) {
          setState(() {
            widget.controller.text = value ?? '';
            controllerText = value;
          });
          widget.onChanged(value);
        },
        menuStyle: MenuStyle(
          padding: WidgetStateProperty.all(EdgeInsets.zero),
          maximumSize: WidgetStateProperty.all(
            Size(
              double.infinity,
              MediaQuery.of(context).size.height * 0.7, // max height 70%
            ),
          ),
          elevation: WidgetStateProperty.all(2),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        dropdownMenuEntries: widget.items.map((item) {
          return DropdownMenuEntry(
            value: FormattingUtils.getLocalizeString(context, item),
            label: FormattingUtils.getLocalizeString(context, item),
            style: MenuItemButton.styleFrom(
              textStyle: themeData.textTheme.titleSmall,
              backgroundColor: (controllerText != null && controllerText == FormattingUtils.getLocalizeString(context, item))
                  ? ColorManager.primaryMercury50
                  : ColorManager.colorWhite, // Highlight selected
            ),
          );
        }).toList(),
      );
    });
  }
}
