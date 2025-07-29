import 'package:flutter/material.dart';
import 'package:kanban_app/features/auth/auth_provider.dart';
import 'package:kanban_app/providers/project_provider.dart';
import 'package:kanban_app/styles/colors.dart';
import 'package:kanban_app/widgets/project_card.dart';
import 'package:provider/provider.dart';

//dashboard displays all of the projects that auser has acess to
class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final List<String> projectMenu = ['Delete', 'Edit'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProjectProvider>(context, listen: false)
          .fetchProjectsForUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final isAdmin = authProvider.isAdmin;
    final projectProvider = Provider.of<ProjectProvider>(context);

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
          "Projects",
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: MyColors.tertiary,
              ),
        ),
      ),
      backgroundColor: MyColors.cream,
      body: projectProvider.isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: MyColors.tertiary,
            ))
          : ListView.builder(
              itemCount: projectProvider.projects.length,
              itemBuilder: (context, index) {
                return ProjectCard(
                    project: projectProvider.projects[index],
                    onMenuPressed: _displayProjectMenu);
              },
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndDocked,
      floatingActionButton: (isAdmin)
          ? GestureDetector(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Container(
                  width: 150,
                  height: 40,
                  decoration: BoxDecoration(
                      color: MyColors.secondary,
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
                        "PROJECT",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: MyColors.cream),
                      )
                    ],
                  ),
                ),
              ),
            )
          : null,
    );
  }

  void _displayProjectMenu(BuildContext context, Offset position) {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        position.dx + 1.0,
        position.dy + 1.0,
      ),
      items: <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: projectMenu[0],
          child: Text('${projectMenu[0]}'),
        ),
        PopupMenuItem<String>(
          value: projectMenu[1],
          child: Text('${projectMenu[1]}'),
        ),
      ],
    ).then((String? value) {
      if (value != null) {
        print('Selected: $value');
      }
    });
  }
}
