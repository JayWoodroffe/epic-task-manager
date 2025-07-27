// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:kanban_app/features/boards/board_screen.dart';
import 'package:kanban_app/styles/colors.dart';

class ProjectCard extends StatelessWidget {
  final String title;
  const ProjectCard({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (BuildContext context) {
          //TODO clicking on a project will go to a screen displaying all the board linked to that project, and clicking on a board will go to board screen
          return BoardScreen();
        }));
      },
      child: Container(
        padding: EdgeInsets.all(10),
        alignment: Alignment.topLeft,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                blurRadius: 0, offset: Offset(5, 7), color: MyColors.tertiary),
          ],
          border: Border.all(width: 3, color: MyColors.tertiary),
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
        ),
        margin: EdgeInsets.only(left: 15, right: 15, top: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: MyColors.deepGreen,
                  ),
            ),
            Icon(Icons.menu)
          ],
        ),
      ),
    );
  }
}
