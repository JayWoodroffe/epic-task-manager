import 'package:flutter/material.dart';
import 'package:kanban_app/features/dashboard/list_widget.dart';
import 'package:kanban_app/models/board.dart';
import 'package:kanban_app/models/list.dart';
import 'package:kanban_app/providers/list_provider.dart';
import 'package:kanban_app/styles/colors.dart';
import 'package:kanban_app/widgets/create_task.dart';
import 'package:kanban_app/widgets/my_button.dart';
import 'package:provider/provider.dart';

class BoardScreen extends StatefulWidget {
  final Board board;
  const BoardScreen({super.key, required this.board});

  @override
  State<BoardScreen> createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  bool _isDragging =
      false; //flag to see if a task is being dragged between lists
  late PageController
      _pageController; //for controlling which page is visible - allowing the dragging of tasks between pages

  void setDragging(bool dragging) {
    setState(() {
      _isDragging = dragging;
    });
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      //providers are accessed in initState in order to know which board to fetch
      final listProvider = Provider.of<ListProvider>(context, listen: false);
      listProvider.currentBoardId = widget.board.id;

      //fetching all the boards for the selected project
      listProvider.fetchListsForBoard();
      setState(() {});
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final listProvider = Provider.of<ListProvider>(context);

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
            widget.board.name,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: MyColors.tertiary,
            ),
          ),
        ),
        body: PageView.builder(
          controller: _pageController,
          physics: _isDragging
              ? NeverScrollableScrollPhysics() //disable scrolling between lists while task is being dragged
              : AlwaysScrollableScrollPhysics(),
          itemCount: listProvider.lists.length + 1,
          itemBuilder: (context, index) {
            if (index ==
                listProvider.lists.length) //on the page after all the lists
            {
              return Scaffold(
                body: Center(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: MyButton(
                      label: 'CREATE LIST',
                      onButtonPressed: () => _showCreateListDialog(context),
                      color: MyColors.tertiary,
                      width: double.infinity,
                      height: 40,
                      buttonIcon:
                          Icon(Icons.add, size: 30, color: MyColors.cream),
                    ),
                  ),
                ),
              );
            }
            return ListScreen(
              list: listProvider.lists[index],
              onDragStarted: () => setDragging(true),
              onDragEnded: () => setDragging(false),
              pageController: _pageController,
              currentPageIndex: index,
              totalPages: listProvider.lists.length,
            );
          },
        ));
  }

  //method to display the Create List dialog window
  _showCreateListDialog(BuildContext context) {
    final provider = Provider.of<ListProvider>(context, listen: false);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CreateTask(
              object: "List",
              inputLength: 1,
              onConfirm: (String listName) async {
                //create new list, needs to have a status type
                Navigator.of(context).pop();
                if (listName.trim().isEmpty)
                  return; //can't create an empty task

                final newList = ListType(
                    id: '',
                    name: listName,
                    color: "", //figure out color and status selection
                    position: provider.lists.length,
                    status: "",
                    tasks: []);

                await provider.createList(newList, widget.board.id);
              },
              onCancel: () {
                Navigator.of(context).pop();
              });
        });
  }
}
