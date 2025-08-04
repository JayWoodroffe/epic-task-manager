import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kanban_app/models/list.dart';
import 'package:kanban_app/models/task.dart';
import 'package:kanban_app/providers/list_provider.dart';
import 'package:kanban_app/widgets/create_task.dart';
import 'package:kanban_app/widgets/my_button.dart';
import 'package:kanban_app/widgets/task_card.dart';
import 'package:kanban_app/styles/colors.dart';
import 'package:provider/provider.dart';

/*Class to display a single list for a board
- shows all of the tasks currently associated with this list
- has a create task button for each list - when the user creates a new task, 
it should automatically be created in the list on which they clicked the button*/
class ListScreen extends StatefulWidget {
  final ListType list;
  final VoidCallback? onDragStarted;
  final VoidCallback? onDragEnded;
  final PageController pageController;
  final int currentPageIndex;
  final int totalPages;

  const ListScreen(
      {super.key,
      required this.list,
      this.onDragStarted,
      this.onDragEnded,
      required this.pageController,
      required this.currentPageIndex,
      required this.totalPages});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  @override
  Widget build(BuildContext context) {
    final listProvider = Provider.of<ListProvider>(context, listen: false);

    return DragTarget<Task>(
      onWillAccept: (_) => true,
      onAccept: (incomingTask) async {
        final oldListId = incomingTask.listId;
        final isSameList = oldListId == widget.list.id;
        if (isSameList) return;

        final updatedTask = incomingTask.copyWith(
          listId: widget.list.id,
          order: widget.list.tasks.length,
        );

        await listProvider.moveTaskToList(updatedTask, oldListId);

        widget.onDragEnded?.call();
      },
      builder: (context, _, __) {
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
                  child: Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            widget.list.name,
                            style:
                                TextStyle(fontSize: 22, color: MyColors.cream),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text("Are you sure?"),
                              content: Text(
                                  "Do you want to delete this List? Delete is irreversable."),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context)
                                      .pop(), // dismiss dialog
                                  child: Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    await listProvider.deleteList(widget
                                        .list); //deletes the list from the board
                                    Navigator.of(context) // dismiss dialog
                                        .pop();
                                  },
                                  child: Text("Delete"),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Icon(
                          Icons.delete,
                          size: 30,
                          color: MyColors.cream,
                          weight: 50,
                        ),
                      ),
                      SizedBox(width: 10),
                    ],
                  ),
                ),
                SizedBox(height: 20),

                Expanded(
                  child: listProvider.isLoadingTask
                      ? Center(
                          child: CircularProgressIndicator(
                            color: MyColors.tertiary,
                          ),
                        )
                      //Task List - expanded to fill space
                      : Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                itemCount: widget.list.tasks.length,
                                itemBuilder: (context, index) {
                                  final task = widget.list.tasks[index];
                                  return DragTarget<Task>(
                                    onWillAccept: (incomingTask) => true,
                                    onAccept: (incomingTask) async {
                                      if (incomingTask.id == task.id) return;

                                      final oldListId = incomingTask.listId;
                                      final isSameList =
                                          oldListId == widget.list.id;

                                      // Copy + adjust order
                                      List<Task> updatedTasks = [
                                        ...widget.list.tasks
                                      ];
                                      updatedTasks.removeWhere(
                                          (t) => t.id == incomingTask.id);

                                      final newTask = incomingTask.copyWith(
                                        listId: widget.list.id,
                                        order: index,
                                      );
                                      updatedTasks.insert(index, newTask);

                                      // Fix ordering
                                      for (int i = 0;
                                          i < updatedTasks.length;
                                          i++) {
                                        updatedTasks[i] =
                                            updatedTasks[i].copyWith(order: i);
                                      }

                                      if (isSameList) {
                                        await listProvider.reorderTasks(
                                            updatedTasks, widget.list.id);
                                      } else {
                                        await listProvider.moveTaskToList(
                                            newTask, oldListId);
                                      }

                                      widget.onDragEnded?.call();
                                    },
                                    builder: (context, _, __) {
                                      return LongPressDraggable<Task>(
                                        data: task,
                                        onDragStarted: widget.onDragStarted,
                                        onDragEnd: (_) =>
                                            widget.onDragEnded?.call(),
                                        onDragUpdate: (details) {
                                          final dx = details.globalPosition.dx;
                                          final screenWidth =
                                              MediaQuery.of(context).size.width;
                                          const edgeThreshold = 50;

                                          if (dx < edgeThreshold &&
                                              widget.currentPageIndex > 0) {
                                            widget.pageController.previousPage(
                                              duration:
                                                  Duration(milliseconds: 300),
                                              curve: Curves.easeInOut,
                                            );
                                          } else if (dx >
                                                  screenWidth - edgeThreshold &&
                                              widget.currentPageIndex <
                                                  widget.totalPages - 1) {
                                            widget.pageController.nextPage(
                                              duration:
                                                  Duration(milliseconds: 300),
                                              curve: Curves.easeInOut,
                                            );
                                          }
                                        },
                                        feedback: Material(
                                          color: Colors.transparent,
                                          child: ConstrainedBox(
                                            constraints: BoxConstraints(
                                                maxWidth: 300, maxHeight: 40),
                                            child: TaskCard(task: task),
                                          ),
                                        ),
                                        childWhenDragging: Opacity(
                                          opacity: 0.3,
                                          child: TaskCard(task: task),
                                        ),
                                        child: TaskCard(
                                            key: ValueKey(task.id), task: task),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                            DragTarget<Task>(
                              onWillAccept: (_) => true,
                              onAccept: (incomingTask) async {
                                final oldListId = incomingTask.listId;
                                final isSameList = oldListId == widget.list.id;

                                final newOrder = widget.list.tasks.length;

                                final updatedTask = incomingTask.copyWith(
                                  listId: widget.list.id,
                                  order: newOrder,
                                );

                                if (isSameList) {
                                  // Move to end
                                  final updatedTasks = [...widget.list.tasks]
                                    ..removeWhere(
                                        (t) => t.id == incomingTask.id)
                                    ..add(updatedTask);

                                  // Fix order
                                  for (int i = 0;
                                      i < updatedTasks.length;
                                      i++) {
                                    updatedTasks[i] =
                                        updatedTasks[i].copyWith(order: i);
                                  }

                                  await listProvider.reorderTasks(
                                      updatedTasks, widget.list.id);
                                } else {
                                  await listProvider.moveTaskToList(
                                      updatedTask, oldListId);
                                }
                              },
                              builder: (context, _, __) => Container(
                                height: 40,
                                width: double.infinity,
                                color: Colors.transparent,
                              ),
                            ),
                          ],
                        ),
                ),
                //create task button
                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: MyButton(
                    label: 'CREATE TASK',
                    onButtonPressed: () => _showCreateTaskDialog(context),
                    color: MyColors.secondary,
                    width: double.infinity,
                    height: 40,
                    buttonIcon: Icon(
                      Icons.add,
                      size: 30,
                      color: MyColors.cream,
                      weight: 50,
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  //method to display the Create Task dialog window
  _showCreateTaskDialog(BuildContext context) {
    final provider = Provider.of<ListProvider>(context, listen: false);
    final list = provider.lists.firstWhere((l) => l.id == widget.list.id);
    final currentTaskCount = list.tasks.length;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CreateTask(
          object: "Task",
          inputLength: 3,
          onConfirm: (String taskName) async {
            //create task and add to db and list
            Navigator.of(context).pop(); //close dialog
            if (taskName.trim().isEmpty) return; //can't create an empty task

            final newTask = Task(
              id: '',
              name: taskName,
              listId: widget.list.id,
              order: currentTaskCount,
            );

            await provider.createTask(newTask, widget.list.id);
            print(taskName);
          },
          onCancel: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}
