import 'package:flutter/material.dart';
import 'package:kanban_app/features/dashboard/list_widget.dart';
import 'package:kanban_app/styles/colors.dart';
import 'package:kanban_app/widgets/create_task.dart';

class BoardScreen extends StatefulWidget {
  const BoardScreen({super.key});

  @override
  State<BoardScreen> createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: EdgeInsets.only(left: 10),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back,
              size: 40,
              color: MyColors.tertiary,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        title: Text(
          "Board Name",
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: MyColors.tertiary,
              ),
        ),
      ),
      body: PageView(
        children: [
          ListScreen(),
          ListScreen(),
          ListScreen(),
          Scaffold(
              body: Center(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: GestureDetector(
                  onTap: () => _showCreateListDialog(context),
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                        color: MyColors.tertiary,
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
                          "CREATE LIST",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: MyColors.cream),
                        )
                      ],
                    ),
                  )),
            ),
          ))
        ],
      ),
    );
  }

  //method to display the Create Task dialog window
  _showCreateListDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CreateTask(
              object: "List",
              inputLength: 1,
              onConfirm: (String taskName) {
                //create new list, needs to have a status type
                Navigator.of(context).pop();
                print(taskName);
              },
              onCancel: () {
                Navigator.of(context).pop();
              });
        });
  }
}
