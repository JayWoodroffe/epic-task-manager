import 'package:flutter/material.dart';
import 'package:kanban_app/styles/colors.dart';

class ProjectCard extends StatelessWidget {
  final String title;
  const ProjectCard({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      alignment: Alignment.topLeft,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              blurRadius: 0, offset: Offset(5, 7), color: MyColors.midGreen),
        ],
        border: Border.all(width: 3, color: MyColors.midGreen),
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      margin: EdgeInsets.only(left: 15, right: 15, top: 15),
      child: Column(
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: MyColors.deepGreen,
                ),
          ),
        ],
      ),
    );
  }
}
