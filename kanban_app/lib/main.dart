import 'package:flutter/material.dart';
import 'package:kanban_app/features/auth/login_screen.dart';
import 'package:kanban_app/providers/project_provider.dart';
import 'package:kanban_app/styles/themes.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => ProjectProvider())],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Kanban App",
      theme: lightTheme,
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
