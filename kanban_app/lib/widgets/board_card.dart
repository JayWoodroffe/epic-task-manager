import 'package:flutter/material.dart';
import 'package:kanban_app/providers/auth_provider.dart';
import 'package:kanban_app/features/boards/board_screen.dart';
import 'package:kanban_app/models/board.dart';
import 'package:kanban_app/styles/colors.dart';
import 'package:provider/provider.dart';

//Displays a single Kanban Board title and description
class BoardCard extends StatelessWidget {
  final Board board;
  final void Function(Board) onEditPressed;
  const BoardCard(
      {super.key, required this.board, required this.onEditPressed});

  @override
  Widget build(BuildContext context) {
    //isAdmin is required for conditional display of the edit button (and thus, the ability to edit a project)
    final authProvider = Provider.of<AuthProvider>(context);
    final isAdmin = authProvider.isAdmin;

    return GestureDetector(
        onTap: () {
          //navigate to the board screen (where all the board's lists are displayed) when selected
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return BoardScreen(board: board);
          }));
        },
        child: Container(
          width: MediaQuery.of(context).size.width - 20,
          padding: EdgeInsets.all(10),
          alignment: Alignment.topLeft,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  blurRadius: 0,
                  offset: Offset(5, 7),
                  color: MyColors.tertiary),
            ],
            border: Border.all(width: 3, color: MyColors.tertiary),
            borderRadius: BorderRadius.circular(16),
            color: MyColors.cream,
          ),
          margin: EdgeInsets.only(left: 15, right: 15, top: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //header and edit button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    board.name,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: MyColors.deepGreen,
                        ),
                  ),
                  //edit button only shown to admins
                  if (isAdmin)
                    GestureDetector(
                      onTapDown: (TapDownDetails details) {
                        onEditPressed(board);
                      },
                      child: Icon(Icons.edit),
                    ),
                ],
              ),

              SizedBox(height: 5),
              Text(
                board.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ));
  }
}
