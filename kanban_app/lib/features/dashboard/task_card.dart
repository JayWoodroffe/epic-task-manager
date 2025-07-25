import 'package:flutter/material.dart';
import 'package:kanban_app/styles/colors.dart';

class TaskCard extends StatelessWidget {
  final String title;
  const TaskCard({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: MyColors.lightGreen,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(width: 2)),
      child: Text(this.title),
    );
  }
}
