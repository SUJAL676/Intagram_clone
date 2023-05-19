import 'package:flutter/material.dart';

class Edit_text_field extends StatelessWidget {

  final TextEditingController controller;
  final String hint_text;
  final bool ispass;
  final TextInputType type;


  const Edit_text_field({Key? key, required this.controller, required this.hint_text, this.ispass=false, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final inputBorder=OutlineInputBorder(
      borderSide: Divider.createBorderSide(context)
    );

    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint_text,
        border: inputBorder,
        focusedBorder: inputBorder,
        enabledBorder: inputBorder,
        filled: true,
        contentPadding: EdgeInsets.all(8),
      ),
      keyboardType: type,
      obscureText: ispass,
    );
  }
}
