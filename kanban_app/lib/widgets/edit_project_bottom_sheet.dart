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

class EditProjectBottomSheet extends StatefulWidget {
  final Project project;
  const EditProjectBottomSheet({required this.project, super.key});

  @override
  State<EditProjectBottomSheet> createState() => _EditProjectBottomSheetState();
}

class _EditProjectBottomSheetState extends State<EditProjectBottomSheet> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addUserController = TextEditingController();
  List<User> _selectedUsers = []; //users attached to the project
  bool _isLoadingUsers = true;
  List<User> _allUsers = []; //all of the users in the system
  User? _selectedUser;
  bool isEdited = false;
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
  }

  @override
  void dispose() {
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
          height: MediaQuery.of(context).size.height * 0.8,
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
                    "Edit Project",
                    style: TextStyle(fontSize: 20),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
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
                  label: 'Project Name',
                  hideContent: false,
                  textColor: MyColors.charcoal),
              SizedBox(height: 25),
              MyTextField(
                controller: _descriptionController,
                label: 'Description',
                hideContent: false,
                textColor: MyColors.charcoal,
                multiline: true,
              ),
              SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  "Users:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
              ),
              Column(
                children: _selectedUsers
                    .map((user) => UserEmailCard(
                          user: user,
                          onRemoved: (context, user) {
                            removeUser(user); // Call the removeUser  method
                          },
                        ))
                    .toList(),
              ),
              SizedBox(
                height: 5,
              ),

              //textfield to search the email addresses of all the users in the system - can add them to the project
              ConstrainedBox(
                constraints: BoxConstraints(minHeight: 50),
                child: RawAutocomplete<User>(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text.isEmpty)
                      return const Iterable<User>.empty();
                    return _allUsers.where((user) =>
                        user.email
                            .toLowerCase()
                            .contains(textEditingValue.text.toLowerCase()) &&
                        !_selectedUsers.contains(user));
                  },
                  onSelected: (User user) {
                    _addUserController.text = user.email;
                    //store the selected user
                    setState(() => _selectedUser = user);
                  },
                  displayStringForOption: (User user) => user.email,
                  fieldViewBuilder: (BuildContext context, _,
                      FocusNode focusNode, VoidCallback onFieldSubmitted) {
                    return Row(
                      children: [
                        Expanded(
                          child: TextField(
                            focusNode: focusNode,
                            controller: _addUserController,
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
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            if (_selectedUser != null &&
                                !_selectedUsers.contains(_selectedUser!)) {
                              setState(() {
                                _selectedUsers.add(_selectedUser!);
                                _addUserController.clear();
                                _selectedUser = null; // Reset selection
                              });
                            }
                          },
                        )
                      ],
                    );
                  },
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

              // ConstrainedBox(
              //   constraints: BoxConstraints(minHeight: 50),
              //   // height: 50,
              //   child: TextField(
              //       style: TextStyle(color: MyColors.charcoal, fontSize: 18),
              //       cursorColor: MyColors.tertiary,
              //       controller: _addUserController,
              //       decoration: InputDecoration(
              //         labelStyle: Theme.of(context)
              //             .textTheme
              //             .bodyMedium
              //             ?.copyWith(color: MyColors.tertiary),
              //         prefixIcon: Icon(
              //           Icons.search_outlined,
              //           color: Colors.grey.shade700,
              //         ),
              //         focusedBorder: OutlineInputBorder(
              //           borderSide:
              //               BorderSide(color: MyColors.charcoal, width: 3),
              //           borderRadius: BorderRadius.circular(16),
              //         ),
              //         enabledBorder: OutlineInputBorder(
              //           borderSide:
              //               BorderSide(color: MyColors.charcoal, width: 3),
              //           borderRadius: BorderRadius.circular(16),
              //         ),
              //       )),
              // )
              MyButton(
                  label: 'Save',
                  onButtonPressed: () {},
                  color: MyColors.tertiary,
                  width: double.infinity)
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _loadAllUsers() async {
    final projectProvider =
        Provider.of<ProjectProvider>(context, listen: false);
    await projectProvider.fetchAllUsers();

    if (mounted) {
      setState(() {
        _allUsers = projectProvider.users.cast<User>();
      });
    }
  }

  void removeUser(User user) {
    if (mounted) {
      setState(() {
        _selectedUsers.remove(user);
      });
    }
  }
}
