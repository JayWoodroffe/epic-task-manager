import 'package:flutter/material.dart';
import 'package:kanban_app/features/auth/auth_provider.dart';
import 'package:kanban_app/models/project.dart';
import 'package:kanban_app/providers/project_provider.dart';
import 'package:kanban_app/styles/colors.dart';
import 'package:kanban_app/widgets/edit_project_bottom_sheet.dart';
import 'package:kanban_app/widgets/my_button.dart';
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
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final isAdmin = authProvider.isAdmin;
      final projectProvider =
          Provider.of<ProjectProvider>(context, listen: false);

      //distinction here: admins are able to see all projects
      //projects loaded with fetchAllProjects includes additional information (the users associated with the project)
      if (isAdmin) {
        projectProvider.fetchAllProjects();
      } else {
        projectProvider.fetchProjectsForUser();
      }
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
                    onMenuPressed: (context, position, project) {
                      showEditProjectBottomSheet(context, project);
                    });
              },
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndDocked,
      floatingActionButton: (isAdmin)
          ? Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: MyButton(
                label: 'PROJECT',
                onButtonPressed: () {},
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

  void showEditProjectBottomSheet(BuildContext context, Project project) {
    //only allow it to be dismissed by a button (either X or submit)
    showModalBottomSheet(
      isDismissible: false,
      enableDrag: false,
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      //pass the project that was clicked ot the screen
      builder: (context) => EditProjectBottomSheet(project: project),
    );
  }
}
