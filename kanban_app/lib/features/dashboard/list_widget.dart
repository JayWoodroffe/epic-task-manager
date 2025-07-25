import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kanban_app/features/dashboard/task_card.dart';
import 'package:kanban_app/styles/colors.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  @override
  Widget build(BuildContext context) {
    //static test data
    final random = Random();
    final count = random.nextInt(5) + 1;
    final List<String> tasks = List<String>.generate(
      count,
      (i) => 'Task ${i + 1}',
    );

    return Container(
      decoration: BoxDecoration(color: MyColors.mintCream),
      child: Column(
        children: [
          //container for list heading
          Container(
            decoration: BoxDecoration(
                color: MyColors.midGreen,
                borderRadius: BorderRadius.circular(16)),
          ),
          ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              return TaskCard(title: tasks[index]);
            },
          ),
        ],
      ),
    );
  }
}
