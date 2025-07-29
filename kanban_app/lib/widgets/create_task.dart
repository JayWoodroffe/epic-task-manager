import 'package:flutter/material.dart';
import 'package:kanban_app/styles/colors.dart';

//Custom dialog widget for creating a new task
class CreateTask extends StatefulWidget {
  final Function(String taskName) onConfirm;
  final VoidCallback onCancel;
  final String object; //'task', 'list' (board/project - potentially )
  final int inputLength;

  const CreateTask(
      {required this.object,
      required this.inputLength,
      required this.onConfirm,
      required this.onCancel,
      super.key});

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

//chose a Dialog over an AlertDialog to allow for customising the dialog box
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
          //container at the top of the hierarchy allows for drop shadow on the dialog box
          width: MediaQuery.of(context).size.width - 20,
          padding: EdgeInsets.all(10),
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
            //column for laying out all the dialog components
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("NEW ${widget.object.toUpperCase()}",
                  style: TextStyle(fontSize: 25)),
              SizedBox(
                height: 15,
              ),
              //entering the task name
              TextField(
                maxLines: widget.inputLength,
                controller: _taskNameController,
                cursorColor: MyColors.charcoal,
                style: Theme.of(context).textTheme.bodyMedium,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: MyColors.cream,
                  labelText: '${widget.object} Name',
                  floatingLabelAlignment: FloatingLabelAlignment.start,
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
                      onPressed: () => widget.onConfirm(_taskNameController
                          .text), //return the new task name to caller screen
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
