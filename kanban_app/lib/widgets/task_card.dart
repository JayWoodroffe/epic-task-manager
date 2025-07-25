import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  final String title;
  const TaskCard({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(width: 2)),
        child: Text(this.title),
      ),
    );
  }
}
