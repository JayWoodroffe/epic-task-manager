// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:kanban_app/models/board.dart';
import 'package:kanban_app/providers/board_provider.dart';
import 'package:kanban_app/styles/colors.dart';
import 'package:kanban_app/widgets/my_button.dart';
import 'package:kanban_app/widgets/my_text_form.dart';
import 'package:provider/provider.dart';

//Modal for creating or editing boards
class EditBoardBottomSheet extends StatefulWidget {
  final Board board;
  final bool isEditing;
  const EditBoardBottomSheet(
      {required this.board, super.key, required this.isEditing});

  @override
  State<EditBoardBottomSheet> createState() => _EditBoardBottomSheetState();
}

class _EditBoardBottomSheetState extends State<EditBoardBottomSheet> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.board.name;
    _descriptionController.text = widget.board.description;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width - 30,
          decoration: BoxDecoration(
              border: Border.all(color: MyColors.charcoal, width: 5),
              color: MyColors.cream,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                    blurRadius: 0,
                    offset: Offset(30, -18),
                    color: MyColors.charcoal)
              ]),
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //top row with heading and exit button
                children: [
                  Text(
                    widget.isEditing ? "Edit Board" : "New Board",
                    style: TextStyle(fontSize: 20),
                  ),
                  IconButton(
                      onPressed: () {
                        //checking if the current state of the project is different than the project passed into the modal
                        final currentBoard = Board(
                          id: widget.board.id,
                          name: _nameController.text.trim(),
                          description: _descriptionController.text.trim(),
                        );

                        //checks if the project has been changed at all - if yes, prompt to save
                        if (!currentBoard.isSameAs(widget.board)) {
                          // show dialog: "Save changes?"
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text("Unsaved changes"),
                              content: Text(
                                  "Do you want to save changes before closing?"),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context)
                                      .pop(), // dismiss dialog
                                  child: Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context) // dismiss dialog
                                      ..pop() // dismiss bottom sheet
                                      ..pop(currentBoard); // save the changes
                                  },
                                  child: Text("Save"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // dismiss dialog
                                    Navigator.of(context)
                                        .pop(); // dismiss bottom sheet without saving
                                  },
                                  child: Text("Discard"),
                                ),
                              ],
                            ),
                          );
                        } else {
                          Navigator.of(context).pop(); // no changes, just close
                        }
                      },
                      icon: Icon(
                        Icons.cancel_outlined,
                        size: 30,
                      )),
                ],
              ),
              SizedBox(height: 25),
              MyTextField(
                  controller: _nameController,
                  label: 'Board Name',
                  hideContent: false,
                  textColor: MyColors.tertiary),
              SizedBox(height: 25),
              MyTextField(
                controller: _descriptionController,
                label: 'Description',
                hideContent: false,
                textColor: MyColors.tertiary,
                multiline: true,
              ),
              SizedBox(height: 25),

              SizedBox(height: 10),

              //if the user is editing and not creating - give option to delete the project
              widget.isEditing
                  ? Column(
                      children: [
                        MyButton(
                          color: MyColors.secondary,
                          label: "DELETE BOARD",
                          onButtonPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text("Are you sure?"),
                                content: Text(
                                    "Do you want to delete this board? Delete is irreversable."),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context)
                                        .pop(), // dismiss dialog
                                    child: Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      await Provider.of<BoardProvider>(context,
                                              listen: false)
                                          .deleteBoard(widget
                                              .board); //deletes the project using the project api
                                      Navigator.of(context) // dismiss dialog
                                        ..pop() // dismiss bottom sheet
                                        ..pop(); // save the changes
                                    },
                                    child: Text("Delete"),
                                  ),
                                ],
                              ),
                            );
                          },
                          width: double.infinity,
                        ),
                        SizedBox(height: 10)
                      ],
                    )
                  : SizedBox(),

              //button to save or create
              MyButton(
                  label: widget.isEditing ? 'SAVE' : 'CREATE',
                  onButtonPressed: () {
                    final newOrUpdatedProject = Board(
                      id: widget.board.id,
                      name: _nameController.text.trim(),
                      description: _descriptionController.text.trim(),
                    );
                    Navigator.of(context).pop(
                        newOrUpdatedProject); //passes the project back to the dashboard for updating/creating
                  },
                  buttonIcon: widget.isEditing
                      ? null
                      : Icon(
                          Icons.add,
                          color: MyColors.cream,
                        ),
                  color: MyColors.tertiary,
                  width: double.infinity)
            ],
          ),
        ),
      ),
    );
  }
}
