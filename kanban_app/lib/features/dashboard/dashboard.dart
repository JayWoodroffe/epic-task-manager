import 'package:flutter/material.dart';
import 'package:kanban_app/styles/colors.dart';
import 'package:kanban_app/widgets/project_card.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Padding(
            padding: EdgeInsets.only(left: 20),
            child: Icon(
              Icons.bolt,
              size: 30,
              color: MyColors.midGreen,
            )),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Projects",
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: MyColors.midGreen,
              ),
        ),
      ),
      backgroundColor: MyColors.mintCream,
      body: ListView.builder(
        itemCount: projects.length,
        itemBuilder: (context, index) {
          return ProjectCard(title: projects[index]);
        },
      ),
    );
  }
}
