import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kanban_app/widgets/create_task.dart';
import 'package:kanban_app/widgets/task_card.dart';
import 'package:kanban_app/styles/colors.dart';

/*Class to display a single list for a board
- shows all of the tasks currently associated with this list
- has a create task button for each list - when the user creates a new task, 
it should automatically be created in the list on which they clicked the button*/
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

    return Scaffold(
      backgroundColor: MyColors.cream,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            //container for list heading
            Container(
              width: MediaQuery.of(context).size.width - 20,
              height: 50,
              decoration: BoxDecoration(
                  border: Border.all(color: MyColors.charcoal, width: 3),
                  color: MyColors.tertiary,
                  borderRadius: BorderRadius.circular(16)),
              child: Center(
                child: Text(
                  "List Name",
                  style: TextStyle(fontSize: 22, color: MyColors.cream),
                ),
              ),
            ),
            SizedBox(height: 20),

            //Task List - expanded to fill space
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return TaskCard(title: tasks[index]);
                },
              ),
            ),

            //create task button
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: GestureDetector(
                  onTap: () => _showCreateTaskDialog(context),
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                        color: MyColors.secondary,
                        border: Border.all(color: MyColors.charcoal, width: 3),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(5, 7),
                              blurRadius: 0,
                              color: MyColors.charcoal)
                        ]),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add,
                          size: 30,
                          color: MyColors.cream,
                          weight: 50,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "CREATE TASK",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: MyColors.cream),
                        )
                      ],
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }

  //method to display the Create Task dialog window
  _showCreateTaskDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CreateTask(
              object: "Task",
              inputLength: 3,
              onConfirm: (String taskName) {
                //create task and add to db and list
                Navigator.of(context).pop();
                print(taskName);
              },
              onCancel: () {
                Navigator.of(context).pop();
              });
        });
  }
}
