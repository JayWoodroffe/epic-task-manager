import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kanban_app/models/project.dart';
import 'package:kanban_app/styles/colors.dart';

class EditTaskBottomSheet extends StatefulWidget {
  final Project project;
  const EditTaskBottomSheet({required this.project, super.key});

  @override
  State<EditTaskBottomSheet> createState() => _EditTaskBottomSheetState();
}

class _EditTaskBottomSheetState extends State<EditTaskBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
            color: MyColors.tertiary,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                  blurRadius: 0,
                  offset: Offset(0, -7),
                  color: MyColors.charcoal)
            ]),
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                //title Edit Project
                //have the project name and description in textforms
                //show the email address of all users in the project - use the ProjectProvider?
              ],
            )
          ],
        ));
  }
}
