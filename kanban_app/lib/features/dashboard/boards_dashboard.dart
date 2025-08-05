import 'package:flutter/material.dart';
import 'package:kanban_app/providers/auth_provider.dart';
import 'package:kanban_app/models/board.dart';
import 'package:kanban_app/models/project.dart';
import 'package:kanban_app/providers/board_provider.dart';
import 'package:kanban_app/styles/colors.dart';
import 'package:kanban_app/widgets/board_card.dart';
import 'package:kanban_app/widgets/edit_board_bottom_screen.dart';
import 'package:kanban_app/widgets/my_button.dart';
import 'package:provider/provider.dart';

//displays all the boards relating to the provided project
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
      boardProvider.currentProjectId = widget.project.id;

      //fetching all the boards for the selected project
      boardProvider.fetchBoardsForProject();

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
              Icons.auto_awesome_rounded,
              size: 40,
              color: MyColors.tertiary,
            )),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          widget.project.name,
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
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
          : boardProvider.boards.isEmpty
              ? Center(child: Text("No boards in this project yet."))
              : ListView.builder(
                  itemCount: boardProvider.boards.length,
                  itemBuilder: (context, index) {
                    return BoardCard(
                        board: boardProvider.boards[index],
                        onEditPressed: (board) {
                          showEditBoardBottomSheet(board);
                        });
                  },
                ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndDocked,
      floatingActionButton: (isAdmin)
          ? Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: MyButton(
                label: 'BOARD',
                onButtonPressed: () {
                  showCreateProjectBottomScreen();
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

  //creating a new empty project and passing it to the modal
  void showCreateProjectBottomScreen() async {
    final emptyBoard = Board(description: "", id: "", name: "");

    final createdBoard = await showModalBottomSheet(
      isDismissible: false,
      enableDrag: false,
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      //pass the project that was clicked ot the screen
      builder: (_) => EditBoardBottomSheet(board: emptyBoard, isEditing: false),
    );

    if (createdBoard != null) {
      try {
        await Provider.of<BoardProvider>(context, listen: false)
            .createBoard(createdBoard, widget.project.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Board created successfully")),
        );
      } catch (e) {
        print("Failed to board project: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to create board: $e")),
        );
      }
    }
  }

  //passsing the selected board to the modal for editing
  void showEditBoardBottomSheet(Board board) async {
    //only allow it to be dismissed by a button (either X or submit)
    final updatedBoard = await showModalBottomSheet(
      isDismissible: false,
      enableDrag: false,
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      //pass the project that was clicked ot the screen
      builder: (_) => EditBoardBottomSheet(board: board, isEditing: true),
    );

    if (updatedBoard != null) {
      try {
        await Provider.of<BoardProvider>(context, listen: false)
            .updateBoard(updatedBoard);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Board saved successfully")),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to save board: $e")),
        );
      }
    }
  }
}
