import 'package:flutter/material.dart';
import 'package:kanban_app/features/auth/auth_provider.dart';
import 'package:kanban_app/models/project.dart';
import 'package:kanban_app/providers/project_provider.dart';
import 'package:kanban_app/styles/colors.dart';
import 'package:kanban_app/widgets/edit_project_bottom_sheet.dart';
import 'package:kanban_app/widgets/my_button.dart';
import 'package:kanban_app/widgets/project_card.dart';
import 'package:provider/provider.dart';

//dashboard displays all of the projects that user has access to
class ProjectDashboard extends StatefulWidget {
  const ProjectDashboard({super.key});

  @override
  State<ProjectDashboard> createState() => _ProjectDashboardState();
}

class _ProjectDashboardState extends State<ProjectDashboard> {
  late bool isAdmin;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //providers are accessed in initState in order to know which projects to fetch
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      isAdmin = authProvider.isAdmin;
      final projectProvider =
          Provider.of<ProjectProvider>(context, listen: false);

      //distinction here: admins are able to see all projects
      //projects loaded with fetchAllProjects includes additional information (the users associated with the project)
      if (isAdmin) {
        projectProvider.fetchAllProjects();
      } else {
        projectProvider.fetchProjectsForUser();
      }

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // final authProvider = Provider.of<AuthProvider>(context);
    // final isAdmin = authProvider.isAdmin;
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
                onButtonPressed: () {
                  showCreateProjectBottomScreen(context);
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
  void showCreateProjectBottomScreen(BuildContext context) async {
    final emptyProject = Project(description: "", id: "", name: "", users: []);

    final createdProject = await showModalBottomSheet(
      isDismissible: false,
      enableDrag: false,
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      //pass the project that was clicked ot the screen
      builder: (_) =>
          EditProjectBottomSheet(project: emptyProject, isEditing: false),
    );

    if (createdProject != null) {
      try {
        await Provider.of<ProjectProvider>(context, listen: false)
            .createProject(createdProject);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Project created successfully")),
        );
      } catch (e) {
        print("Failed to create project: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to create project: $e")),
        );
      }
    }
  }

  //passsing the selected project to the modal for editing
  void showEditProjectBottomSheet(BuildContext context, Project project) async {
    //only allow it to be dismissed by a button (either X or submit)
    final updatedProject = await showModalBottomSheet(
      isDismissible: false,
      enableDrag: false,
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      //pass the project that was clicked ot the screen
      builder: (_) => EditProjectBottomSheet(project: project, isEditing: true),
    );

    if (updatedProject != null) {
      try {
        await Provider.of<ProjectProvider>(context, listen: false)
            .updateProject(updatedProject);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Project saved successfully")),
        );
      } catch (e) {
        print("Failed to save project: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to save project: $e")),
        );
      }
    }
  }
}
