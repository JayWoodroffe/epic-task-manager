import 'package:flutter/material.dart';
import 'package:kanban_app/styles/colors.dart';

class CreateTask extends StatefulWidget {
  final Function(String taskName) onConfirm;
  final VoidCallback onCancel;

  const CreateTask(
      {required this.onConfirm, required this.onCancel, super.key});

  @override
  State<CreateTask> createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {
  final TextEditingController _taskNameController = TextEditingController();

  @override
  void dispose() {
    _taskNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
          width: MediaQuery.of(context).size.width - 20,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(width: 3, color: MyColors.charcoal),
              boxShadow: [
                BoxShadow(
                    offset: Offset(5, 7),
                    blurRadius: 0,
                    color: MyColors.charcoal)
              ],
              borderRadius: BorderRadius.circular(16)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("NEW TASK", style: TextStyle(fontSize: 25)),
              SizedBox(
                height: 15,
              ),
              TextField(
                controller: _taskNameController,
                cursorColor: MyColors.charcoal,
                style: Theme.of(context).textTheme.bodyMedium,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: MyColors.cream,
                  labelText: 'Task Name',
                  labelStyle: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: MyColors.tertiary),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MyColors.tertiary, width: 3),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MyColors.tertiary, width: 3),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: widget.onCancel,
                      style: TextButton.styleFrom(
                        backgroundColor: MyColors.secondary,
                        foregroundColor: MyColors.cream,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        side: BorderSide(
                          color: MyColors.charcoal,
                          width: 3,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text("CANCEL"),
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: TextButton(
                      onPressed: () =>
                          widget.onConfirm(_taskNameController.text),
                      style: TextButton.styleFrom(
                        backgroundColor: MyColors.tertiary,
                        foregroundColor: MyColors.cream,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        side: BorderSide(
                          color: MyColors.charcoal,
                          width: 3,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text("CONFIRM"),
                    ),
                  )
                ],
              )
            ],
          )),
    );
  }
}
