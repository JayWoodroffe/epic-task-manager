import 'package:flutter/material.dart';
import 'package:kanban_app/features/auth/auth_provider.dart';
import 'package:kanban_app/models/board.dart';
import 'package:kanban_app/models/project.dart';
import 'package:kanban_app/providers/board_provider.dart';
import 'package:kanban_app/styles/colors.dart';
import 'package:kanban_app/widgets/board_card.dart';
import 'package:kanban_app/widgets/my_button.dart';
import 'package:provider/provider.dart';

class BoardsDashboard extends StatefulWidget {
  final Project project;
  const BoardsDashboard({super.key, required this.project});

  @override
  State<BoardsDashboard> createState() => _BoardsDashboardState();
}

class _BoardsDashboardState extends State<BoardsDashboard> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //providers are accessed in initState in order to know which projects to fetch
      final boardProvider = Provider.of<BoardProvider>(context, listen: false);

      //fetching all the boards for the selected project
      boardProvider.fetchBoardsForProject(widget.project.id);

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    //for conditional controls based on admin role
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final isAdmin = authProvider.isAdmin;

    final boardProvider = Provider.of<BoardProvider>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Padding(
            padding: EdgeInsets.only(left: 10),
            child: Icon(
              Icons.bolt,
              size: 50,
              color: MyColors.tertiary,
            )),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Boards for ${widget.project.name}",
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: MyColors.tertiary,
              ),
        ),
      ),
      backgroundColor: Colors.white,
      body: boardProvider.isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: MyColors.tertiary,
            ))
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
                childAspectRatio: 1.0, // Square items
              ),
              itemCount: boardProvider.boards.length,
              itemBuilder: (context, index) {
                return BoardCard(
                    board: boardProvider.boards[index],
                    onEditPressed: (board) {
                      //define editing a board popup (modal?)
                    });
              },
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndDocked,
      floatingActionButton: (isAdmin)
          ? Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: MyButton(
                label: 'Board',
                onButtonPressed: () {
                  //create new board
                },
                color: MyColors.secondary,
                width: 150,
                height: 40,
                buttonIcon: Icon(
                  Icons.add,
                  size: 30,
                  color: MyColors.cream,
                  weight: 50,
                ),
              ),
            )
          : null,
    );
  }
}
