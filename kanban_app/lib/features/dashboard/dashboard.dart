import 'package:flutter/material.dart';
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
  //static test data
  final List<String> projects = List<String>.generate(
    5,
    (i) => 'Project ${i + 1}',
  );

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
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: projectProvider.projects.length,
              itemBuilder: (context, index) {
                return ProjectCard(project: projectProvider.projects[index]);
              },
            ),

      //TODO: make conditional based on user type
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndDocked,
      floatingActionButton: GestureDetector(
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
      ),
    );
  }
}
