// ignore_for_file: prefer_const_constructors

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kanban_app/models/project.dart';
import 'package:kanban_app/models/user.dart';
import 'package:kanban_app/providers/project_provider.dart';
import 'package:kanban_app/styles/colors.dart';
import 'package:kanban_app/widgets/my_button.dart';
import 'package:kanban_app/widgets/my_text_form.dart';
import 'package:kanban_app/widgets/user_email_card.dart';
import 'package:provider/provider.dart';

//Modal for creating or editing projects
class EditProjectBottomSheet extends StatefulWidget {
  final Project project;
  final bool isEditing;
  const EditProjectBottomSheet(
      {required this.project, super.key, required this.isEditing});

  @override
  State<EditProjectBottomSheet> createState() => _EditProjectBottomSheetState();
}

class _EditProjectBottomSheetState extends State<EditProjectBottomSheet> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addUserController = TextEditingController();
  List<User> _selectedUsers = []; //users attached to the project
  List<User> _allUsers = []; //all of the users in the system
  User? _selectedUser; //user selected from the autocomplete options

  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.project.name;
    _descriptionController.text = widget.project.description;
    _selectedUsers = [
      ...widget.project.users
    ]; //modifiable copy of the users attached to this project
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAllUsers();
    });

    //to trigger if the save/create button is available or not
    //- project can only be saved or created if it has a name
    _nameController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _addUserController.dispose();
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
                //top row with edit heading and exit button
                children: [
                  Text(
                    widget.isEditing ? "Edit Project" : "New Project",
                    style: TextStyle(fontSize: 20),
                  ),
                  IconButton(
                      onPressed: () {
                        //checking if the current state of the project is different than the project passed into the modal
                        final currentProject = Project(
                          id: widget.project.id,
                          name: _nameController.text.trim(),
                          description: _descriptionController.text.trim(),
                          users: _selectedUsers,
                        );

                        //checks if the project has been changed at all - if yes, prompt to save
                        if (!currentProject.isSameAs(widget.project)) {
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
                                _nameController.text.trim().isNotEmpty
                                    ? TextButton(
                                        onPressed: () {
                                          Navigator.of(
                                              context) // dismiss dialog
                                            ..pop() // dismiss bottom sheet
                                            ..pop(
                                                currentProject); // save the changes
                                        },
                                        child: Text("Save"),
                                      )
                                    : SizedBox(),
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
              //textfields to edit the properties of a project: name and description
              MyTextField(
                  controller: _nameController,
                  label: 'Project Name',
                  hideContent: false,
                  textColor: MyColors.tertiary),
              //error message displayed if name is empty
              if (_nameController.text.trim().isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8, left: 12),
                  child: Text(
                    'Project name is required',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              SizedBox(height: 20),
              MyTextField(
                controller: _descriptionController,
                label: 'Description',
                hideContent: false,
                textColor: MyColors.tertiary,
                multiline: true,
              ),
              SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  "Users:",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: MyColors.tertiary),
                ),
              ),
              //displaying all the users currently in this project
              Column(
                children: _selectedUsers
                    .map((user) => UserEmailCard(
                          user: user,
                          onRemoved: (context, user) {
                            //to remove a user from a project
                            removeUser(user);
                          },
                        ))
                    .toList(),
              ),
              SizedBox(
                height: 5,
              ),

              //textfield to search the email addresses of all the users in the system - can add them to the project
              //searching done based on email as it is the only unique field for users
              ConstrainedBox(
                constraints: BoxConstraints(minHeight: 50, maxHeight: 300),
                child: RawAutocomplete<User>(
                  textEditingController: _addUserController,
                  focusNode: _focusNode,
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    //nothing has been entered to search with
                    if (textEditingValue.text.isEmpty)
                      return const Iterable<User>.empty();
                    //filter users in system based on the entered search text
                    final filtered = _allUsers
                        .where((user) =>
                            user.email.toLowerCase().contains(
                                textEditingValue.text.toLowerCase()) &&
                            !_selectedUsers.contains(user))
                        .toList();

                    //returns users that match the current search
                    return filtered;
                  },
                  //when a user is selected from the autocomplete options
                  onSelected: (User user) {
                    _addUserController.text = user
                        .email; //displays selected user's full email address in the textfield
                    //store the selected user
                    setState(() => _selectedUser = user);
                  },
                  displayStringForOption: (User user) =>
                      user.email, //displays only the users' emails
                  fieldViewBuilder: (BuildContext context,
                      TextEditingController textEditingController,
                      FocusNode focusNode,
                      VoidCallback onFieldSubmitted) {
                    //row for the searching text field and the add button to add the user
                    return Row(
                      children: [
                        Expanded(
                          child: TextField(
                            focusNode: focusNode,
                            controller: textEditingController,
                            style: TextStyle(
                                color: MyColors.charcoal, fontSize: 15),
                            cursorColor: MyColors.tertiary,
                            decoration: InputDecoration(
                              labelText: 'Add user by email',
                              labelStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: MyColors.tertiary),
                              prefixIcon: Icon(Icons.search_outlined,
                                  color: Colors.grey.shade700),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: MyColors.charcoal, width: 3),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: MyColors.charcoal, width: 3),
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),
                        //icon for adding the user to the project
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            if (_selectedUser != null &&
                                !_selectedUsers.contains(_selectedUser!)) {
                              setState(() {
                                _selectedUsers.add(
                                    _selectedUser!); //adds user to project's users
                                _addUserController
                                    .clear(); //clears the textfield
                                _selectedUser = null; // Reset selection
                              });
                            }
                          },
                        )
                      ],
                    );
                  },

                  //controls how the autocomplete options are displayed
                  optionsViewBuilder: (BuildContext context,
                      AutocompleteOnSelected<User> onSelected,
                      Iterable<User> options) {
                    return Align(
                      alignment: Alignment.topLeft,
                      child: Material(
                        elevation: 4,
                        borderRadius: BorderRadius.circular(8),
                        child: ListView(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          children: options.map((User user) {
                            return ListTile(
                              onTap: () => onSelected(user),
                              title: Text(
                                user.email,
                                style: TextStyle(fontSize: 15),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: 40),

              //if the user is editing and not creating - give option to delete the project
              widget.isEditing
                  ? Column(
                      children: [
                        MyButton(
                          color: MyColors.secondary,
                          label: "DELETE PROJECT",
                          onButtonPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text("Are you sure?"),
                                content: Text(
                                    "Do you want to delete this project? Delete is irreversable."),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context)
                                        .pop(), // dismiss dialog
                                    child: Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      await Provider.of<ProjectProvider>(
                                              context,
                                              listen: false)
                                          .deleteProject(widget
                                              .project); //deletes the project using the project api
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
                  //disable save feature if the name is empty
                  onButtonPressed: _nameController.text.trim().isEmpty
                      ? () {}
                      : () {
                          final newOrUpdatedProject = Project(
                            id: widget.project.id,
                            name: _nameController.text.trim(),
                            description: _descriptionController.text.trim(),
                            users: _selectedUsers,
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

  //asynchronously load all the users in the company
  Future<void> _loadAllUsers() async {
    final projectProvider =
        Provider.of<ProjectProvider>(context, listen: false);
    await projectProvider.fetchAllUsers();

    //check if the modal is up
    if (mounted) {
      setState(() {
        _allUsers = projectProvider.users.cast<User>();
      });
    }
  }

  //when an x is clicked next to a user email
  void removeUser(User user) {
    if (mounted) {
      setState(() {
        _selectedUsers.remove(user);
      });
    }
  }
}
