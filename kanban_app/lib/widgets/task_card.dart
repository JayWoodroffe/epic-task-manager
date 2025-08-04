import 'package:flutter/material.dart';
import 'package:kanban_app/models/task.dart';
import 'package:kanban_app/providers/list_provider.dart';
import 'package:provider/provider.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  const TaskCard({required this.task, super.key});

  @override
  Widget build(BuildContext context) {
    final listProvider = Provider.of<ListProvider>(context);

    return Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Container(
          height: 50,
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(width: 2)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  task.name,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              GestureDetector(
                child: Icon(Icons.cancel_outlined),
                onTap: () async {
                  await listProvider.deleteTask(task);
                },
              )
            ],
            // ),
          ),
        ));
  }
}
