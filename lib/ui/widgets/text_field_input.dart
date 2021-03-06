import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  final void Function(String)? onChanged;
  final bool obscureText;
  final String? hintText;
  final TextInputType? textInputType;
  const TextFieldInput({
    Key? key,
    this.onChanged,
    this.obscureText = false,
    this.hintText,
    this.textInputType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
    );

    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        border: inputBorder,
        focusedBorder: inputBorder,
        enabledBorder: inputBorder,
        filled: true,
        contentPadding: const EdgeInsets.all(8),
      ),
      keyboardType: textInputType,
      obscureText: obscureText,
    );
  }
}
