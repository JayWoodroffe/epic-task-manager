import 'package:flutter/material.dart';
import 'package:kanban_app/styles/colors.dart';

/*custom text field with options to obscure text for password text fields and ability to make it multiline*/
class MyTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final bool hideContent; //true if the field is a password field
  final TextInputType? keyBoardType; //used when a field is an email field
  final Color textColor;
  final bool multiline;

  const MyTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hideContent,
    this.keyBoardType,
    required this.textColor,
    this.multiline = false,
  });

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(16), boxShadow: [
        BoxShadow(
          blurRadius: 0,
          offset: Offset(5, 7),
          color: MyColors.tertiary,
        )
      ]),
      child: TextField(
        minLines: widget.multiline
            ? 3
            : 1, //make minLines 3 if the widget is multiline
        maxLines: widget.multiline ? null : 1,
        style: Theme.of(context).textTheme.bodyMedium,
        controller: widget.controller,

        keyboardType: widget.keyBoardType ??
            TextInputType
                .text, //if no TextInputType is provided - use the text type, otherwise use the one provided
        obscureText: widget.hideContent
            ? _obscureText
            : false, //if the widget is a password field - use the obscureText flag, otherwise don't
        cursorColor: MyColors.tertiary,
        decoration: InputDecoration(
          suffixIcon: widget.hideContent
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                  icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off))
              : null,
          filled: true,
          fillColor: MyColors.cream,
          labelText: widget.label,
          alignLabelWithHint: true,
          labelStyle: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: widget.textColor),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyColors.charcoal, width: 3),
            borderRadius: BorderRadius.circular(16),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyColors.charcoal, width: 3),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
