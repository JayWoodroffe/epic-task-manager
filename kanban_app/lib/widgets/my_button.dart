import 'package:flutter/material.dart';
import 'package:kanban_app/styles/colors.dart';

class MyButton extends StatelessWidget {
  final String label;
  final void Function() onButtonPressed;
  final Color color;
  final Icon? buttonIcon;
  final double width;
  final double height;

  MyButton(
      {super.key,
      required this.label,
      required this.onButtonPressed,
      required this.color,
      required this.width,
      this.height = 50,
      this.buttonIcon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
                blurRadius: 0, color: MyColors.charcoal, offset: Offset(5, 7))
          ],
        ),
        child: TextButton(
            onPressed: () {
              onButtonPressed();
            },
            style: TextButton.styleFrom(
              side: BorderSide(color: MyColors.charcoal, width: 3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              backgroundColor: color,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (buttonIcon != null) ...[
                  buttonIcon!,
                  SizedBox(
                    width: 10,
                  ),
                ],
                Text(
                  label,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: MyColors.cream),
                ),
              ],
            )),
      ),
    );
  }
}
