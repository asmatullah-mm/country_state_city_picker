import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../utils/custom_colors.dart';

class ReactiveDropDownWidget extends StatelessWidget {
  ReactiveDropDownWidget({
    required this.formControl,
    required this.label,
    required this.items,
    this.validationMessages,
    this.onChanged,
    this.height = 48,
    this.suffixWidget,
  });

  final String label;
  final FormControl formControl;
  final List<DropdownMenuItem> items;
  final Map<String, String>? validationMessages;
  final Function(dynamic value)? onChanged;
  final double height;
  final Widget? suffixWidget;

  final enabledBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(4),
    borderSide: const BorderSide(
      style: BorderStyle.solid,
      color: CustomColors.inputBorderColor,
      width: 1.0,
    ),
  );

  final focusedBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(4),
    borderSide: const BorderSide(
      style: BorderStyle.solid,
      color: CustomColors.lightBlackColor,
      width: 1.0,
    ),
  );

  final errorBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(4),
    borderSide: const BorderSide(
      style: BorderStyle.solid,
      color: CustomColors.redColor,
      width: 1.0,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return ReactiveDropdownField(
      formControl: formControl,
      validationMessages: (control) => validationMessages ?? {},
      underline: SizedBox(),
      onChanged: onChanged,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: CustomColors.lightBlackColor,
        height: 1.42,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: CustomColors.lightGreyColor,
          height: 1.42,
        ),
        contentPadding: const EdgeInsets.only(
          left: 16,
          right: 12,
        ),
        enabledBorder: enabledBorder,
        focusedBorder: focusedBorder,
        errorBorder: errorBorder,
        focusedErrorBorder: errorBorder,
      ),
      icon: suffixWidget,
      menuMaxHeight: 440,
      items: items,
    );
  }
}
