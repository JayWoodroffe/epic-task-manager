import 'package:flutter/material.dart';
import 'package:kanban_app/features/dashboard/list_widget.dart';

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
        title: Text("Board Name"),
      ),
      body: PageView(
        children: [
          ListScreen(),
          ListScreen(),
          ListScreen(),
        ],
      ),
    );
  }
}
