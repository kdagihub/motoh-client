import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MotohTextField extends StatelessWidget {
  const MotohTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.keyboardType,
    this.obscureText = false,
    this.autofocus = false,
    this.readOnly = false,
    this.prefix,
    this.suffix,
    this.validator,
    this.onChanged,
    this.inputFormatters,
    this.textInputAction,
    this.onSubmitted,
    this.maxLines = 1,
  });

  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool autofocus;
  final bool readOnly;
  final Widget? prefix;
  final Widget? suffix;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction? textInputAction;
  final void Function(String)? onSubmitted;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      autofocus: autofocus,
      readOnly: readOnly,
      validator: validator,
      onChanged: onChanged,
      inputFormatters: inputFormatters,
      textInputAction: textInputAction,
      onFieldSubmitted: onSubmitted,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefix != null ? Padding(padding: const EdgeInsets.only(left: 8), child: prefix) : null,
        suffixIcon: suffix,
      ),
    );
  }
}
