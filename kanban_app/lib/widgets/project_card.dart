// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:kanban_app/providers/auth_provider.dart';
import 'package:kanban_app/features/dashboard/boards_dashboard.dart';
import 'package:kanban_app/models/project.dart';
import 'package:kanban_app/styles/colors.dart';
import 'package:provider/provider.dart';

//widget to display the name and description of a project
//includes edit button if the user is an admin
class ProjectCard extends StatelessWidget {
  final Project project;
  final void Function(BuildContext, Offset, Project) onMenuPressed;
  const ProjectCard(
      {required this.project, required this.onMenuPressed, super.key});

  @override
  Widget build(BuildContext context) {
    //isAdmin is required for conditional display of the edit button (and thus, the ability to edit a project)
    final authProvider = Provider.of<AuthProvider>(context);
    final isAdmin = authProvider.isAdmin;

    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (BuildContext context) {
          return BoardsDashboard(project: project);
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //project's name and an icon for editing the project
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  project.name,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: MyColors.deepGreen,
                      ),
                ),
                if (isAdmin)
                  GestureDetector(
                    onTapDown: (TapDownDetails details) {
                      onMenuPressed(context, details.globalPosition, project);
                    },
                    child: Icon(Icons.edit),
                  ),
              ],
            ),
            SizedBox(height: 5),
            Text(
              project.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }
}
